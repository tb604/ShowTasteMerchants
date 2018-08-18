//
//  MyWalletHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletHeaderView.h"
#import "LocalCommon.h"
#import "UserInfoDataEntity.h"

@interface MyWalletHeaderView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UILabel *_moneyLabel;
}
// wallet_icon_balance

- (void)initWithhThuamlImgView;

- (void)initWithTitleLabel;

- (void)initWithMoneyLabel;

@end

@implementation MyWalletHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithhThuamlImgView];
    
    [self initWithTitleLabel];
    
    [self initWithMoneyLabel];
    
}

- (void)initWithhThuamlImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"wallet_icon_balance"];
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - image.size.width)/2, 0, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self addSubview:_thumalImgView];
        _thumalImgView.bottom = self.height / 2;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(0, _thumalImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.centerX = _thumalImgView.centerX;
        _titleLabel.text = @"账户余额（元）";
    }
}

- (void)initWithMoneyLabel
{
    if (!_moneyLabel)
    {
        CGRect frame = CGRectMake(0, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 50);
        _moneyLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(60) labelTag:0 alignment:NSTextAlignmentCenter];
        _moneyLabel.centerX = _thumalImgView.centerX;
        _moneyLabel.text = @"0.00";
//        _moneyLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)updateViewData:(id)entity
{
    UserInfoDataEntity *ent = entity;
    _moneyLabel.text = [NSString stringWithFormat:@"%.2f", ent.balance];
}

@end






























