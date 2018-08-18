//
//  UserLocationEntity.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserLocationEntity.h"
#import "NSObject+TYZModel.h"

@implementation UserLocationEntity

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

/**
 *  用户当前的位置
 *
 *  @return 返回位置
 */
- (CLLocationCoordinate2D)currentLocation
{
    return (CLLocationCoordinate2D){_latitude, _longitude};
}

/**
 *  用户选择城市的位置
 *
 *  @return 返回位置
 */
- (CLLocationCoordinate2D)choiceLocation
{
    return (CLLocationCoordinate2D){_choiceLatitude, _choiceLongitude};
}

/**
 *  当前城市，跟用户选择的城市是否相同
 *
 *  @return <#return value description#>
 */
- (BOOL)currentCityIsEqualChoiceCity
{
    if (!_choiceCity || [_choiceCity isEqualToString:@""])
    {
        return YES;
    }
    NSRange range = [_choiceCity rangeOfString:_currentCity];
    if (range.length != 0)
    {// 表示两个城市相同
        return YES;
    }
    return NO;
}

@end
