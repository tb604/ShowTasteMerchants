//
//  DinersOrderDetailHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersOrderDetailHeaderView.h"
#import "LocalCommon.h"
#import "OrderDataEntity.h"

@interface DinersOrderDetailHeaderView ()
{
    UILabel *_stateLabel;
}

- (void)initWithStateLabel;

@end

@implementation DinersOrderDetailHeaderView

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
        CGRect frame = CGRectMake(20, (kDinersOrderDetailHeaderViewHeight - 20) / 2, [[UIScreen mainScreen] screenWidth] - 40, 20);
        _stateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(20) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)updateViewData:(id)entity
{
    OrderDataEntity *orderEnt = entity;
    _stateLabel.text = [UtilityObject dinersWithOrderState:orderEnt.status];
    _stateLabel.textColor = [UtilityObject dinersWithOrderStateColor:orderEnt.status];
}

@end







