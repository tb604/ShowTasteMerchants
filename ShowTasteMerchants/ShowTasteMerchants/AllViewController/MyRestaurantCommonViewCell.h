//
//  MyRestaurantCommonViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kMyRestaurantCommonViewCellHeight (46.0)

/**
 *  人均消费、地址、电话、支付账号
 */
@interface MyRestaurantCommonViewCell : TYZBaseTableViewCell


- (void)updateCellData:(id)cellEntity imageName:(NSString *)imageName;

@end
