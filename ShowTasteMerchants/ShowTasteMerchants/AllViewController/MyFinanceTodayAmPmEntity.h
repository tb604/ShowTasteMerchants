//
//  MyFinanceTodayAmPmEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFinanceTodayAmPmEntity : NSObject

/// 订单数量(午餐、晚餐)
@property (nonatomic, assign) NSInteger count;

/// 已完成订单数量(午餐、晚餐)
@property (nonatomic, assign) NSInteger down_count;

/// 异常订单数量(午餐、晚餐)
@property (nonatomic, assign) NSInteger exp_count;

/// 处理订单数量(午餐、晚餐)
@property (nonatomic, assign) NSInteger proc_count;

@end
























