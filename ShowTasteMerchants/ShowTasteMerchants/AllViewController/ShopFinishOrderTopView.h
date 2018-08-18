//
//  ShopFinishOrderTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kShopFinishOrderTopViewHeight (75.0)

@interface ShopFinishOrderTopView : TYZBaseView

- (NSString *)getWithDate;

/**
 *  date表示到店日期；name比哦啊时食客姓名；orderNo表示订单编号
 */
@property (nonatomic, copy) void (^searchOrderBlock)(NSString *date, NSString *name, NSString *orderNo);

@end
