//
//  MyRestaurantManagerTopView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerTopView.h"
#import "LocalCommon.h"

@interface MyRestaurantManagerTopView ()
{
    /// “管理员”
    UILabel *_nameTitleLabel;
    
    /// “手机号”
    UILabel *_phoneTitleLabel;
    
    /// “角色”
    UILabel *_roleTitleLabel;
}

/**
 *  初始化“管理员”标题
 */
- (void)initWithNameTitleLabel;

/**
 *  初始化“手机号”标题
 */
- (void)initWithPhoneTitleLabel;

/**
 *  初始化“角色”标题
 */
- (void)initWithRoleTitleLabel;

@end

@implementation MyRestaurantManagerTopView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    
    // 初始化“管理员”标题
    [self initWithNameTitleLabel];
    
    // 初始化“手机号”标题
    [self initWithPhoneTitleLabel];
    
    // 初始化“角色”标题
    [self initWithRoleTitleLabel];
}

/**
 *  初始化“管理员”标题
 */
- (void)initWithNameTitleLabel
{
    if (!_nameTitleLabel)
    {
//        UIImage *image = [UIImage imageWithContentsOfFileName:@"home_top_head_yg.png"];
        float space = 10;
        NSString *str = @"唐斌你号呀我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"唐斌你号呀";
            space = 5;
        }
        else if (kiPhone6)
        {
            str = @"唐斌你号呀";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(10, (kMyRestaurantManagerTopViewHeight-20)/2., 30 + space + width, 16);
        _nameTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameTitleLabel.backgroundColor = [UIColor redColor];
        _nameTitleLabel.text = @"管理员";
    }
}

/**
 *  初始化“手机号”标题
 */
- (void)initWithPhoneTitleLabel
{
    if (!_phoneTitleLabel)
    {
        NSString *str = @"1826192960412312";
        if (kiPhone4 || kiPhone5)
        {
            str = @"1826192960413";
        }
        else if (kiPhone6)
        {
            str = @"1826192960412";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_nameTitleLabel.right + 5, 0, width, 20);
        _phoneTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _phoneTitleLabel.backgroundColor = [UIColor redColor];
        _phoneTitleLabel.centerY = _nameTitleLabel.centerY;
        _phoneTitleLabel.text = @"手机号";
    }
}

/**
 *  初始化“角色”标题
 */
- (void)initWithRoleTitleLabel
{
    if (!_roleTitleLabel)
    {
        NSString *str = @"管理员我的我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"管理员我";
        }
        else if (kiPhone6)
        {
            str = @"管理员我的";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_phoneTitleLabel.right + 5, 0, width, 20);
        _roleTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _roleTitleLabel.backgroundColor = [UIColor redColor];
        _roleTitleLabel.centerY = _nameTitleLabel.centerY;
        _roleTitleLabel.text = @"角色";
    }
}

@end














