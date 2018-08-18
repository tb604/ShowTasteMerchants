//
//  ShopMealingOrderTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kShopMealingOrderTopViewHeight (40.0)

@interface ShopMealingOrderTopView : TYZBaseView

/**
 *  tableNo表示桌号；name表示食客姓名
 */
@property (nonatomic, copy) void (^searchOrderBlock)(NSString *tableNo, NSString *name);

@end
