//
//  DinersRecipeCollectionViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseCollectionViewCell.h"

@interface DinersRecipeCollectionViewCell : TYZBaseCollectionViewCell

/**
 *  type 1表示减法；2表示加法；3选择规格；4添加
 */
@property (nonatomic, copy) void (^touchAddSubBlock)(NSInteger type, id button, id data);


+ (NSInteger)getWithCellWidth;

+ (NSInteger)getWithCellHeight;

@end
