//
//  MallDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MallListDataEntity.h"

/**
 *  商圈信息列表的信息
 */
@interface MallDataEntity : NSObject

/**
 *  区域id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  区域名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  商圈列表
 */
@property (nonatomic, strong) NSArray *malls;

@end




























