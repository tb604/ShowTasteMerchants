//
//  ORestQualifCertImageView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestQualifCertImageView.h"
#import "LocalCommon.h"


@interface ORestQualifCertImageView ()
{
    UILabel *_titleLabel;
    
    UILabel *_descLabel;
}


- (void)initWithSubView;

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ORestQualifCertImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    self.userInteractionEnabled = YES;
    
    [self initWithTitleLabel];
    
    [self initWithDescLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"您还没有上传图片哦~";
        _titleLabel.centerY = self.height / 2 - 10;
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.text = @"立刻上传";
        _descLabel.centerY = self.height / 2 + 10;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_touchImgViewBlock)
    {
        _touchImgViewBlock(@(self.tag));
    }
}

- (void)hiddenWithTitle:(BOOL)hidden
{
    _titleLabel.hidden = hidden;
    _descLabel.hidden = hidden;
}

@end























