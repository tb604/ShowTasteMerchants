//
//  RestaurantEditImageView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantEditImageView.h"
#import "LocalCommon.h"

@interface RestaurantEditImageView ()
{
    UILabel *_titleLabel;
    
    UILabel *_descLabel;
}
- (void)initWithSubView;

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation RestaurantEditImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    [self initWithDescLabel];
    
    [self initWithTitleLabel];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 0, self.width - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
    _titleLabel.numberOfLines = 0;
    _titleLabel.bottom = self.height / 2 - 4;

}

- (void)initWithDescLabel
{
    CGRect frame = CGRectMake(15, 0, self.width - 30, 20);
    _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _descLabel.top = self.height / 2 + 4;
    _descLabel.numberOfLines = 0;
    _descLabel.text = @"立即上传";
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_touchwithImgViewBlock)
    {
        _touchwithImgViewBlock(self);
    }
}

- (void)updateWithTitle:(NSString *)title
{
    if (!title)
    {
        _titleLabel.hidden = YES;
        _descLabel.hidden = YES;
    }
    else
    {
        CGFloat height = [title heightForFont:_titleLabel.font width:self.width - 30];
        height = (height < 20 ? 20 : height);
        _titleLabel.hidden = NO;
        _titleLabel.height = height;
        _titleLabel.bottom = self.height / 2 - 4;
        _titleLabel.text = title;
        _descLabel.hidden = NO;
    }
}

@end
