//
//  MyFinanceTodayDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyFinanceTodayAmPmEntity.h"
#import "MyFinanceTodayExpEntity.h"


@interface MyFinanceTodayDataEntity : NSObject

/// 餐厅id
@property (nonatomic, assign) NSInteger shop_id;

/// 餐厅名称
@property (nonatomic, copy) NSString *shop_name;

/// 今日订单总单数
@property (nonatomic, assign) NSInteger total_count;

/// 营业额
@property (nonatomic, assign) CGFloat total_amount;

/// 午餐段
@property (nonatomic, strong) MyFinanceTodayAmPmEntity *am;

/// 晚餐段
@property (nonatomic, strong) MyFinanceTodayAmPmEntity *pm;

/// 异常订单
@property (nonatomic, strong) MyFinanceTodayExpEntity *exp;



@property (nonatomic, copy) NSString *todayDate;


@end























