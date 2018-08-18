//
//  ShopRepairManagerSectionHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairManagerSectionHeaderView.h"
#import "LocalCommon.h"

@interface ShopRepairManagerSectionHeaderView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation ShopRepairManagerSectionHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kShopRepairManagerSectionHeaderViewHeight-20)/2, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateViewData:(id)entity
{
    _titleLabel.text = entity;
}

@end














