//
//  ShopReservationOrderTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kShopReservationOrderTopViewHeight (75.0)

@interface ShopReservationOrderTopView : TYZBaseView

- (NSString *)getWithDate;

/**
 *  date表示到店日期；orderType表示订单类型；name食客姓名
 */
@property (nonatomic, copy) void (^searchOrderBlock)(NSString *date, NSString *orderType, NSString *name);

@end


















