//
//  RestaurantImageView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantImageView.h"
#import "LocalCommon.h"


@interface RestaurantImageView ()
{
    UILabel *_titleLabel;
    
    UILabel *_descLabel;
}

- (void)initWithSubView;

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

/**
 *  点击
 *
 *  @param tap tap
 */
- (void)tapGesture:(UITapGestureRecognizer *)tap;

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap;

@end

@implementation RestaurantImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
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
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:longGesture];
    
    
    [self initWithTitleLabel];
    
    [self initWithDescLabel];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 0, self.width - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
    _titleLabel.bottom = self.height / 2 - 2;
//    _titleLabel.backgroundColor = [UIColor purpleColor];
    _titleLabel.text = @"形象照片";
}

- (void)initWithDescLabel
{
    CGRect frame = _titleLabel.frame;
    frame.size.height = 18;
    _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
    _descLabel.numberOfLines = 0;
    _descLabel.top = self.height / 2 + 2;
//    _descLabel.text = @"（门头或背景墙等）";
    _descLabel.numberOfLines = 0;
}

/**
 *  点击
 *
 *  @param tap tap
 */
- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_touchImageViewBlock)
    {
        _touchImageViewBlock(nil, 1);
    }
}

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
    if (_touchImageViewBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
//            debugLog(@"开始");
            _touchImageViewBlock(nil, 2);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
            debugLog(@"结束");
        }
//        _touchImageViewBlock(nil, 2);
    }
}

- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc
{
    _titleLabel.text = title;
    
    CGFloat height = [desc heightForFont:_descLabel.font width:_descLabel.width];
    
    _descLabel.height = height;
    _descLabel.text = desc;
    
}

- (void)hiddenLabel:(BOOL)hidden
{
    _titleLabel.hidden = hidden;
    
    _descLabel.hidden = hidden;
}

@end
