//
//  OMMainBannerViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OMMainBannerTopView.h"
#import "OMMainBannerBottomView.h"

#define kOMMainBannerViewCellHeight ([OMMainBannerTopView getWithBannerHeight] + [OMMainBannerBottomView getWithViewHeight])

@interface OMMainBannerViewCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity welcomeEnt:(id)welcomeEnt;

@end
