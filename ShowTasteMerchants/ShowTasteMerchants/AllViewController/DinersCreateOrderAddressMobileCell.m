//
//  DinersCreateOrderAddressMobileCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderAddressMobileCell.h"
#import "LocalCommon.h"

@interface DinersCreateOrderAddressMobileCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
}
@property (nonatomic, strong) CALayer *line;

- (void)initWithThumalImgView:(UIImage *)image;

- (void)initWithTitleLabel;

@end

@implementation DinersCreateOrderAddressMobileCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = kDinersCreateOrderAddressMobileCellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithThumalImgView:(UIImage *)image
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, (kDinersCreateOrderAddressMobileCellHeight-image.size.height)/2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 8, (kDinersCreateOrderAddressMobileCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 8 - 30, 20);
        _titleLabel =[TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)updateCellData:(id)cellEntity imageName:(NSString *)imageName
{

    [self initWithThumalImgView:[UIImage imageNamed:imageName]];
    
    [self initWithTitleLabel];
    _titleLabel.text = cellEntity;
}


@end

















