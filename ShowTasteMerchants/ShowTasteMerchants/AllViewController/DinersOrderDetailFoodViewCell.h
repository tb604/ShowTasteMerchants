//
//  DinersOrderDetailFoodViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OrderFoodInfoEntity.h"

@interface DinersOrderDetailFoodViewCell : TYZBaseTableViewCell


+ (CGFloat)getWithCellHeight:(OrderFoodInfoEntity *)foodEntity;

@end
