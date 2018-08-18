//
//  OMMainBannerBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMMainBannerBottomView.h"
#import "LocalCommon.h"
#import "OrderMealDataEntity.h"

@interface OMMainBannerBottomView ()
{
    UILabel *_userNameLabel;
    
    UILabel *_descLabel;
    
}

- (void)initWithUserNameLabel;

- (void)initWithDescLabel;

@end

@implementation OMMainBannerBottomView

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
    
    [self initWithUserNameLabel];
    
    [self initWithDescLabel];
}


- (void)initWithLine
{
    
    [CALayer drawLine:self frame:CGRectMake(0, [OMMainBannerBottomView getWithViewHeight], [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#dbdbdb"]];
    
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
//    line.left = 0;
//    line.bottom = kOMMainBannerBottomViewHeight;
//    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
//    [self.layer addSublayer:line];
}

- (void)initWithUserNameLabel
{
    if (!_userNameLabel)
    {
        CGFloat top = 20;
        if (kiPhone6Plus)
        {
            top = 25;
        }
        else if (kiPhone5 || kiPhone4)
        {
            top = 12;
        }
        _userNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(20, top, [[UIScreen mainScreen] screenWidth] - 40, 30) textColor:[UIColor colorWithHexString:@"#323232"] fontSize:[UIFont ac_systemFontOfSize:50.0] labelTag:0 alignment:NSTextAlignmentCenter];
//        _userNameLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        NSInteger space = 10;
        if (kiPhone4 || kiPhone5)
        {
            space = 5;
        }
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(20, _userNameLabel.bottom + space, [[UIScreen mainScreen] screenWidth] - 40, 18) textColor:[UIColor colorWithHexString:@"#323232"] fontSize:[UIFont ac_systemFontOfSize:26.0] labelTag:0 alignment:NSTextAlignmentCenter];
//        _descLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)updateViewData:(id)entity
{
    OrderMealDataEntity *dataEnt = entity;
    UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
    NSString *familyname = objectNull(userInfo.family_name);
    NSString *lastname = objectNull(userInfo.name);
    NSString *name = @"游客，你好";
    if (![familyname isEqualToString:@""] && ![lastname isEqualToString:@""])
    {
        name = [NSString stringWithFormat:@"%@%@，你好", familyname, lastname];
    }
    _userNameLabel.text = name;
    
    _descLabel.text =([dataEnt.content count] > 0 ? dataEnt.content[0]:@"");
}

+ (NSInteger)getWithViewHeight
{
    // #define kOMMainBannerBottomViewHeight (kiPhone6Plus?108.0:96.0)
    NSInteger height = 96;
    if (kiPhone6Plus)
    {
        height = 108;
    }
    else if (kiPhone5 || kiPhone4)
    {
        height = 76;
    }
    return height;
}

@end












