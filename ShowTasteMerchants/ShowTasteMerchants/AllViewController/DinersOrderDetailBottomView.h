//
//  DinersOrderDetailBottomView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseBottomView.h"

@interface DinersOrderDetailBottomView : TYZBaseBottomView

/**
 *  更新
 *
 *  @param data           data
 *  @param buttonWithType 宽度类型；1表示屏幕宽度；2表示屏幕宽度的一半；3表示屏幕宽度的三分之一
 *  @param buttonTitle    按钮标题
 */
- (void)updateWithBottom:(id)data buttonWidthType:(NSInteger)buttonWithType buttonTitle:(NSString *)buttonTitle;

@end
