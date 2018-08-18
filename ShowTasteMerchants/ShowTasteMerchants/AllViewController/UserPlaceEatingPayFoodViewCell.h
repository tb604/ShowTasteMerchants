//
//  UserPlaceEatingPayFoodViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OrderFoodInfoEntity.h"

//#define kUserPlaceEatingPayFoodViewCellHeight (40.0)


@interface UserPlaceEatingPayFoodViewCell : TYZBaseTableViewCell

+ (CGFloat)getWithCellHeight:(OrderFoodInfoEntity *)foodEntity;

@end
