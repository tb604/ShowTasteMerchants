//
//  TYZModelExample.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TYZKit.h"


#pragma mark Simple Object Example
@interface TYZBook : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) uint64_t pages;
@property (nonatomic, strong) NSDate *publishDate;
@end

@implementation TYZBook
@end

#pragma mark Nest Object Exmaple
@interface TYZUser : NSObject
@property (nonatomic, assign) uint64_t uid;
@property (nonatomic, copy) NSString *name;
@end
@implementation TYZUser
@end

@interface TYZRepo : NSObject
@property (nonatomic, assign) uint64_t rid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) TYZUser *owner;
@end
@implementation TYZRepo
@end

#pragma mark Container Object Example
@interface TYZPhoto : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *desc;
@end
@implementation TYZPhoto
@end

@interface TYZAlbum : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *photos; ///< Array<TYZPhoto>
@property (nonatomic, strong) NSDictionary *likedUsers; ///< key:name(NSString) Value:user(TYZUser)
@property (nonatomic, strong) NSSet *likedUserIds; ///< Set<NSNumber>
@end
@implementation TYZAlbum
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"photos" : [TYZPhoto class], @"likedUsers" : [TYZUser class], @"likedUserIds" : [NSNumber class]};
}
@end


#pragma mark Custom Mapper Example
@interface TYZMessage : NSObject
@property (nonatomic, assign) uint64_t messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *time;
@end
@implementation TYZMessage

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"messageId" : @"i", @"content" : @"c", @"time" : @"t"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    uint64_t timestamp = [dic unsignedLongLongValueForKey:@"t" default:0];
    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    return YES;
}
- (void)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
    dic[@"t"] = @([self.time timeIntervalSince1970] * 1000).description;
}

@end

#pragma mark Coding/Copy/hash/equal Example
@interface TYZShadow : NSObject <NSCoding, NSCopying>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *color;
@end
@implementation TYZShadow
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}
- (NSUInteger)hash
{
    return [self modelHash];
}
- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}
@end


/**
 *  简单的对象
 */
void simpleObjectExample();

/**
 *  对象里面嵌套对象
 */
void nestObjectExample();

/**
 *  对象里面包含对象。对象里面有一个NSArray/NSDictionary里面的值是自定义的对象
 */
void containerObjectExample();

/**
 *  自定义映射对象
 */
void customMapperExample();
void codingCopyingHashEqualExample();

void runExample()
{
    simpleObjectExample();
    nestObjectExample();
    containerObjectExample();
}

//int main(int argc, const char * argv[])
//{
//    runExample();
//    return 0;
//}

/**
 *  简单的对象
 */
void simpleObjectExample()
{
    NSString *idJson = @"     \
    {                                           \
    \"name\": \"Harry Potter\",              \
    \"pages\": 512,                          \
    \"publishDate\": \"2010-01-01\"          \
    }";
    TYZBook *book = [TYZBook modelWithJSON:idJson];
    NSString *bookJSON = [book modelToJSONString];
    NSLog(@"book=%@", bookJSON);
}

/**
 *  对象里面嵌套对象
 */
void nestObjectExample()
{
    NSString *json = @"         \
    {                                               \
    \"rid\": 123456789,                         \
    \"name\": \"YYKit\",                        \
    \"createTime\" : \"2011-06-09T06:24:26Z\",  \
    \"owner\": {                                \
    \"uid\" : 989898,                       \
    \"name\" : \"ibireme\"                  \
    } \
    }";
    TYZRepo *repo = [TYZRepo modelWithJSON:json];
    NSString *repoJSON = [repo modelToJSONString];
    NSLog(@"Repo: %@", repoJSON);
}

/**
 *  对象里面包含对象。对象里面有一个NSArray/NSDictionary里面的值是自定义的对象
 */
void containerObjectExample()
{
    NSString *strJson = @"          \
    {                                                   \
    \"name\" : \"Happy Birthday\",                      \
    \"photos\" : [                                      \
    {                                               \
    \"url\":\"http://example.com/1.png\",       \
    \"desc\":\"Happy~\"                         \
    },                                              \
    {                                               \
    \"url\":\"http://example.com/2.png\",       \
    \"desc\":\"Yeah!\"                          \
    }                                               \
    ],                                                  \
    \"likedUsers\" : {                                  \
    \"Jony\" : {\"uid\":10001,\"name\":\"Jony\"},   \
    \"Anna\" : {\"uid\":10002,\"name\":\"Anna\"}    \
    },                                                  \
    \"likedUserIds\" : [10001,10002]                    \
    }";
    TYZAlbum *album = [TYZAlbum modelWithJSON:strJson];
    NSString *json = [album modelToJSONString];
    NSLog(@"json=%@", json);
}

/**
 *  映射变量
 */
void customMapperExample()
{
    NSString *strJson = @"{\"i\":\"2000000001\",\"c\":\"Hello\",\"t\":\"1437237598000\"}";
    TYZMessage *msg = [TYZMessage modelWithJSON:strJson];
    NSString *json = [msg modelToJSONString];
    NSLog(@"msg=%@", json);
}

void codingCopyingHashEqualExample()
{
    TYZShadow *shadow = [TYZShadow new];
    shadow.name = @"Test";
    shadow.size = CGSizeMake(10, 0);
    shadow.color = [UIColor blueColor];
    
    TYZShadow *shadow2 = [shadow deepCopy]; // Archive and Unachive
    BOOL equal = [shadow isEqual:shadow2];
    NSLog(@"shadow equals: %@",equal ? @"YES" : @"NO");
}




























