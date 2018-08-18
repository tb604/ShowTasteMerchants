//
//  ORestQualifCertViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

/**
 *  资质认证cell
 */
@interface ORestQualifCertViewCell : TYZBaseTableViewCell


+ (CGFloat)getQualifCertViewCellHeight;

- (void)hiddenWithTitle:(BOOL)hidden;

@end
