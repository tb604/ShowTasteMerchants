//
//  MyRestaurantMouthEditFoodSectionHeader.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthEditFoodSectionHeader.h"
#import "LocalCommon.h"

@interface MyRestaurantMouthEditFoodSectionHeader ()
{
    /**
     *  归档
     */
    UILabel *_archiveLabel;
    
    /**
     *  未归档
     */
    UILabel *_unarchiveLabel;
}

- (void)initWithArchiveLabel;

- (void)initWithUnarchiveLabel;

@end

@implementation MyRestaurantMouthEditFoodSectionHeader

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self frame:CGRectMake(0, kMyRestaurantMouthEditFoodSectionHeaderHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#ff5500"]];
    
    
    [self initWithArchiveLabel];
    
    [self initWithUnarchiveLabel];
    
}

- (void)initWithArchiveLabel
{
    if (!_archiveLabel)
    {
        CGRect frame = CGRectMake(0, 1, [[UIScreen mainScreen] screenWidth] / 2, kMyRestaurantMouthEditFoodSectionHeaderHeight - 2);
        _archiveLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentCenter];
        _archiveLabel.text = @"归档在列";
    }
}

- (void)initWithUnarchiveLabel
{
    if (!_unarchiveLabel)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] / 2, 1, [[UIScreen mainScreen] screenWidth] / 2, kMyRestaurantMouthEditFoodSectionHeaderHeight - 2);
        _unarchiveLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentCenter];
        _unarchiveLabel.text = @"未归档菜品";
    }
}

@end
