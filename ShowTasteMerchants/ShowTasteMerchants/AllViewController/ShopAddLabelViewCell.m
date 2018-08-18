//
//  ShopAddLabelViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAddLabelViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface ShopAddLabelViewCell ()
{
    UIImageView *_thumalImgView;
    
    UIImageView *_checkImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithThumalImgView;

- (void)initWithCheckImgView;

- (void)initWithTitleLabel;

@end

@implementation ShopAddLabelViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithCheckImgView];
    
    [self initWithTitleLabel];
    
}

- (void)initWithThumalImgView
{
    // comment_icon_label
    UIImage *image = [UIImage imageNamed:@"comment_icon_label"];
    CGRect frame = CGRectMake(15, (kShopAddLabelViewCellHeight - image.size.height) / 2, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    [self.contentView addSubview:_thumalImgView];
}

- (void)initWithCheckImgView
{
    // comment_icon_selected
    UIImage *image = [UIImage imageNamed:@"comment_icon_selected"];
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, (kShopAddLabelViewCellHeight - image.size.height) / 2, image.size.width, image.size.height);
    _checkImgView = [[UIImageView alloc] initWithFrame:frame];
    _checkImgView.image = image;
    _checkImgView.hidden = YES;
    [self.contentView addSubview:_checkImgView];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(_thumalImgView.right + 10, (kShopAddLabelViewCellHeight - 20) / 2, _checkImgView.left - _thumalImgView.right - 10 - 10, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *commEnt = cellEntity;
    _titleLabel.text = commEnt.title;
    if (commEnt.isCheck)
    {
        _checkImgView.hidden = NO;
    }
    else
    {
        _checkImgView.hidden = YES;
    }
}

@end
