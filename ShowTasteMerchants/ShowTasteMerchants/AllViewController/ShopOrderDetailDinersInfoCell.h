//
//  ShopOrderDetailDinersInfoCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kShopOrderDetailDinersInfoCellHeight (60.0)

/**
 *  食客基本信息Cell
 */
@interface ShopOrderDetailDinersInfoCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity isSelected:(BOOL)isSelected;

- (void)hiddenWithLine:(BOOL)hidden;

@end
