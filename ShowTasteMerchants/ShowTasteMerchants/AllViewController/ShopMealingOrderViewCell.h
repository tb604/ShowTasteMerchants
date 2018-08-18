//
//  ShopMealingOrderViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

//#define kShopMealingOrderViewCellHeight (136.0)

/**
 *  餐中订单
 */
@interface ShopMealingOrderViewCell : TYZBaseTableViewCell

/**
 *  <#Description#>
 *
 *  @param type 1表示预订；2表示即时
 *
 *  @return <#return value description#>
 */
+ (CGFloat)getWithCellHeight:(NSInteger)type;

@end
