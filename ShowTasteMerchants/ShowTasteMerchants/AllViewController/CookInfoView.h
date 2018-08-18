//
//  CookInfoView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kCookInfoViewHeight (30.0)

@interface CookInfoView : TYZBaseView


/**
 *  修改信息
 *
 *  @param title             标题
 *  @param titleWidth        标题宽度
 *  @param value             值
 *  @param alignment  位置
 */
- (void)updateWithTitle:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth value:(NSAttributedString *)value alignment:(NSTextAlignment)alignment;

- (void)hiddenBottomLine:(BOOL)hidden;

@end
