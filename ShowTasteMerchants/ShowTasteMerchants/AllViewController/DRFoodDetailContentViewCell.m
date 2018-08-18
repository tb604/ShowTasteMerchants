//
//  DRFoodDetailContentViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodDetailContentViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodImageEntity.h"
#import "UIImageView+WebCache.h"

@interface DRFoodDetailContentViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_introLabel;
}
@property (nonatomic, strong) ShopFoodImageEntity *imageEntity;

@property (nonatomic, strong) CALayer *line;

- (void)initWithThumalImgView;

- (void)initWithIntroLabel;

@end

@implementation DRFoodDetailContentViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithIntroLabel];
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = [[self class] getWithCellHeight] - 20 + _introLabel.height;
        line.backgroundColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        [self.contentView.layer addSublayer:line];
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, [[self class] getWithImageViewHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithIntroLabel
{
    if (!_introLabel)
    {
        CGRect frame = CGRectMake(15, _thumalImgView.bottom + 5, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _introLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _introLabel.numberOfLines = 0;
//        _introLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

+ (NSInteger)getWithImageViewHeight
{
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - 30) / 1.625;
    return width;
}

+ (NSInteger)getWithCellHeight
{
    NSInteger height = 10 + [self getWithImageViewHeight] + 5 + 20 + 8;
    
    return height;
}

- (void)updateCellData:(id)cellEntity
{
    self.imageEntity = cellEntity;
    
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_imageEntity.image] placeholderImage:nil];
    
    _introLabel.height = _imageEntity.descHeight;
    _introLabel.text = _imageEntity.desc;
    [self initWithLine];
}

@end











