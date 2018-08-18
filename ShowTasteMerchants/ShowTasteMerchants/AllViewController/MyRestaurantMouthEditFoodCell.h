//
//  MyRestaurantMouthEditFoodCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

@interface MyRestaurantMouthEditFoodCell : TYZBaseTableViewCell

/**
 *  type 1表示移到归档；2表示移到非归档
 */
@property (nonatomic, copy) void (^mouthOperatorBlock)(id data, int type);

@property (nonatomic, copy) void (^refreshMouthBlock)(id data);

/**
 *  更新
 *
 *  @param cellEntity        归档的数据
 *  @param unarchiveFoodList 未归档的数据
 */
- (void)updateCellData:(id)cellEntity unarchiveFoodList:(NSArray *)unarchiveFoodList;

@end
