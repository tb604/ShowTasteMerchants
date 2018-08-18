//
//  MyFinanceTodayExpListEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyFinanceTodayExpListEntity : NSObject

/// 金额
@property (nonatomic, assign) CGFloat total_amount;

/// 订单号
@property (nonatomic, copy) NSString *order_id;

/// 顾客姓名
@property (nonatomic, copy) NSString *user_name;

@end
