//
//  NSKeyedUnarchiver+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Provides extensions for `NSKeyedUnarchiver`.
 */
@interface NSKeyedUnarchiver (TYZAdd)
/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.(unarchiveObjectWithData:一样,只不过它通过引用返回异常。)
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (nullable id)unarchiveObjectWithData:(NSData *)data exception:(NSException *_Nullable *_Nullable)exception;

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (nullable id)unarchiveObjectWithFile:(NSString *)path exception:(NSException *_Nullable *_Nullable)exception;
@end

NS_ASSUME_NONNULL_END
















