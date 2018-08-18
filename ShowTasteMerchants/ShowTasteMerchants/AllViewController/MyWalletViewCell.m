//
//  MyWalletViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MyWalletViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    UILabel *_subTitleLabel;
}

@property (nonatomic, strong) CellCommonDataEntity *commentEntity;

- (void)initWithThuamlImgView;

- (void)initWithTitleLabel;

- (void)initWithSubTitleLabel;

@end

@implementation MyWalletViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)initWithThuamlImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"wallet_icon_APP"];
        CGRect frame = CGRectMake(15, (kMyWalletViewCellHeight - image.size.height) / 2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
    _thumalImgView.image = [UIImage imageNamed:_commentEntity.thumalImgName];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = _thumalImgView.centerY;
    }
    _titleLabel.text = _commentEntity.title;
}

- (void)initWithSubTitleLabel
{
    if (!_subTitleLabel)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 3, 20);
        _subTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
        _subTitleLabel.centerY = _titleLabel.centerY;
        _subTitleLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    }
    _subTitleLabel.text = _commentEntity.subTitle;
}

- (void)updateCellData:(id)cellEntity
{
    self.commentEntity = cellEntity;
    
    [self initWithThuamlImgView];
    
    [self initWithTitleLabel];
    
    [self initWithSubTitleLabel];
}

@end

























