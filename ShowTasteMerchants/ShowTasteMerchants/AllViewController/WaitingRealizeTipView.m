//
//  WaitingRealizeTipView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WaitingRealizeTipView.h"
#import "LocalCommon.h"

@interface WaitingRealizeTipView ()
{
    UIImageView *_tipImgView;
    
    UILabel *_tipLabel;

}

- (void)initWithTipImgView:(NSString *)imgName;

- (void)initWithTipLabel:(NSString *)tip;

@end

@implementation WaitingRealizeTipView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.userInteractionEnabled = NO;
}

- (void)initWithTipImgView:(NSString *)imgName
{
    UIImage *image = [UIImage imageNamed:imgName];
    if (!_tipImgView)
    {// jinqingqidai
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - image.size.width)/2, 0, image.size.width, image.size.height);
        _tipImgView = [[UIImageView alloc] initWithFrame:frame];
        _tipImgView.bottom = self.height / 2;
        [self addSubview:_tipImgView];
    }
    _tipImgView.image = image;
}

- (void)initWithTipLabel:(NSString *)tip
{
    if (!_tipLabel)
    {
        CGRect frame = CGRectMake(15, _tipImgView.bottom, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _tipLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    }
    _tipLabel.text = tip;
}

- (void)updateViewData:(id)entity tip:(NSString *)tip
{
    [self initWithTipImgView:entity];
    
    [self initWithTipLabel:tip];
    
    
}

@end
