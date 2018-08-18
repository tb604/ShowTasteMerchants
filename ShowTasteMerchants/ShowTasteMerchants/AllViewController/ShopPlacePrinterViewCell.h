//
//  ShopPlacePrinterViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "ShopMouthDataEntity.h"

#define kShopPlacePrinterViewCellHeight (45.0)

@interface ShopPlacePrinterViewCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity selPrintEnt:(ShopMouthDataEntity *)selPrintEnt;

@end
