//
//  TYZDBHelper.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDBHelper.h"

// 数据库文件的路径
#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]

// 数据库名称
#define dataBaseName @"topchefshop.sqlite"

@implementation TYZDBHelper

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [_databaseQueue release], _databaseQueue = nil;
    [super dealloc];
#endif
}

+ (FMDatabaseQueue *)databaseQueue
{
    static FMDatabaseQueue *_databaseQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
#if !__has_feature(objc_arc)
        [_databaseQueue retain];
#endif
    });
    return _databaseQueue;
}

+ (BOOL)isTableExist:(NSString *)tableName widthDB:(FMDatabase *)db
{
    BOOL isExist = NO;
    
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type='table' and name=?;", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        if (count == 0)
        {
            isExist = NO;
        }
        else
        {
            isExist = YES;
        }
    }
    [rs close];
    
    return isExist;
}

@end






























