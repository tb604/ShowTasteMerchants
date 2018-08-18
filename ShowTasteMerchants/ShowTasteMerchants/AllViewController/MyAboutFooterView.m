//
//  MyAboutFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyAboutFooterView.h"
#import "LocalCommon.h"

@interface MyAboutFooterView ()
{
    UILabel *_copyrightLabel;
    
    UILabel *_companyNameOneLabel;
    
    UILabel *_companyNameTwoLabel;
}

- (void)initWithCopyrightLabel;

- (void)initWithCompanyNameOneLabel;

- (void)initWithCompanyNameTwoLabel;


@end

@implementation MyAboutFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithCopyrightLabel];
    
    [self initWithCompanyNameOneLabel];
    
    [self initWithCompanyNameTwoLabel];
}

- (void)initWithCopyrightLabel
{
    if (!_copyrightLabel)
    {
        CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _copyrightLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _copyrightLabel.text = @"Copyright © 2016 Chinatopchef. All Rights Reserved.";
        _copyrightLabel.bottom = self.height - 10;
        [self addSubview:_copyrightLabel];
    }
}

- (void)initWithCompanyNameOneLabel
{
    if (!_companyNameOneLabel)
    {
        CGRect frame = _copyrightLabel.frame;
        frame.size.height = 14;
        _companyNameOneLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _companyNameOneLabel.text = @"江苏好厨师网络科技有限公司";
        _companyNameOneLabel.bottom = _copyrightLabel.top;
        [self addSubview:_companyNameOneLabel];
    }
}

- (void)initWithCompanyNameTwoLabel
{
    if (!_companyNameTwoLabel)
    {
        CGRect frame = _companyNameOneLabel.frame;
        _companyNameTwoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        _companyNameTwoLabel.text = @"中国好厨师网络科技有限公司";
        _companyNameTwoLabel.bottom = _companyNameOneLabel.top;
        [self addSubview:_companyNameTwoLabel];
    }
}

@end














