//
//  DinersCreateOrderHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCreateOrderHeaderView.h"
#import "LocalCommon.h"

@interface DinersCreateOrderHeaderView ()
{
    UILabel *_stateLabel;
}

- (void)initWithStateLabel;

@end

@implementation DinersCreateOrderHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithStateLabel];
    
}

- (void)initWithStateLabel
{
    if (!_stateLabel)
    {
        CGRect frame = CGRectMake(20, (kDinersCreateOrderHeaderViewHeight - 30) / 2, [[UIScreen mainScreen] screenWidth] - 40, 30);
        _stateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)updateViewData:(id)entity
{
    NSInteger state = [entity integerValue];
    _stateLabel.text = [UtilityObject dinersWithOrderState:state];
    _stateLabel.textColor = [UtilityObject dinersWithOrderStateColor:state];
}

@end










