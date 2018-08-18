//
//  OMMainBannerViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMMainBannerViewCell.h"
#import "LocalCommon.h"

@interface OMMainBannerViewCell ()
{
    OMMainBannerTopView *_bannerTopView;
    
    OMMainBannerBottomView *_bannerBottomView;
}

- (void)initWithBannerTopView;

- (void)initWithBannerBottomView;

@end

@implementation OMMainBannerViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBannerTopView];
    
    [self initWithBannerBottomView];
    
}

- (void)initWithBannerTopView
{
    if (!_bannerTopView)
    {
        _bannerTopView = [[OMMainBannerTopView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [OMMainBannerTopView getWithBannerHeight])];
        [self.contentView addSubview:_bannerTopView];
        debugLogFrame(_bannerTopView.frame);
    }
}

- (void)initWithBannerBottomView
{
    if (!_bannerBottomView)
    {
        _bannerBottomView = [[OMMainBannerBottomView alloc] initWithFrame:CGRectMake(0, _bannerTopView.bottom, _bannerTopView.width, [OMMainBannerBottomView getWithViewHeight])];
        
        [self.contentView addSubview:_bannerBottomView];
    }
}

- (void)updateCellData:(id)cellEntity welcomeEnt:(id)welcomeEnt
{
    // 轮播宣传
    [_bannerTopView updateViewData:cellEntity];
    
    // 欢迎语
    [_bannerBottomView updateViewData:welcomeEnt];

}

/*- (void)updateCellData:(id)cellEntity
{
    // OrderMealContentEntity
    if (!cellEntity)
    {
        return;
    }
    NSArray *array = cellEntity;
    if ([array count] > 2)
    {
        // 轮播宣传
        [_bannerTopView updateViewData:array[0]];
        
        // 欢迎语
        [_bannerBottomView updateViewData:array[1]];
    }
    
}*/

@end
