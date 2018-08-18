//
//  NSKeyedUnarchiver+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSKeyedUnarchiver+TYZAdd.h"
#import "TYZKitMacro.h"


TYZSYNTH_DUMMY_CLASS(NSKeyedUnarchiver_TYZAdd)

@implementation NSKeyedUnarchiver (TYZAdd)
/**
 Same as unarchiveObjectWithData:, except it returns the exception by reference.(unarchiveObjectWithData:一样,只不过它通过引用返回异常。)
 
 @param data       The data need unarchived.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said pointer is not NULL, point to said NSException.
 */
+ (id)unarchiveObjectWithData:(NSData *)data exception:(__autoreleasing NSException **)exception
{
    id object = nil;
    @try
    {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e)
    {
        if (exception)
        {
            *exception =e;
        }
    }
    @finally
    {
        
    }
    return object;
}

/**
 Same as unarchiveObjectWithFile:, except it returns the exception by reference.
 
 @param path       The path of archived object file.
 
 @param exception  Pointer which will, upon return, if an exception occurred and
 said  pointer is not NULL, point to said NSException.
 */
+ (id)unarchiveObjectWithFile:(NSString *)path exception:(__autoreleasing NSException **)exception
{
    id object = nil;
    @try
    {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    @catch (NSException *e)
    {
        if (exception)
        {
            *exception = e;
        }
    }
    @finally
    {
        
    }
    return object;
}
@end
