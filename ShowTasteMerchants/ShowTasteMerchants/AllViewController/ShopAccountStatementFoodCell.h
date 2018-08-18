//
//  ShopAccountStatementFoodCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OrderFoodInfoEntity.h"
#import "CTCMealOrderFoodEntity.h"

//#define kShopAccountStatementFoodCellHeight (40)

@interface ShopAccountStatementFoodCell : TYZBaseTableViewCell

+ (CGFloat)getWithCellHeight:(id)foodEntity;

@end
