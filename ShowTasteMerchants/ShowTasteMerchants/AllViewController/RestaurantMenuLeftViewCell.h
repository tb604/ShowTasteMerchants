//
//  RestaurantMenuLeftViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kRestaurantMenuLeftViewCellHeight (46.0)

@interface RestaurantMenuLeftViewCell : TYZBaseTableViewCell


- (void)updateCellData:(id)cellEntity cellWidth:(CGFloat)cellWidth;

- (void)hiddenWithVerticalLine:(BOOL)hidden;

@end
