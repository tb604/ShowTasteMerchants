//
//  FoodAavourableActivityView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FoodAavourableActivityView.h"
#import "LocalCommon.h"

@interface FoodAavourableActivityView ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation FoodAavourableActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithValueLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(15, (kFoodAavourableActivityViewHeight - 20) / 2, 40, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"kaicanting_btn_edit_nor"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        _thanImgView.centerY = _titleLabel.centerY;
        [self addSubview:_thanImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, (kFoodAavourableActivityViewHeight - 20) / 2, _thanImgView.left - _titleLabel.right - 10*2, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(16) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_valueLabel.text);
    }
}

- (void)updateViewData:(id)entity title:(NSString *)title
{
    CGFloat width = [title widthForFont:_titleLabel.font];
    _titleLabel.width = width;
    _titleLabel.text = title;
    
    NSString *str = objectNull(entity);
    if ([str isEqualToString:@""])
    {
        str = @"请输入优惠活动";
    }
    
    width = _thanImgView.left - _titleLabel.right - 20;
    _valueLabel.left = _titleLabel.right + 10;
    _valueLabel.width = width;
    _valueLabel.text = str;
}

@end
