//
//  NSArray+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSArray+TYZAdd.h"
#import "TYZKitMacro.h"
#import "NSData+TYZAdd.h"

TYZSYNTH_DUMMY_CLASS(NSArray_TYZAdd)

@implementation NSArray (TYZAdd)
/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the binary plist data, or nil if an error occurs.
 */
+ (NSArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist)
    {
        return nil;
    }
    // NSPropertyListSerialization用来实现序列化
    NSArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([array isKindOfClass:[NSArray class]])
    {
        return array;
    }
    return nil;
}

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

/**
 Serialize the array to a binary property list data.
 
 @return A binary plist data, or nil if an error occurs.
 */
- (NSData *)plistData
{
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (NSString *)plistString
{
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData)
    {
        return xmlData.utf8String;
    }
    return nil;
}

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (id)randomObject
{
    if (self.count != 0)
    {
        // arc4random_uniform(x) 产生0～x-1的随机数
        return self[arc4random_uniform((u_int32_t)self.count)];
    }
    return nil;
}

/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (id)objectOrNilAtIndex:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (NSString *)jsonStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error)
        {
            return json;
        }
    }
    return nil;
}

/**
 Convert object to json string formatted. return nil if an error occurs.(将对象转换为json字符串格式化。如果出现错误返回nil。)
 */
- (NSString *)jsonPrettyStringEncoded
{
    if ([NSJSONSerialization isValidJSONObject:self])
    {
        // NSJSONWritingPrettyPrinted 将生成的json数据格式化输出，这样可读性高，不设置则输出的json字符串就是一整行。
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error)
        {
            return json;
        }
    }
    return nil;
}

/**
 *  数组的深拷贝
 *
 *  @return 返回拷贝后的数组
 */
- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *arrReturn = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self)
    {
        id oneCopy = nil;
        if ([(NSObject *)obj respondsToSelector:@selector(mutableDeepCopy)])
        {
            oneCopy = [obj mutableDeepCopy];
        }
        else if ([(NSObject *)obj respondsToSelector:@selector(mutableCopy)])
        {
            oneCopy = [obj mutableCopy];
        }
        else if ([obj conformsToProtocol:@protocol(NSCopying)])
        {
            oneCopy = [obj copy];
        }
        else
        {
            NSLog(@"ClassName:[%@] couldn't be copied", [obj class]);
            continue;
        }
        [arrReturn addObject:oneCopy];
    }
    return arrReturn;
}

@end


@implementation NSMutableArray (TYZAdd)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the binary plist data, or nil if an error occurs.
 */
+ (NSMutableArray *)arrayWithPlistData:(NSData *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSMutableArray *array = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([array isKindOfClass:[NSMutableArray class]])
    {
        return array;
    }
    return nil;
}

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.(根对象的属性列表的xml字符串数组。)
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (NSMutableArray *)arrayWithPlistString:(NSString *)plist
{
    if (!plist)
    {
        return nil;
    }
    NSData *data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self arrayWithPlistData:data];
}

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)removeFirstObject
{
    if (self.count != 0)
    {
        [self removeObjectAtIndex:0];
    }
}

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)removeLastObject
{
    if (self.count != 0)
    {
        [self removeObjectAtIndex:self.count - 1];
    }
}
#pragma clang diagnostic pop

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)popFirstObject
{
    id obj = nil;
    if (self.count != 0)
    {
        obj = self.firstObject;
        [self removeFirstObject];
    }
    return obj;
}

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (id)popLastObject
{
    id obj = nil;
    if (self.count != 0)
    {
        obj = self.lastObject;
        [self removeLastObject];
    }
    return obj;
}

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)appendObject:(id)anObject
{
    [self addObject:anObject];
}

/**
 Inserts a given object at the beginning of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)prependObject:(id)anObject
{
    [self insertObject:anObject atIndex:0];
}

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)appendObjects:(NSArray *)objects
{
    if (!objects)
    {
        return;
    }
    [self addObjectsFromArray:objects];
}

/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)prependObjects:(NSArray *)objects
{
    if (!objects)
    {
        return;
    }
    NSUInteger i = 0;
    for (id obj in objects)
    {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)insertObjects:(NSArray *)objects atIndex:(NSUInteger)index
{
    NSUInteger i = index;
    for (id obj in objects)
    {
        [self insertObject:obj atIndex:i++];
    }
}

/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)reverse
{
    NSUInteger count = self.count;
    int mid = floor(count / 2.0);
    for (NSUInteger i=0; i<mid; i++)
    {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(count - (i+1))];
    }
}

/**
 Sort the object in this array randomly.(这个数组的对象随机排序。)
 */
- (void)shuffle
{
    for (NSUInteger i=self.count; i>1; i--)
    {
        [self exchangeObjectAtIndex:(i-1) withObjectAtIndex:arc4random_uniform((u_int32_t)i)];
    }
}

@end










