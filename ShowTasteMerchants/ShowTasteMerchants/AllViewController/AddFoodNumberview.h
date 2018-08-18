//
//  AddFoodNumberview.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kAddFoodNumberviewWidth (90.0)
#define kAddFoodNumberviewHeight (30.0)

@interface AddFoodNumberview : TYZBaseView

/**
 *  type 1表示减法；2表示加法；3选择规格
 */
@property (nonatomic, copy) void (^addFoodBlock)(NSInteger type, id button);

- (void)updateWithAddNum:(NSInteger)num;

/**
 *  隐藏规格按钮
 *
 *  @param hidden yes
 */
- (void)hiddenWithSpec:(BOOL)hidden;

@end
