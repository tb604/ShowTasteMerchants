//
//  TYZKVStorage.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZKVStorage.h"
#import "UIApplication+TYZAdd.h"
#import <UIKit/UIKit.h>
#import <time.h>

#if __has_include(<sqlite3.h>)
#import <sqlite3.h>
#else
#import "sqlite3.h"
#endif

/// 最大错误重试计数
static const NSUInteger kMaxErrorRetryCount = 8;
/// 最小重试时间
static const NSTimeInterval kMinRetryTimeInterval = 2.0;
/// 路径的最大长度
static const int kPathLengthMax = PATH_MAX - 64;
/// 数据库名
static NSString *const kDBFileName = @"manifest.sqlite";
/// 共享存储
static NSString *const kDBShmFileName = @"manifest.sqlite-shm";
/// 预写式日志
static NSString *const kDBWalFileName = @"manifest.sqlite-wal";
/// 数据目录名称
static NSString *const kDataDirectoryName = @"data";
/// 垃圾目录名称
static NSString *const kTrashDirectoryName = @"trash";



/*
 File:
 /path/
      /manifest.sqlite
      /manifest.sqlite-shm
      /manifest.sqlite-wal
      /data/
           /e10adc3949ba59abbe56e057f20f883e
           /e10adc3949ba59abbe56e057f20f883e
      /trash/
            /unused_file_or_folder
 
 SQL:
 create table if not exists manifest (
 key                 text,
 filename            text,
 size                integer,
 inline_data         blob,
 modification_time   integer,
 last_access_time    integer,
 extended_data       blob,
 primary key(key)
 );
 create index if not exists last_access_time_idx on manifest(last_access_time);
 */


@implementation TYZKVStorageItem
@end

@implementation TYZKVStorage
{
    /**
     *  垃圾队列。
     */
    dispatch_queue_t _trashQueue;
    
    /// 路径
    NSString *_path;
    
    /// 数据库路径
    NSString *_dbPath;
    
    /// 数据路径
    NSString *_dataPath;
    
    /// 垃圾数据路径
    NSString *_trashPath;
    
    sqlite3 *_db;
    
    /// 数据库语句缓存
    CFMutableDictionaryRef _dbStmtCache;
    
    /// 数据库最后一次打开错误的时间
    NSTimeInterval _dbLastOpenErrorTime;
    
    /// 数据库打开错误的次数
    NSUInteger _dbOpenErrorCount;
    
    // 无效
//    BOOL _invalidated; ///< If YES, then the db should not open again, all read/write should be ignored.(如果YES,那么数据库不应该重新开放,所有的读/写应该被忽略。)
    
//    BOOL _dbIsClosing; ///< If YES, then db is during closing.(如果是,则在关闭数据库。)
    
}

#pragma mark - db
/*
 NSDate 属于Foundation
 CFAbsoluteTimeGetCurrent() 属于 CoreFoundatio
 CACurrentMediaTime() 属于 QuartzCore
 
 本质区别：
 NSDate 或 CFAbsoluteTimeGetCurrent() 返回的时钟时间将会会网络时间同步，从时钟 偏移量的角度，mach_absolute_time() 和 CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置。
 
 常见用法：
 NSDate、CFAbsoluteTimeGetCurrent（）常用于日常时间、时间戳的表示，与服务器之间的数据交互
 其中 CFAbsoluteTimeGetCurrent() 相当于[[NSDate data] timeIntervalSinceReferenceDate];
 CACurrentMediaTime() 常用于测试代码的效率
 */

- (BOOL)_dbOpen
{
    if (_db)
    {
        return YES;
    }
    int result = sqlite3_open(_dbPath.UTF8String, &_db);
    if (result == SQLITE_OK)
    {// 打开数据库成功
        CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = {0};
        _dbStmtCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &keyCallbacks, &valueCallbacks);
        _dbLastOpenErrorTime = 0;
        _dbOpenErrorCount = 0;
        return YES;
    }
    else
    {// 打开数据库失败
        _db = NULL;
        if (_dbStmtCache)
        {
            CFRelease(_dbStmtCache);
            _dbStmtCache = NULL;
        }
        _dbLastOpenErrorTime = CACurrentMediaTime();
        _dbOpenErrorCount++;
        
        if (_errorLogsEnabled)
        {
            NSLog(@"%s line:%d sqlite open failed (%d).", __func__, __LINE__, result);
        }
        return NO;
    }
    /*BOOL shouldOpen = YES;
    if (_invalidated)
    {
        shouldOpen = NO;
    }
    else if (_dbIsClosing)
    {
        shouldOpen = NO;
    }
    else if (_db)
    {
        shouldOpen = NO;
    }
    
    if (!shouldOpen)
    {
        return YES;
    }
    
    int result = sqlite3_open(_dbPath.UTF8String, &_db);
    if (result == SQLITE_OK)
    {
        CFDictionaryKeyCallBacks keyCallbacks = kCFCopyStringDictionaryKeyCallBacks;
        CFDictionaryValueCallBacks valueCallbacks = {0};
        _dbStmtCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &keyCallbacks, &valueCallbacks);
        return YES;
    }
    else
    {
        NSLog(@"%s line:%d sqlite open failed (%d).", __func__, __LINE__, result);
        return NO;
    }
     */
}

- (BOOL)_dbClose
{
    if (!_db)
    {
        return YES;
    }
    
    int result = 0; //
    BOOL retry = NO; /// 是否重试
    BOOL stmtFinalized = NO; // 没有完成
    
    if (_dbStmtCache)
    {
        CFRelease(_dbStmtCache);
        _dbStmtCache = NULL;
    }
    
    do {
        retry = NO;
        result = sqlite3_close(_db);
        if (result == SQLITE_BUSY || result == SQLITE_LOCKED)
        {// 数据库繁忙、锁住
            if (!stmtFinalized)
            {
                stmtFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(_db, nil)) != 0)
                {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        }
        else if (result != SQLITE_OK)
        {
            if (_errorLogsEnabled)
            {
                NSLog(@"%s line:%d sqlite close failed (%d).", __FUNCTION__, __LINE__, result);
            }
        }
    } while (retry);
    _db = NULL;
    return YES;
    
    /*BOOL needClose = YES;
    if (!_db)
    {
        needClose = NO;
    }
    else if (_invalidated)
    {
        needClose = NO;
    }
    else if (_dbIsClosing)
    {
        needClose = NO;
    }
    else
    {
        _dbIsClosing = YES;
    }
    if (!needClose)
    {
        return YES;
    }
    
    int result = 0;
    BOOL retry = NO;
    BOOL stmtFinalized = NO;
    if (_dbStmtCache)
    {
        CFRelease(_dbStmtCache);
        _dbStmtCache = NULL;
    }
    
    do
    {
        retry = NO;
        result = sqlite3_close(_db);
        if (result == SQLITE_BUSY || result == SQLITE_LOCKED)
        {
            if (!stmtFinalized)
            {
                stmtFinalized = YES;
                sqlite3_stmt *stmt;
                while ((stmt = sqlite3_next_stmt(_db, nil)) != 0)
                {
                    sqlite3_finalize(stmt);
                    retry = YES;
                }
            }
        }
        else if (result != SQLITE_OK)
        {
            NSLog(@"%s line:%d sqlite close failed (%d).", __func__, __LINE__, result);
        }
    } while (retry);
    _db = NULL;
    _dbIsClosing = NO;
    return YES;*/
}

/*- (BOOL)_dbIsReady
{
    return (_db && !_dbIsClosing && !_invalidated);
}*/

- (BOOL)_dbCheck
{
    if (!_db)
    {
        // 打开的错误次数小于规定的最大错误次数
        if ((_dbOpenErrorCount < kMaxErrorRetryCount) && ((CACurrentMediaTime() - _dbLastOpenErrorTime) > kMinRetryTimeInterval))
        {
            return [self _dbOpen] && [self _dbInitialize];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)_dbInitialize
{
    /*
     pragma synchronous = normal
     0 或 OFF	不进行同步。
     1 或 NORMAL	在关键的磁盘操作的每个序列后同步。
     2 或 FULL	在每个关键的磁盘操作后同步。
     */
    NSString *sql = @"pragma journal_mode = wal; pragma synchronous = normal; create table if not exists manifest (key text, filename text, size integer, inline_data blob, modification_time integer, last_access_time integer, extended_data blob, primary key(key)); create index if not exists last_access_time_idx on manifest(last_access_time);";
    return [self _dbExecute:sql];
}

- (void)_dbCheckpoint
{
    if (![self _dbCheck])
    {
        return;
    }
    // Cause a checkpoint to occur, merge 'sqlite-wal' file to 'sqlite' file.
    sqlite3_wal_checkpoint(_db, NULL);
}

- (BOOL)_dbExecute:(NSString *)sql
{
    if (sql.length == 0)
    {
        return NO;
    }
    if (![self _dbCheck])
    {
        return NO;
    }
    
    char *error = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    if (error)
    {
        if (_errorLogsEnabled)
        {
            NSLog(@"%s line:%d sqlite exec error (%d): %s", __func__, __LINE__, result, error);
        }
        sqlite3_free(error);
    }
    return result == SQLITE_OK;
}

- (sqlite3_stmt *)_dbPrepareStmt:(NSString *)sql
{
    if (![self _dbCheck] || sql.length == 0 || !_dbStmtCache)
    {
        return NULL;
    }
    sqlite3_stmt *stmt = (sqlite3_stmt *)CFDictionaryGetValue(_dbStmtCache, (__bridge const void *)(sql));
    if (!stmt)
    {
        int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
        if (result != SQLITE_OK)
        {
            if (_errorLogsEnabled)
            {
                NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __func__, __LINE__, result, sqlite3_errmsg(_db));
                return NULL;
            }
        }
        CFDictionarySetValue(_dbStmtCache, (__bridge const void *)(sql), stmt);
    }
    else
    {
        sqlite3_reset(stmt);
    }
    return stmt;
}

/**
 * 把键数组，变成 “"err","rttt","yyt"”
 */
- (NSString *)_dbJoinedKeys:(NSArray *)keys
{
    NSMutableString *string = [NSMutableString new];
    for (NSUInteger i = 0,max = keys.count; i < max; i++)
    {
        [string appendString:@"?"];
        if (i + 1 != max)
        {
            [string appendString:@","];
        }
    }
    return string;
}

- (void)_dbBindJoinedKeys:(NSArray *)keys stmt:(sqlite3_stmt *)stmt fromIndex:(int)index
{
    for (int i=0, max = (int)keys.count; i<max; i++)
    {
        NSString *key = keys[i];
        sqlite3_bind_text(stmt, index + i, key.UTF8String, -1, NULL);
    }
}

/**
 *  保存数据到数据库
 *  @param key key
 *  @param value 值
 *  @param fileName 文件名
 *  @param extendedData 扩展数据
 */
- (BOOL)_dbSaveWithKey:(NSString *)key value:(NSData *)value fileName:(NSString *)fileName extendedData:(NSData *)extendedData
{
    NSString *sql = @"insert or replace into manifest (key, filename, size, inline_data, modification_time, last_access_time, extended_data) values (?1, ?2, ?3, ?4, ?5, ?6, ?7);";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    
    int timestamp = (int)time(NULL);
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    sqlite3_bind_text(stmt, 2, fileName.UTF8String, -1, NULL);
    sqlite3_bind_int(stmt, 3, (int)value.length);
    if (fileName.length == 0)
    {
        sqlite3_bind_blob(stmt, 4, value.bytes, (int)value.length, 0);
    }
    else
    {
        sqlite3_bind_blob(stmt, 4, NULL, 0, 0);
    }
    sqlite3_bind_int(stmt, 5, timestamp);
    sqlite3_bind_int(stmt, 6, timestamp);
    sqlite3_bind_blob(stmt, 7, extendedData.bytes, (int)extendedData.length, 0);
    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled)
            NSLog(@"%s line:%d sqlite insert error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  更新访问时间
 *
 *  @param key 键
 */
- (BOOL)_dbUpdateAccessTimeWithKey:(NSString *)key
{
    NSString *sql = @"update manifest set last_access_time = ?1 where key = ?2;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_int(stmt, 1, (int)time(NULL)); // time(NULL)获取系统时间，单位为秒
    sqlite3_bind_text(stmt, 2, key.UTF8String, -1, NULL);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite update error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  更新键数组的访问时间
 *
 *  @param keys 键数组
 */
- (BOOL)_dbUpdateAccessTimeWithKeys:(NSArray *)keys
{
    if (![self _dbCheck]) return NO;
//    time_t long
    int t = (int)time(NULL); // 获取系统时间，单位为秒
    NSString *sql = [NSString stringWithFormat:@"update manifest set last_access_time = %d where key in (%@);", t, [self _dbJoinedKeys:keys]];
    
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        if (_errorLogsEnabled)  NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite update error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  根据key从数据库中对应的数据
 */
- (BOOL)_dbDeleteItemWithKey:(NSString *)key
{
    NSString *sql = @"delete from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d db delete error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  从键数组中删除对应的数据
 */
- (BOOL)_dbDeleteItemWithKeys:(NSArray *)keys
{
    if (![self _dbCheck]) return NO;
    NSString *sql =  [NSString stringWithFormat:@"delete from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    result = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    if (result == SQLITE_ERROR)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite delete error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  从数据库中删除大于size大小的数据
 *  @param size nsdata 的大小
 */
- (BOOL)_dbDeleteItemsWithSizeLargerThan:(int)size
{
    NSString *sql = @"delete from manifest where size > ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_int(stmt, 1, size);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite delete error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  从数据库中删除小于time时间的数据
 *  @param time 秒
 */
- (BOOL)_dbDeleteItemsWithTimeEarlierThan:(int)time
{
    NSString *sql = @"delete from manifest where last_access_time < ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return NO;
    sqlite3_bind_int(stmt, 1, time);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_DONE)
    {
        if (_errorLogsEnabled)  NSLog(@"%s line:%d sqlite delete error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return NO;
    }
    return YES;
}

/**
 *  从数据库中得到一项数据
 *  @param stmt 语句
 *  @param excludeInlineData 是否排除内联数据
 */
- (TYZKVStorageItem *)_dbGetItemFromStmt:(sqlite3_stmt *)stmt excludeInlineData:(BOOL)excludeInlineData
{
    int i = 0;
    char *key = (char *)sqlite3_column_text(stmt, i++);
    char *filename = (char *)sqlite3_column_text(stmt, i++);
    int size = sqlite3_column_int(stmt, i++);
    const void *inline_data = excludeInlineData ? NULL : sqlite3_column_blob(stmt, i);
    int inline_data_bytes = excludeInlineData ? 0 : sqlite3_column_bytes(stmt, i++);
    int modification_time = sqlite3_column_int(stmt, i++);
    int last_access_time = sqlite3_column_int(stmt, i++);
    const void *extended_data = sqlite3_column_blob(stmt, i);
    int extended_data_bytes = sqlite3_column_bytes(stmt, i++);
    
    TYZKVStorageItem *item = [TYZKVStorageItem new];
    if (key)
    {
        item.key = [NSString stringWithUTF8String:key];
    }
    if (filename && *filename != 0)
    {
        item.filename = [NSString stringWithUTF8String:filename];
    }
    item.size = size;
    if (inline_data_bytes > 0 && inline_data)
    {
        item.value = [NSData dataWithBytes:inline_data length:inline_data_bytes];
    }
    item.modTime = modification_time;
    item.accessTime = last_access_time;
    if (extended_data_bytes > 0 && extended_data)
    {
        item.extendedData = [NSData dataWithBytes:extended_data length:extended_data_bytes];
    }
    return item;
}

/**
 *  通过键从数据库中获取一项数据
 *
 *  @param key 键
 *  @param excludeInlineData 是否排除内联数据
 */
- (TYZKVStorageItem *)_dbGetItemWithKey:(NSString *)key excludeInlineData:(BOOL)excludeInlineData
{
    NSString *sql = excludeInlineData ? @"select key, filename, size, modification_time, last_access_time, extended_data from manifest where key = ?1;" : @"select key, filename, size, inline_data, modification_time, last_access_time, extended_data from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    TYZKVStorageItem *item = nil;
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW)
    {
        item = [self _dbGetItemFromStmt:stmt excludeInlineData:excludeInlineData];
    }
    else
    {
        if (result != SQLITE_DONE)
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        }
    }
    return item;
}

/**
 *  通过键从数据库中获取一组数据
 *
 *  @param keys 键数组
 *  @param excludeInlineData 是否排除内联数据
 */
- (NSMutableArray *)_dbGetItemWithKeys:(NSArray *)keys excludeInlineData:(BOOL)excludeInlineData
{
    if (![self _dbCheck]) return nil;
    NSString *sql;
    if (excludeInlineData)
    {
        sql = [NSString stringWithFormat:@"select key, filename, size, modification_time, last_access_time, extended_data from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    }
    else
    {
        sql = [NSString stringWithFormat:@"select key, filename, size, inline_data, modification_time, last_access_time, extended_data from manifest where key in (%@)", [self _dbJoinedKeys:keys]];
    }
    
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return nil;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSMutableArray *items = [NSMutableArray new];
    do {
        result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            TYZKVStorageItem *item = [self _dbGetItemFromStmt:stmt excludeInlineData:excludeInlineData];
            if (item) [items addObject:item];
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            if (_errorLogsEnabled)
            {
                NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            }
            items = nil;
            break;
        }
    } while (1);
    sqlite3_finalize(stmt);
    return items;
}

/**
 *  根据键从数据库中得到值
 *
 *  @param key 键
 *  @return 返回 NSData数据
 */
- (NSData *)_dbGetValueWithKey:(NSString *)key
{
    NSString *sql = @"select inline_data from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW)
    {
        const void *inline_data = sqlite3_column_blob(stmt, 0);
        int inline_data_bytes = sqlite3_column_bytes(stmt, 0);
        if (!inline_data || inline_data_bytes <= 0) return nil;
        return [NSData dataWithBytes:inline_data length:inline_data_bytes];
    }
    else
    {
        if (result != SQLITE_DONE)
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        }
        return nil;
    }
}

/**
 *  根据键从数据库中得到文件名
 *
 *  @param key 键
 *  @return 返回 文件名
 */
- (NSString *)_dbGetFilenameWithKey:(NSString *)key
{
    NSString *sql = @"select filename from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    int result = sqlite3_step(stmt);
    if (result == SQLITE_ROW)
    {
        char *filename = (char *)sqlite3_column_text(stmt, 0);
        if (filename && *filename != 0)
        {
            return [NSString stringWithUTF8String:filename];
        }
    }
    else
    {
        if (result != SQLITE_DONE)
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        }
    }
    return nil;
}

/**
 *  根据键组得到文件数组
 */
- (NSMutableArray *)_dbGetFilenameWithKeys:(NSArray *)keys
{
    if (![self _dbCheck]) return nil;
    NSString *sql = [NSString stringWithFormat:@"select filename from manifest where key in (%@);", [self _dbJoinedKeys:keys]];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL);
    if (result != SQLITE_OK)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite stmt prepare error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return nil;
    }
    
    [self _dbBindJoinedKeys:keys stmt:stmt fromIndex:1];
    NSMutableArray *filenames = [NSMutableArray new];
    do
    {
        result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            char *filename = (char *)sqlite3_column_text(stmt, 0);
            if (filename && *filename != 0)
            {
                NSString *name = [NSString stringWithUTF8String:filename];
                if (name) [filenames addObject:name];
            }
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            filenames = nil;
            break;
        }
    } while (1);
    sqlite3_finalize(stmt);
    return filenames;
}

/**
 *  得到文件名数组
 */
- (NSMutableArray *)_dbGetFilenamesWithSizeLargerThan:(int)size
{
    NSString *sql = @"select filename from manifest where size > ?1 and filename is not null;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_int(stmt, 1, size);
    
    NSMutableArray *filenames = [NSMutableArray new];
    do {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            char *filename = (char *)sqlite3_column_text(stmt, 0);
            if (filename && *filename != 0)
            {
                NSString *name = [NSString stringWithUTF8String:filename];
                if (name) [filenames addObject:name];
            }
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            filenames = nil;
            break;
        }
    } while (1);
    return filenames;
}

/**
 *  得到文件名数组
 */
- (NSMutableArray *)_dbGetFilenamesWithTimeEarlierThan:(int)time
{
    NSString *sql = @"select filename from manifest where last_access_time < ?1 and filename is not null;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_int(stmt, 1, time);
    
    NSMutableArray *filenames = [NSMutableArray new];
    do {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            char *filename = (char *)sqlite3_column_text(stmt, 0);
            if (filename && *filename != 0)
            {
                NSString *name = [NSString stringWithUTF8String:filename];
                if (name) [filenames addObject:name];
            }
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            filenames = nil;
            break;
        }
    } while (1);
    return filenames;
}

- (NSMutableArray *)_dbGetItemSizeInfoOrderByTimeDescWithLimit:(int)count
{
    NSString *sql = @"select key, filename, size from manifest order by last_access_time desc limit ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return nil;
    sqlite3_bind_int(stmt, 1, count);
    
    NSMutableArray *items = [NSMutableArray new];
    do {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_ROW)
        {
            char *key = (char *)sqlite3_column_text(stmt, 0);
            char *filename = (char *)sqlite3_column_text(stmt, 1);
            int size = sqlite3_column_int(stmt, 2);
            TYZKVStorageItem *item = [TYZKVStorageItem new];
            item.key = key ? [NSString stringWithUTF8String:key] : nil;
            item.filename = filename ? [NSString stringWithUTF8String:filename] : nil;
            item.size = size;
            [items addObject:item];
        }
        else if (result == SQLITE_DONE)
        {
            break;
        }
        else
        {
            if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
            items = nil;
            break;
        }
    } while (1);
    return items;
}

/**
 *  根据键，得到这个键在数据库中的条数
 */
- (int)_dbGetItemCountWithKey:(NSString *)key
{
    NSString *sql = @"select count(key) from manifest where key = ?1;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return -1;
    sqlite3_bind_text(stmt, 1, key.UTF8String, -1, NULL);
    int result = sqlite3_step(stmt);
    if (result != SQLITE_ROW)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return -1;
    }
    return sqlite3_column_int(stmt, 0);
}

/**
 *  得到数据库中存储的数据的大小(size)
 */
- (int)_dbGetTotalItemSize
{
    NSString *sql = @"select sum(size) from manifest;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return -1;
    int result = sqlite3_step(stmt);
    if (result != SQLITE_ROW)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return -1;
    }
    return sqlite3_column_int(stmt, 0);
}

/**
 *  得到总的条数
 */
- (int)_dbGetTotalItemCount
{
    NSString *sql = @"select count(*) from manifest;";
    sqlite3_stmt *stmt = [self _dbPrepareStmt:sql];
    if (!stmt) return -1;
    int result = sqlite3_step(stmt);
    if (result != SQLITE_ROW)
    {
        if (_errorLogsEnabled) NSLog(@"%s line:%d sqlite query error (%d): %s", __FUNCTION__, __LINE__, result, sqlite3_errmsg(_db));
        return -1;
    }
    return sqlite3_column_int(stmt, 0);
}


#pragma mark - file
/**
 *  把数据写入文件
 *
 *  @param filename 文件名
 *  @param data 数据
 */
- (BOOL)_fileWriteWithName:(NSString *)filename data:(NSData *)data
{
//    if (_invalidated) return NO;
    NSString *path = [_dataPath stringByAppendingPathComponent:filename];
    return [data writeToFile:path atomically:NO];
}

/**
 *  根据文件名读取数据
 *
 *  @param filename 文件名
 */
- (NSData *)_fileReadWithName:(NSString *)filename
{
//    if (_invalidated) return nil;
    NSString *path = [_dataPath stringByAppendingPathComponent:filename];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

/**
 *  根据文件名，删除这个文件
 *
 *  @param filename 文件名
 *  @return 返回是否删除成功
 */
- (BOOL)_fileDeleteWithName:(NSString *)filename
{
//    if (_invalidated) return NO;
    NSString *path = [_dataPath stringByAppendingPathComponent:filename];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

/**
 *  删除所有的垃圾数据
 */
- (BOOL)_fileMoveAllToTrash
{
//    if (_invalidated) return NO;
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuid = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *tmpPath = [_trashPath stringByAppendingPathComponent:(__bridge NSString *)(uuid)];
    BOOL suc = [[NSFileManager defaultManager] moveItemAtPath:_dataPath toPath:tmpPath error:nil];
    if (suc)
    {
        suc = [[NSFileManager defaultManager] createDirectoryAtPath:_dataPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    CFRelease(uuid);
    return suc;
}

/**
 *  在后台删除所有的垃圾文件
 */
- (void)_fileEmptyTrashInBackground
{
//    if (_invalidated) return;
    NSString *trashPath = _trashPath;
    dispatch_queue_t queue = _trashQueue;
    dispatch_async(queue, ^{
        NSFileManager *manager = [NSFileManager new];
        NSArray *directoryContents = [manager contentsOfDirectoryAtPath:trashPath error:NULL];
        for (NSString *path in directoryContents)
        {
            NSString *fullPath = [trashPath stringByAppendingPathComponent:path];
            [manager removeItemAtPath:fullPath error:NULL];
        }
    });
}

#pragma mark - private

/**
 Delete all files and empty in background.
 Make sure the db is closed.
 */
- (void)_reset
{
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBFileName] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBShmFileName] error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:[_path stringByAppendingPathComponent:kDBWalFileName] error:nil];
    [self _fileMoveAllToTrash];
    [self _fileEmptyTrashInBackground];
}

// 程序将要终止的时候调用
//- (void)_appWillBeTerminated
//{
//    _invalidated = YES;
//}

#pragma mark - public

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"TYZKVStorage init error" reason:@"Please use the designated initializer and pass the 'path' and 'type'." userInfo:nil];
    return [self initWithPath:nil type:TYZKVStorageTypeFile];
}

- (instancetype)initWithPath:(NSString *)path type:(TYZKVStorageType)type
{
    if (path.length == 0 || path.length > kPathLengthMax)
    {
        NSLog(@"TYZKVStorage init error: invalid path: [%@].", path);
        return nil;
    }
    if (type > TYZKVStorageTypeMixed)
    {
        NSLog(@"YYKVStorage init error: invalid type: %lu.", (unsigned long)type);
        return nil;
    }
    
    self = [super init];
    _path = path.copy;
    _type = type;
    _dataPath = [path stringByAppendingPathComponent:kDataDirectoryName];
    _trashPath = [path stringByAppendingPathComponent:kTrashDirectoryName];
    _trashQueue = dispatch_queue_create("com.tangbin.cache.disk.trash", DISPATCH_QUEUE_SERIAL);
    _dbPath = [path stringByAppendingPathComponent:kDBFileName];
    _errorLogsEnabled = YES;
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error] ||
        ![[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:kDataDirectoryName]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error] ||
        ![[NSFileManager defaultManager] createDirectoryAtPath:[path stringByAppendingPathComponent:kTrashDirectoryName]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
            NSLog(@"TYZKVStorage init error:%@", error);
            return nil;
        }
    
    if (![self _dbOpen] || ![self _dbInitialize])
    {
        // db file may broken...
        [self _dbClose];
        [self _reset]; // rebuild
        if (![self _dbOpen] || ![self _dbInitialize])
        {
            [self _dbClose];
            NSLog(@"TYZKVStorage init error: fail to open sqlite db.");
        }
        return nil;
    }
    [self _fileEmptyTrashInBackground]; // empty the trash if failed at last time
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appWillBeTerminated) name:UIApplicationWillTerminateNotification object:nil];
    return self;
}

- (void)dealloc
{
    UIBackgroundTaskIdentifier taskID = [[UIApplication sharedExtensionApplication] beginBackgroundTaskWithExpirationHandler:^{}];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [self _dbClose];
    if (taskID != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedExtensionApplication] endBackgroundTask:taskID];
    }
}

- (BOOL)saveItem:(TYZKVStorageItem *)item
{
    return [self saveItemWithKey:item.key value:item.value filename:item.filename extendedData:item.extendedData];
}

- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value
{
    return [self saveItemWithKey:key value:value filename:nil extendedData:nil];
}

- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value filename:(NSString *)filename extendedData:(NSData *)extendedData
{
    if (key.length == 0 || value.length == 0) return NO;
    if (_type == TYZKVStorageTypeFile && filename.length == 0)
    {
        return NO;
    }
    
    if (filename.length)
    {
        if (![self _fileWriteWithName:filename data:value])
        {
            return NO;
        }
        if (![self _dbSaveWithKey:key value:value fileName:filename extendedData:extendedData])
        {
            [self _fileDeleteWithName:filename];
            return NO;
        }
        return YES;
    }
    else
    {
        if (_type != TYZKVStorageTypeSQLite)
        {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename)
            {
                [self _fileDeleteWithName:filename];
            }
        }
        return [self _dbSaveWithKey:key value:value fileName:nil extendedData:extendedData];
    }
}

- (BOOL)removeItemForKey:(NSString *)key
{
    if (key.length == 0) return NO;
    switch (_type)
    {
        case TYZKVStorageTypeSQLite:
        {
            return [self _dbDeleteItemWithKey:key];
        } break;
        case TYZKVStorageTypeFile:
        case TYZKVStorageTypeMixed:
        {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename)
            {
                [self _fileDeleteWithName:filename];
            }
            return [self _dbDeleteItemWithKey:key];
        } break;
        default: return NO;
    }
}

- (BOOL)removeItemForKeys:(NSArray *)keys
{
    if (keys.count == 0) return NO;
    switch (_type)
    {
        case TYZKVStorageTypeSQLite:
        {
            return [self _dbDeleteItemWithKeys:keys];
        } break;
        case TYZKVStorageTypeFile:
        case TYZKVStorageTypeMixed:
        {
            NSArray *filenames = [self _dbGetFilenameWithKeys:keys];
            for (NSString *filename in filenames)
            {
                [self _fileDeleteWithName:filename];
            }
            return [self _dbDeleteItemWithKeys:keys];
        } break;
        default: return NO;
    }
}

- (BOOL)removeItemsLargerThanSize:(int)size
{
    if (size == INT_MAX) return YES;
    if (size <= 0) return [self removeAllItems];
    
    switch (_type)
    {
        case TYZKVStorageTypeSQLite:
        {
            if ([self _dbDeleteItemsWithSizeLargerThan:size])
            {
                [self _dbCheckpoint];
                return YES;
            }
        } break;
        case TYZKVStorageTypeFile:
        case TYZKVStorageTypeMixed:
        {
            NSArray *filenames = [self _dbGetFilenamesWithSizeLargerThan:size];
            for (NSString *name in filenames)
            {
                [self _fileDeleteWithName:name];
            }
            if ([self _dbDeleteItemsWithSizeLargerThan:size])
            {
                [self _dbCheckpoint];
                return YES;
            }
        } break;
    }
    return NO;
}

- (BOOL)removeItemsEarlierThanTime:(int)time
{
    if (time <= 0) return YES;
    if (time == INT_MAX) return [self removeAllItems];
    
    switch (_type)
    {
        case TYZKVStorageTypeSQLite:
        {
            if ([self _dbDeleteItemsWithTimeEarlierThan:time])
            {
                [self _dbCheckpoint];
                return YES;
            }
        } break;
        case TYZKVStorageTypeFile:
        case TYZKVStorageTypeMixed:
        {
            NSArray *filenames = [self _dbGetFilenamesWithTimeEarlierThan:time];
            for (NSString *name in filenames)
            {
                [self _fileDeleteWithName:name];
            }
            if ([self _dbDeleteItemsWithTimeEarlierThan:time])
            {
                [self _dbCheckpoint];
                return NO;
            }
        } break;
    }
    return NO;
}

- (BOOL)removeItemsToFitSize:(int)maxSize
{
    if (maxSize == INT_MAX) return YES;
    if (maxSize <= 0) return [self removeAllItems];
    
    int total = [self _dbGetTotalItemSize];
    if (total < 0) return NO;
    if (total <= maxSize) return YES;
    
    NSArray *items = nil;
    BOOL suc = NO;
    do {
        int perCount = 16;
        items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
        for (TYZKVStorageItem *item in items)
        {
            if (total > maxSize)
            {
                if (item.filename)
                {
                    [self _fileDeleteWithName:item.filename];
                }
                suc = [self _dbDeleteItemWithKey:item.key];
                total -= item.size;
            }
            else
            {
                break;
            }
            if (!suc) break;
        }
    } while (total > maxSize && items.count > 0 && suc);
    if (suc) [self _dbCheckpoint];
    return suc;
}

- (BOOL)removeItemsToFitCount:(int)maxCount
{
    if (maxCount == INT_MAX) return YES;
    if (maxCount <= 0) return [self removeAllItems];
    
    int total = [self _dbGetTotalItemCount];
    if (total < 0) return NO;
    if (total <= maxCount) return YES;
    
    NSArray *items = nil;
    BOOL suc = NO;
    do {
        int perCount = 16;
        items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
        for (TYZKVStorageItem *item in items)
        {
            if (total > maxCount)
            {
                if (item.filename)
                {
                    [self _fileDeleteWithName:item.filename];
                }
                suc = [self _dbDeleteItemWithKey:item.key];
                total--;
            }
            else
            {
                break;
            }
            if (!suc) break;
        }
    } while (total > maxCount && items.count > 0 && suc);
    if (suc) [self _dbCheckpoint];
    return suc;
}

- (BOOL)removeAllItems
{
    if (![self _dbClose]) return NO;
    [self _reset];
    if (![self _dbOpen]) return NO;
    if (![self _dbInitialize]) return NO;
    return YES;
}

- (void)removeAllItemsWithProgressBlock:(void(^)(int removedCount, int totalCount))progress
                               endBlock:(void(^)(BOOL error))end
{
    
    int total = [self _dbGetTotalItemCount];
    if (total <= 0)
    {
        if (end) end(total < 0);
    }
    else
    {
        int left = total;
        int perCount = 32;
        NSArray *items = nil;
        BOOL suc = NO;
        do {
            items = [self _dbGetItemSizeInfoOrderByTimeDescWithLimit:perCount];
            for (TYZKVStorageItem *item in items)
            {
                if (left > 0)
                {
                    if (item.filename)
                    {
                        [self _fileDeleteWithName:item.filename];
                    }
                    suc = [self _dbDeleteItemWithKey:item.key];
                    left--;
                }
                else
                {
                    break;
                }
                if (!suc) break;
            }
            if (progress) progress(total - left, total);
        } while (left > 0 && items.count > 0 && suc);
        if (suc) [self _dbCheckpoint];
        if (end) end(!suc);
    }
}

- (TYZKVStorageItem *)getItemForKey:(NSString *)key
{
    if (key.length == 0) return nil;
    TYZKVStorageItem *item = [self _dbGetItemWithKey:key excludeInlineData:NO];
    if (item)
    {
        [self _dbUpdateAccessTimeWithKey:key];
        if (item.filename)
        {
            item.value = [self _fileReadWithName:item.filename];
            if (!item.value)
            {
                [self _dbDeleteItemWithKey:key];
                item = nil;
            }
        }
    }
    return item;
}

- (TYZKVStorageItem *)getItemInfoForKey:(NSString *)key
{
    if (key.length == 0) return nil;
    TYZKVStorageItem *item = [self _dbGetItemWithKey:key excludeInlineData:YES];
    return item;
}

- (NSData *)getItemValueForKey:(NSString *)key
{
    if (key.length == 0) return nil;
    NSData *value = nil;
    switch (_type)
    {
        case TYZKVStorageTypeFile:
        {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename)
            {
                value = [self _fileReadWithName:filename];
                if (!value)
                {
                    [self _dbDeleteItemWithKey:key];
                    value = nil;
                }
            }
        } break;
        case TYZKVStorageTypeSQLite:
        {
            value = [self _dbGetValueWithKey:key];
        } break;
        case TYZKVStorageTypeMixed:
        {
            NSString *filename = [self _dbGetFilenameWithKey:key];
            if (filename)
            {
                value = [self _fileReadWithName:filename];
                if (!value)
                {
                    [self _dbDeleteItemWithKey:key];
                    value = nil;
                }
            }
            else
            {
                value = [self _dbGetValueWithKey:key];
            }
        } break;
    }
    if (value)
    {
        [self _dbUpdateAccessTimeWithKey:key];
    }
    return value;
}

- (NSArray *)getItemForKeys:(NSArray *)keys
{
    if (keys.count == 0) return nil;
    NSMutableArray *items = [self _dbGetItemWithKeys:keys excludeInlineData:NO];
    if (_type != TYZKVStorageTypeSQLite)
    {
        for (NSInteger i = 0, max = items.count; i < max; i++)
        {
            TYZKVStorageItem *item = items[i];
            if (item.filename)
            {
                item.value = [self _fileReadWithName:item.filename];
                if (!item.value)
                {
                    if (item.key) [self _dbDeleteItemWithKey:item.key];
                    [items removeObjectAtIndex:i];
                    i--;
                    max--;
                }
            }
        }
    }
    if (items.count > 0)
    {
        [self _dbUpdateAccessTimeWithKeys:keys];
    }
    return items.count ? items : nil;
}

- (NSArray *)getItemInfoForKeys:(NSArray *)keys
{
    if (keys.count == 0) return nil;
    return [self _dbGetItemWithKeys:keys excludeInlineData:YES];
}

- (NSDictionary *)getItemValueForKeys:(NSArray *)keys
{
    NSMutableArray *items = (NSMutableArray *)[self getItemForKeys:keys];
    NSMutableDictionary *kv = [NSMutableDictionary new];
    for (TYZKVStorageItem *item in items)
    {
        if (item.key && item.value)
        {
            [kv setObject:item.value forKey:item.key];
        }
    }
    return kv.count ? kv : nil;
}

- (BOOL)itemExistsForKey:(NSString *)key
{
    if (key.length == 0) return NO;
    return [self _dbGetItemCountWithKey:key] > 0;
}

- (int)getItemsCount
{
    return [self _dbGetTotalItemCount];
}

- (int)getItemsSize
{
    return [self _dbGetTotalItemSize];
}



@end




























