//
//  TYZDBHelper.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TYZDBHelper : NSObject

+ (FMDatabaseQueue *)databaseQueue;

/**
 *  判断这个表是否存在
 *
 *  @param tableName 表名
 *  @param db        db
 *
 *  @return YES表示存在；NO表示不存在
 */
+ (BOOL)isTableExist:(NSString *)tableName widthDB:(FMDatabase *)db;

@end





























