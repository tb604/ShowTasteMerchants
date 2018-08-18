//
//  DRFoodDetailStandardViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "DRFoodStandardView.h"
#import "DRFoodStandardActivityView.h"


/**
 *  规格、活动
 */
@interface DRFoodDetailStandardViewCell : TYZBaseTableViewCell

/**
 *  type 1表示工艺；2表示口味
 */
@property (nonatomic, copy) void (^touchStandardBlock)(NSInteger type, NSString *title);

- (void)updateCellData:(id)cellEntity isBrowse:(BOOL)isBrowse;


@end
