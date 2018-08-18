//
//  ShopOrderDetailBottomView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseBottomView.h"

@interface ShopOrderDetailBottomView : TYZBaseBottomView

/**
 *  更新
 *
 *  @param entity dd
 *  @param type       1表示显示左边的信息，leftButton隐藏，rightButton显示；2值显示信息，左右边按钮都以你藏；3只显示右边的按钮；4只显示左边的按钮；5左右按钮都显示，各占一半的宽度；6左右按钮都显示，左边占三分之一，右边占三分之二
 *  @param leftTitle d
 *  @param rightTitle d
 */
- (void)updateViewData:(id)entity type:(NSInteger)type leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;

@end

