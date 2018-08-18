//
//  OMHotFoodSingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMHotFoodSingleView.h"
#import "LocalCommon.h"
#import "OMHotFoodMiddleView.h"
#import "OrderMealContentEntity.h"
#import "UIImageView+WebCache.h"

@interface OMHotFoodSingleView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}

@property (nonatomic, strong) OrderMealContentEntity *contentEnt;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;


- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation OMHotFoodSingleView

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
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 0, self.width, [OMHotFoodMiddleView getMidImageHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGFloat boHeight = self.height - [OMHotFoodMiddleView getMidImageHeight];
        CGRect frame = CGRectMake(0, _thumalImgView.bottom + (boHeight-20.0)/2, _thumalImgView.width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#1a1a1a"] fontSize:FONTSIZE(16) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_contentEnt);
    }
}

- (void)updateViewData:(id)entity
{
    OrderMealContentEntity *contentEnt = entity;
    self.contentEnt = contentEnt;
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:contentEnt.image] placeholderImage:nil]; // [UIImage imageNamed:@"menu_icon_default"]
    _titleLabel.text = contentEnt.name;
}

@end
