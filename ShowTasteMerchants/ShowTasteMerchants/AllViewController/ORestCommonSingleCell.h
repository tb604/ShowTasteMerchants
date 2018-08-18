//
//  ORestCommonSingleCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"


#define kORestCommonSingleCellHeight (44.0)

/**
 *  公用的单行cell
 */
@interface ORestCommonSingleCell : TYZBaseTableViewCell

/**
 *  修改信息
 *
 *  @param title             标题
 *  @param titleWidth        标题宽度
 *  @param value             值
 *  @param hiddenThanImgView 是否隐藏三角
 *  @param alignment       左中右

 */
- (void)updateWithTitle:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth value:(NSAttributedString *)value hiddenThanImgView:(BOOL)hiddenThanImgView alignment:(NSTextAlignment)alignment;

@end
