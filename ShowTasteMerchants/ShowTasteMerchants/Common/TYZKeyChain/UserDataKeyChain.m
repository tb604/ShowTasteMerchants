//
//  UserDataKeyChain.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserDataKeyChain.h"
#import "NSObject+TYZModel.h"

@implementation UserDataKeyChain

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
