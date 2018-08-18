//
//  ORestCommonMultsCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"


#define kORestCommonMultsCellMinHeight (72.0)

@interface ORestCommonMultsCell : TYZBaseTableViewCell

/**
 *  修改信息
 *
 *  @param title             标题
 *  @param value             值
 *  @param hiddenThanImgView 是否隐藏三角
 *  @param valueHeight        值的高度
 */
- (void)updateWithTitle:(NSAttributedString *)title value:(NSAttributedString *)value hiddenThanImgView:(BOOL)hiddenThanImgView valueHeight:(CGFloat)valueHeight;

@end
