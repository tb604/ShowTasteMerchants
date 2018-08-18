//
//  DinersRecipeViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "DinersRecipeFoodBaseView.h"

@interface DinersRecipeViewCell : TYZBaseTableViewCell

@property (nonatomic, copy) void (^touchAddSubBlock)(NSInteger type, id button);

+ (NSInteger)getWithRecipeViewCellHeight;

- (void)updateWithAddNum:(NSInteger)num;

@end
