//
//  DRFoodStandardActivityView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodStandardActivityView.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"


@interface DRFoodStandardActivityView ()
{
    UILabel *_activityTitleLabel;
    
    UIImageView *_acImgView;
    
    /**
     *  活动内容
     */
    UILabel *_activityMsgLabel;
}

@property (nonatomic, strong) CALayer *verLine;

- (void)initWithVerLine;

- (void)initWithActivityTitleLabel;

- (void)initWithAcImgView;

- (void)initWithActivityMsgLabel;

@end

@implementation DRFoodStandardActivityView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithVerLine];
    
    [self initWithActivityTitleLabel];
    
    [self initWithAcImgView];
    
    [self initWithActivityMsgLabel];
}

- (void)initWithVerLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(2, 16);
    line.top = 15;
    line.left = 15;
    
    line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    [self.layer addSublayer:line];
    self.verLine = line;
}

- (void)initWithActivityTitleLabel
{
    // order_icon_biaoqian
    UIImage *image = [UIImage imageNamed:@"order_icon_biaoqian"];
    CGRect frame = CGRectMake(15 + image.size.width, 10, 60, 20);
    if (!_activityTitleLabel)
    {
        _activityTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _activityTitleLabel.text = @"活动";
        _activityTitleLabel.centerY = _verLine.centerY;
    }
}

- (void)initWithAcImgView
{
    if (!_acImgView)
    {
        UIImage *image = [UIImage imageNamed:@"order_icon_biaoqian"];
        CGRect frame = CGRectMake(15, _verLine.bottom + 10, image.size.width, image.size.height);
        _acImgView = [[UIImageView alloc] initWithFrame:frame];
        _acImgView.image = image;
        [self addSubview:_acImgView];
    }
}

- (void)initWithActivityMsgLabel
{
    if (!_activityMsgLabel)
    {
        CGRect frame = CGRectMake(_acImgView.right + 5, _acImgView.top-2, [[UIScreen mainScreen] screenWidth] - _acImgView.right - 5 - 15, 20);
        _activityMsgLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _activityMsgLabel.numberOfLines = 0;
    }
}

- (void)updateViewData:(id)entity
{
    ShopFoodDataEntity *foodEntity = entity;
    if (foodEntity.remarkHeight == 20)
    {
        _activityMsgLabel.centerY = _acImgView.centerY;
    }
    else
    {
        _activityMsgLabel.top = _acImgView.top-2;
    }
    _activityMsgLabel.height = foodEntity.remarkHeight;
    NSString *str = @"暂无活动。";
    if (![objectNull(foodEntity.remark) isEqualToString:@""])
    {
        str = foodEntity.remark;
    }
    _activityMsgLabel.text = str;
}

@end
