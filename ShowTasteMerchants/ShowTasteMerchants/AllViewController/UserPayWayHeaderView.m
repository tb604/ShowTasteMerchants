//
//  UserPayWayHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPayWayHeaderView.h"
#import "LocalCommon.h"

@interface UserPayWayHeaderView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation UserPayWayHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffceb2"];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.text = @"支付方式";
}

@end




















