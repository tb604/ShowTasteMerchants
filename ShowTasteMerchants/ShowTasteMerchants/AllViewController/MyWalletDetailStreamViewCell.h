//
//  MyWalletDetailStreamViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kMyWalletDetailStreamViewCellHeight (50.)

@interface MyWalletDetailStreamViewCell : TYZBaseTableViewCell

- (void)updateCellData:(NSAttributedString *)title value:(NSAttributedString *)value;

@end
