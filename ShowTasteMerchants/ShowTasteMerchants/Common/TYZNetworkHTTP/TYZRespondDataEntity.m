//
//  TYZRespondDataEntity.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRespondDataEntity.h"
#import "NSObject+TYZModel.h"

@implementation TYZRespondDataEntity

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic allKeys] containsObject:@"code"])
    {
        self.errcode = [dic[@"code"] intValue];
    }
    if ([[dic allKeys] containsObject:@"message"])
    {
        self.msg = dic[@"message"];
    }
    return YES;
}

@end
