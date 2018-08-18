//
//  DinersShopingCartViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "ShopingCartEntity.h"

//#define kDinersShopingCartViewCellHeight (50.0)

@interface DinersShopingCartViewCell : TYZBaseTableViewCell

@property (nonatomic, copy) void (^touchAddSubBlock)(NSInteger type, id button, ShopingCartEntity *cartEntity);

+ (CGFloat)getWithCellHeight:(ShopingCartEntity *)cartEnt;

@end
