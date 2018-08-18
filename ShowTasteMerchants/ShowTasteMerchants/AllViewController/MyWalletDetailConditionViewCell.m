//
//  MyWalletDetailConditionViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailConditionViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MyWalletDetailConditionViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UIImageView *_checkImgView;
}

@property (nonatomic, strong) CellCommonDataEntity *commonEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)initWithCheckImgView;

@end

@implementation MyWalletDetailConditionViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"wallet_icon_all"];
        CGRect frame = CGRectMake(15, (kMyWalletDetailConditionViewCellHeight - image.size.height)/2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
    _thumalImgView.image = [UIImage imageNamed:_commonEntity.thumalImgName];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] / 3, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = _thumalImgView.centerY;
    }
    _titleLabel.text = _commonEntity.title;
}

- (void)initWithCheckImgView
{
    if (!_checkImgView)
    {
        UIImage *image = [UIImage imageNamed:@"wallet_icon_selected"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _checkImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_checkImgView];
        _checkImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        _checkImgView.centerY = _thumalImgView.centerY;
    }
    _checkImgView.image = [UIImage imageNamed:_commonEntity.checkImgName];
    if (_commonEntity.isCheck)
    {
        _checkImgView.hidden = NO;
    }
    else
    {
        _checkImgView.hidden = YES;
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.commonEntity = cellEntity;
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    [self initWithCheckImgView];
}

@end















