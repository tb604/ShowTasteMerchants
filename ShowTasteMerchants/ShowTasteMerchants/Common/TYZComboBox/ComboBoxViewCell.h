//
//  ComboBoxViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

//#define kComboBoxViewCellHeight (40)

@interface ComboBoxViewCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity cellWidth:(CGFloat)cellWidth cellHeight:(CGFloat)cellHeight;

@end
