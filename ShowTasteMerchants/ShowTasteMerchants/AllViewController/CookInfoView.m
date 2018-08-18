//
//  CookInfoView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CookInfoView.h"
#import "LocalCommon.h"


@interface CookInfoView ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
}

@property (nonatomic, strong) CALayer *line;

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation CookInfoView

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
    
    [self initWithLine];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithValueLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = kCookInfoViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}


- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(0, (kCookInfoViewHeight - 20) / 2, 40, 20) textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        //        _titleLabel.backgroundColor = [UIColor lightGrayColor];
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
        _thanImgView.right = self.width;
        _thanImgView.centerY = _titleLabel.centerY;
        [self addSubview:_thanImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, (kCookInfoViewHeight - 20) / 2, _thanImgView.left - _titleLabel.right - 10*2, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
//        _valueLabel.backgroundColor = [UIColor purpleColor];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(self.tag));
    }
}


/**
 *  修改信息
 *
 *  @param title             标题
 *  @param titleWidth        标题宽度
 *  @param value             值
 *  @param valueWidth        值的宽度
 *  @param hiddenThanImgView 是否隐藏三角
 */
- (void)updateWithTitle:(NSAttributedString *)title titleWidth:(CGFloat)titleWidth value:(NSAttributedString *)value alignment:(NSTextAlignment)alignment
{
    _titleLabel.width = titleWidth;
    _titleLabel.attributedText = title;
    
    _valueLabel.left = _titleLabel.right + 10;
    _valueLabel.width = _thanImgView.left - _titleLabel.right - 10*2;
    _valueLabel.textAlignment = alignment;
    _valueLabel.attributedText = value;
}

- (void)hiddenBottomLine:(BOOL)hidden
{
    _line.hidden = hidden;
}

@end























