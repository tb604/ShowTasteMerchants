//
//  UserPayWayViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPayWayViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface UserPayWayViewCell ()
{
    UIImageView *_checkImgView;
    
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
}

- (void)initWithCheckImgView;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation UserPayWayViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithCheckImgView];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kUserPayWayViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithCheckImgView
{
    UIImage *image = [UIImage imageNamed:@"btn_diners_check_nor"];
    CGRect frame = CGRectMake(15, (kUserPayWayViewCellHeight - image.size.height)/2, image.size.width, image.size.height);
    _checkImgView = [[UIImageView alloc] initWithFrame:frame];
    _checkImgView.image = image;
    [self.contentView addSubview:_checkImgView];
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"hall-order_pay_icon_zhifubao"];
    CGRect frame = CGRectMake(_checkImgView.right + 15, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    _thumalImgView.centerY = _checkImgView.centerY;
    [self.contentView addSubview:_thumalImgView];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(_thumalImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right + 10, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.centerY = _thumalImgView.centerY;
}


- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *entity = cellEntity;
    
    _thumalImgView.image = [UIImage imageNamed:entity.thumalImgName];
    _titleLabel.text = entity.title;
    if (entity.isCheck)
    {
        _checkImgView.image = [UIImage imageNamed:@"btn_diners_check_sel"];
    }
    else
    {
        _checkImgView.image = [UIImage imageNamed:@"btn_diners_check_nor"];
    }
}

@end

















