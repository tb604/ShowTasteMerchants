//
//  CommentDetailEntity.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CommentDetailEntity.h"

@implementation CommentDetailEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"images" : [CommentImageDataEntity class], @"classify" : [CommentClassifyEntity class]};
}

@end
