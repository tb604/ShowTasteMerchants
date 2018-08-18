//
//  OMNearFoodSingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearFoodSingleView.h"
#import "LocalCommon.h"
#import "OrderMealContentEntity.h"
#import "UIImageView+WebCache.h"
#import "OMNearFoodBottomView.h"
#import "OMNearFoodSingleInfoView.h"

@interface OMNearFoodSingleView ()
{
    UIImageView *_thumalImgView;
    
    /**
     *  头像
     */
    UIImageView *_headerImgView;
    
    OMNearFoodSingleInfoView *_bottomInfoView;
    
}

@property (nonatomic, strong) OrderMealContentEntity *contentEnt;

- (void)initWithThumalImgView;

- (void)initWithHeaderImgView;

- (void)initWithBottomInfoView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation OMNearFoodSingleView

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
    
    [self initWithHeaderImgView];
    
    [self initWithBottomInfoView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 0, self.width, [OMNearFoodBottomView getMidImageHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
//        _thumalImgView.backgroundColor = [UIColor purpleColor];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithHeaderImgView
{
    if (!_headerImgView)
    {
        CGRect frame = CGRectMake(0, 0, 45.0, 45.0);
        _headerImgView = [[UIImageView alloc] initWithFrame:frame];
        _headerImgView.layer.cornerRadius = 45.0/2;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.right = _thumalImgView.width - 15;
        _headerImgView.centerY = _thumalImgView.height;
        [self addSubview:_headerImgView];
    }
}

- (void)initWithBottomInfoView
{
    if (!_bottomInfoView)
    {
        CGFloat boHeight = self.height - [OMNearFoodBottomView getMidImageHeight];
        CGRect frame = CGRectMake(0, _thumalImgView.bottom, _thumalImgView.width, boHeight);
        _bottomInfoView = [[OMNearFoodSingleInfoView alloc] initWithFrame:frame];
//        _bottomInfoView.backgroundColor = [UIColor blueColor];
        [self addSubview:_bottomInfoView];
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
//    debugLog(@"image=%@", contentEnt.default_image);
    
    NSString *imgUrl = objectNull(contentEnt.default_image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/80", imgUrl];
    }
    // 餐厅图片
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    
    // 厨师头像图片
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:contentEnt.topchef_image] placeholderImage:[UIImage imageNamed:@"chef_default_head"]];
    
    // 餐厅基本信息
    [_bottomInfoView updateViewData:contentEnt];
}


@end
