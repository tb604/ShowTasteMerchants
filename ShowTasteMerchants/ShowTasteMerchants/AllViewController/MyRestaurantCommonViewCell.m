//
//  MyRestaurantCommonViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantCommonViewCell.h"
#import "LocalCommon.h"


@interface MyRestaurantCommonViewCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_valueLabel;
}

- (void)initWithThumalImgView;

- (void)initWithValueLabel;

@end

@implementation MyRestaurantCommonViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    
//    [self initWithLine];
    
    [self initWithThumalImgView];
    
    [self initWithValueLabel];
}

- (void)initWithLine
{
//    if (!_line)
//    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 15, 0.8);
        line.left = 15;
        line.bottom = kMyRestaurantCommonViewCellHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
        [self.contentView.layer addSublayer:line];
//        self.line = line;
//    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"hall_icon_disanfang"];
        CGRect frame = CGRectMake(15, (kMyRestaurantCommonViewCellHeight - image.size.height)/2, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, (kMyRestaurantCommonViewCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 10 - 15, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    _thumalImgView.size = image.size;
    _thumalImgView.image = image;
    _thumalImgView.centerY = _valueLabel.centerY;
    
    _valueLabel.text = cellEntity;
}

@end
