//
//  UserInfoViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kUserInfoViewCellHeight (46.0)

@interface UserInfoViewCell : TYZBaseTableViewCell

/**
 *  更新信息
 *
 *  @param title        标题
 *  @param titleWidth   标题的宽度，如果为0表示实际标题字的宽度
 *  @param attri        value
 *  @param alignment dd
 *  @param detailHeight 高度
 */
- (void)updateCellData:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth attri:(NSAttributedString *)attri alignment:(NSTextAlignment)alignment detailHeight:(CGFloat)detailHeight;

- (void)updateHiddenLine:(BOOL)hidden;

@end
