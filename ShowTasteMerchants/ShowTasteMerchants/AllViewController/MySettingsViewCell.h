//
//  MySettingsViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kMySettingsViewCellHeight (48.0)

@interface MySettingsViewCell : TYZBaseTableViewCell

/**
 *  更新
 *
 *  @param cellEntity 参数
 *  @param cellType   1表示内容显示图片；1表示显示文字
 */
- (void)updateCellData:(id)cellEntity cellType:(NSInteger)cellType;

@end
