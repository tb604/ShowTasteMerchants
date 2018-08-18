//
//  XWPieChartTitleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "XWPieChartTitleView.h"
#import "LocalCommon.h"

@interface XWPieChartTitleView ()
{
    UIImageView *_iconImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithIconImgView;

- (void)initWithTitleLabel;

@end

@implementation XWPieChartTitleView

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
    
    [self initWithIconImgView];
    
    [self initWithTitleLabel];
}

- (void)initWithIconImgView
{
    if (!_iconImgView)
    {
        CGRect frame = CGRectMake(0, (self.height - 8)/2, 8, 8);
        _iconImgView = [[UIImageView alloc] initWithFrame:frame];
        _iconImgView.backgroundColor = [UIColor redColor];
        [self addSubview:_iconImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_iconImgView.right + 5, 0, self.width - _iconImgView.right - 5, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"为完成";
    }
}

+ (CGFloat)getWithWidth
{
    NSString *str = @"未完成";
    float width = [str widthForFont:FONTSIZE_12];
    
    return width + 8 + 5;
}

- (void)updateWithName:(NSString *)name color:(UIColor *)color
{
    _iconImgView.backgroundColor = color;
    _titleLabel.text = name;
}

@end























