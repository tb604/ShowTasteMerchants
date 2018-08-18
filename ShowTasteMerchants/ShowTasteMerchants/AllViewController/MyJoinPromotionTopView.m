//
//  MyJoinPromotionTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyJoinPromotionTopView.h"
#import "LocalCommon.h"

@interface MyJoinPromotionTopView ()
{
    // invite_icon_ren@
    // join_icon_bang
    
    UIImageView *_thumalImgView;
    
    /**
     *  规则
     */
    UILabel *_ruleLabel;
    
    /**
     *  1表示加入推广；2表示邀请好友
     */
    NSInteger _promotionType;
}

- (void)initWithThuamlImgView;

- (void)initWithRuleLabel;

@end

@implementation MyJoinPromotionTopView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThuamlImgView];
    
    [self initWithRuleLabel];
    
}

- (void)initWithThuamlImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"invite_icon_ren"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        _thumalImgView.centerX = [[UIScreen mainScreen] screenWidth] / 2;
        _thumalImgView.centerY = self.height / 2 - 30;
        [self addSubview:_thumalImgView];
    }
    if (_promotionType == 1)
    {// 加入推广 join_icon_bang
        _thumalImgView.image = [UIImage imageNamed:@"join_icon_bang"];
    }
    else if (_promotionType == 2)
    {// 表示邀请好友
        _thumalImgView.image = [UIImage imageNamed:@"invite_icon_ren"];
    }
}

- (void)initWithRuleLabel
{
    if (!_ruleLabel)
    {
        CGRect frame = CGRectMake(15, self.height - 25 - 30, [[UIScreen mainScreen] screenWidth] - 30, 30);
        _ruleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
        _ruleLabel.text = @"条款及细则";
    }
}

+ (NSInteger)getWithHeight
{
    return [[UIScreen mainScreen] screenWidth] / 1.25;
}

- (void)updateViewData:(id)entity
{
    _promotionType = [entity integerValue];
    [self initWithThuamlImgView];
}

@end
