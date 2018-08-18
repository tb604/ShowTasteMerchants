//
//  DinersSearchViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/9.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchViewCell.h"
#import "LocalCommon.h"

@interface DinersSearchViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation DinersSearchViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"search_icon_histories"];
        CGRect frame = CGRectMake(15, (kDinersSearchViewCellHeight - image.size.height)/2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = _thumalImgView.centerY;
    }
}

- (void)updateCellData:(id)cellEntity
{
    _titleLabel.text = cellEntity;
}

@end













