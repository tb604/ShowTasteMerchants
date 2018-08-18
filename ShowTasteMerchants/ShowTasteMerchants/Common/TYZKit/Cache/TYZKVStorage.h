//
//  TYZKVStorage.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 TYZKVStorageItem is used by `TYZKVStorage` to store key-value pair and meta data.
 Typically, you should not use this class directly.
 
 使用TYZKVStorageItem TYZKVStorage存储键-值对和元数据。通常,您不应该直接使用这个类。
 */
@interface TYZKVStorageItem : NSObject

@property (nonatomic, strong) NSString *key; ///< key
@property (nonatomic, strong) NSData *value; ///< value
@property (nonatomic, strong) NSString *filename; ///< filename (nil if inline)
@property (nonatomic, assign) int size; ///< value's size in bytes
@property (nonatomic, assign) int modTime;///< modification unix timestamp(修改时间戳)
@property (nonatomic, assign) int accessTime; ///< last access unix timestamp(最后一次访问unix时间戳)
@property (nonatomic, strong) NSData *extendedData; ///< extended data(nil if no extended data)(扩展数据(零如果没有扩展数据))
@end

/**
 Storage type, indicated where the `YYKVStorageItem.value` stored.
 
 @discussion Typically, write data to sqlite is faster than extern file, but
 reading performance is dependent on data size. In my test (on iPhone 6 64G),
 read data from extern file is faster than from sqlite when the data is larger
 than 20KB.
 
 * If you want to store large number of small datas (such as contacts cache),
 use YYKVStorageTypeSQLite to get better performance.
 * If you want to store large files (such as image cache),
 use YYKVStorageTypeFile to get better performance.
 * You can use YYKVStorageTypeMixed and choice your storage type for each item.
 
 See <http://www.sqlite.org/intern-v-extern-blob.html> for more information.
 */
typedef NS_ENUM(NSUInteger, TYZKVStorageType)
{
    /// The `value` is stored as a file in file system.(“值”是作为一个文件存储在文件系统中。)
    TYZKVStorageTypeFile = 0,
    
    /// The `value` is stored in sqlite with blob type.(“值”存储在sqlite blob类型。)
    TYZKVStorageTypeSQLite = 1,
    
    /// The `value` is stored in file system or sqlite based on your choice.(“值”存储在文件系统或根据你的选择sqlite。)
    TYZKVStorageTypeMixed = 2,
};


/**
 TYZKVStorage is a key-value storage based on sqlite and file system.
 Typically, you should not use this class directly.(基于sqlite TYZKVStorage是一个键值存储和文件系统。通常,您不应该直接使用这个类。)
 
 @discussion The designated initializer for YYKVStorage is `initWithPath:type:`.
 After initialized, a directory is created based on the `path` to hold key-value data.
 Once initialized you should not read or write this directory without the instance.
 
 You may compile the latest version of sqlite and ignore the libsqlite3.dylib in
 iOS system to get 2x~4x speed up.
 
 @warning The instance of this class is *NOT* thread safe, you need to make sure
 that there's only one thread to access the instance at the same time. If you really
 need to process large amounts of data in multi-thread, you should split the data
 to multiple KVStorage instance (sharding).
 */
@interface TYZKVStorage : NSObject
#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

@property (nonatomic, readonly) NSString *path;        ///< The path of this storage.(存储的路径)
@property (nonatomic, readonly) TYZKVStorageType type;  ///< The type of this storage.(存储的类型)
@property (nonatomic, assign) BOOL errorLogsEnabled;   ///< Set `YES` to enable error logs for debug.(设置为“是”启用调试的错误日志。)

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (instancetype)init UNAVAILABLE_ATTRIBUTE; // 使得这个init函数无效
+ (instancetype)new UNAVAILABLE_ATTRIBUTE; // 使得这个new函数无效

/**
 The designated initializer.
 
 @param path  Full path of a directory in which the storage will write data. If
 the directory is not exists, it will try to create one, otherwise it will
 read the data in this directory.
 @param type  The storage type. After first initialized you should not change the
 type of the specified path.
 @return  A new storage object, or nil if an error occurs.
 @warning Multiple instances with the same path will make the storage unstable.
 */
- (instancetype)initWithPath:(NSString *)path type:(TYZKVStorageType)type NS_DESIGNATED_INITIALIZER;// 指定初始化器


#pragma mark - Save Items
///=============================================================================
/// @name Save Items
///=============================================================================

/**
 Save an item or update the item with 'key' if it already exists.
 
 @discussion This method will save the item.key, item.value, item.filename and
 item.extendedData to disk or sqlite, other properties will be ignored. item.key
 and item.value should not be empty (nil or zero length).
 
 If the `type` is YYKVStorageTypeFile, then the item.filename should not be empty.
 If the `type` is YYKVStorageTypeSQLite, then the item.filename will be ignored.
 It the `type` is YYKVStorageTypeMixed, then the item.value will be saved to file
 system if the item.filename is not empty, otherwise it will be saved to sqlite.
 
 @param item  An item.
 @return Whether succeed.
 */
- (BOOL)saveItem:(TYZKVStorageItem *)item;

/**
 Save an item or update the item with 'key' if it already exists.
 
 @discussion This method will save the key-value pair to sqlite. If the `type` is
 YYKVStorageTypeFile, then this method will failed.
 
 @param key   The key, should not be empty (nil or zero length).
 @param value The key, should not be empty (nil or zero length).
 @return Whether succeed.
 */
- (BOOL)saveItemWithKey:(NSString *)key value:(NSData *)value;

/**
 Save an item or update the item with 'key' if it already exists.
 
 @discussion
 If the `type` is YYKVStorageTypeFile, then the `filename` should not be empty.
 If the `type` is YYKVStorageTypeSQLite, then the `filename` will be ignored.
 It the `type` is YYKVStorageTypeMixed, then the `value` will be saved to file
 system if the `filename` is not empty, otherwise it will be saved to sqlite.
 
 @param key           The key, should not be empty (nil or zero length).
 @param value         The key, should not be empty (nil or zero length).
 @param filename      The filename.
 @param extendedData  The extended data for this item (pass nil to ignore it).
 
 @return Whether succeed.
 */
- (BOOL)saveItemWithKey:(NSString *)key
                  value:(NSData *)value
               filename:(nullable NSString *)filename
           extendedData:(nullable NSData *)extendedData;

#pragma mark - Remove Items
///=============================================================================
/// @name Remove Items
///=============================================================================

/**
 Remove an item with 'key'.
 
 @param key The item's key.
 @return Whether succeed.
 */
- (BOOL)removeItemForKey:(NSString *)key;

/**
 Remove items with an array of keys.
 
 @param keys An array of specified keys.
 
 @return Whether succeed.
 */
- (BOOL)removeItemForKeys:(NSArray<NSString *> *)keys;

/**
 Remove all items which `value` is larger than a specified size.
 
 @param size  The maximum size in bytes.
 @return Whether succeed.
 */
- (BOOL)removeItemsLargerThanSize:(int)size;

/**
 Remove all items which last access time is earlier than a specified timestamp.
 
 @param time  The specified unix timestamp.
 @return Whether succeed.
 */
- (BOOL)removeItemsEarlierThanTime:(int)time;

/**
 Remove items to make the total size not larger than a specified size.
 The least recently used (LRU) items will be removed first.
 
 @param maxSize The specified size in bytes.
 @return Whether succeed.
 */
- (BOOL)removeItemsToFitSize:(int)maxSize;

/**
 Remove items to make the total count not larger than a specified count.
 The least recently used (LRU) items will be removed first.
 
 @param maxCount The specified item count.
 @return Whether succeed.
 */
- (BOOL)removeItemsToFitCount:(int)maxCount;

/**
 Remove all items in background queue.
 
 @discussion This method will remove the files and sqlite database to a trash
 folder, and then clear the folder in background queue. So this method is much
 faster than `removeAllItemsWithProgressBlock:endBlock:`.
 
 @return Whether succeed.
 */
- (BOOL)removeAllItems;

/**
 Remove all items.
 
 @warning You should not send message to this instance in these blocks.
 @param progress This block will be invoked during removing, pass nil to ignore.
 @param end      This block will be invoked at the end, pass nil to ignore.
 */
- (void)removeAllItemsWithProgressBlock:(nullable void(^)(int removedCount, int totalCount))progress
                               endBlock:(nullable void(^)(BOOL error))end;


#pragma mark - Get Items
///=============================================================================
/// @name Get Items
///=============================================================================

/**
 Get item with a specified key.
 
 @param key A specified key.
 @return Item for the key, or nil if not exists / error occurs.
 */
- (nullable TYZKVStorageItem *)getItemForKey:(NSString *)key;

/**
 Get item information with a specified key.
 The `value` in this item will be ignored.
 
 @param key A specified key.
 @return Item information for the key, or nil if not exists / error occurs.
 */
- (nullable TYZKVStorageItem *)getItemInfoForKey:(NSString *)key;

/**
 Get item value with a specified key.
 
 @param key  A specified key.
 @return Item's value, or nil if not exists / error occurs.
 */
- (nullable NSData *)getItemValueForKey:(NSString *)key;

/**
 Get items with an array of keys.
 
 @param keys  An array of specified keys.
 @return An array of `YYKVStorageItem`, or nil if not exists / error occurs.
 */
- (nullable NSArray<TYZKVStorageItem *> *)getItemForKeys:(NSArray<NSString *> *)keys;

/**
 Get item infomartions with an array of keys.
 The `value` in items will be ignored.
 
 @param keys  An array of specified keys.
 @return An array of `YYKVStorageItem`, or nil if not exists / error occurs.
 */
- (nullable NSArray<TYZKVStorageItem *> *)getItemInfoForKeys:(NSArray<NSString *> *)keys;

/**
 Get items value with an array of keys.
 
 @param keys  An array of specified keys.
 @return A dictionary which key is 'key' and value is 'value', or nil if not
 exists / error occurs.
 */
- (nullable NSDictionary<NSString *, NSData *> *)getItemValueForKeys:(NSArray<NSString *> *)keys;

#pragma mark - Get Storage Status
///=============================================================================
/// @name Get Storage Status
///=============================================================================

/**
 Whether an item exists for a specified key.
 
 @param key  A specified key.
 
 @return `YES` if there's an item exists for the key, `NO` if not exists or an error occurs.
 */
- (BOOL)itemExistsForKey:(NSString *)key;

/**
 Get total item count.
 @return Total item count, -1 when an error occurs.
 */
- (int)getItemsCount;

/**
 Get item value's total size in bytes.
 @return Total size in bytes, -1 when an error occurs.
 */
- (int)getItemsSize;

@end
NS_ASSUME_NONNULL_END







































