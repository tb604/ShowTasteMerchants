//
//  OMLOtherListButtonView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLOtherListButtonView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface OMLOtherListButtonView ()
{
    NSMutableArray *_otherList;
}

@end

@implementation OMLOtherListButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    // 餐厅订餐(home_icon_cantingyuding)、外卖订餐(home_icon_waimaidingcan)、家庭订餐(home_icon_jiatingcanting)、私厨预订(home_icon_sichuyuding)、邻里厨房(home_icon_linlichufang)
    _otherList = [NSMutableArray new];
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"餐厅订餐";
    ent.thumalImgName = @"home_icon_cantingyuding";
    [_otherList addObject:ent];
    ent = [CellCommonDataEntity new];
    ent.title = @"外卖订餐";
    ent.thumalImgName = @"home_icon_waimaidingcan";
    [_otherList addObject:ent];

    ent = [CellCommonDataEntity new];
    ent.title = @"家庭餐厅";
    ent.thumalImgName = @"home_icon_jiatingcanting";
    [_otherList addObject:ent];

    ent = [CellCommonDataEntity new];
    ent.title = @"私厨预订";
    ent.thumalImgName = @"home_icon_sichuyuding";
    [_otherList addObject:ent];

    ent = [CellCommonDataEntity new];
    ent.title = @"邻里厨房";
    ent.thumalImgName = @"home_icon_linlichufang";
    [_otherList addObject:ent];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
//    [self initWithLine];
    CGFloat space = 5;
    if (kiPhone4 || kiPhone5)
    {
        space = 10;
    }
    CGFloat vwidth = [OMLSingleButtonView getWithButtonWidth] + space;
    CGFloat leftSpace = 15;
    if (kiPhone6 || kiPhone6Plus)
    {
        leftSpace = 20;
    }
    CGFloat midSpace = ([[UIScreen mainScreen] screenWidth] - leftSpace * 2 - vwidth * _otherList.count) / (_otherList.count - 1);
    
    CGRect frame = CGRectMake(leftSpace, 0, vwidth, kOMLSingleButtonViewHeight);
    for (NSInteger i=0; i<[_otherList count]; i++)
    {
        frame.origin.x = leftSpace + (vwidth + midSpace) * i;
        OMLSingleButtonView *btnView = [[OMLSingleButtonView alloc] initWithFrame:frame];
//        btnView.backgroundColor = [UIColor purpleColor];
        btnView.centerY = kOMLOtherListButtonViewHeight / 2;
        [btnView updateViewData:_otherList[i]];
        [self addSubview:btnView];
        __weak typeof(self)weakSelf = self;
        btnView.viewCommonBlock = ^(id data)
        {
            if (weakSelf.viewCommonBlock)
            {
                weakSelf.viewCommonBlock(data);
            }
        };
    }
    
    // 餐厅订餐(home_icon_cantingyuding)、外卖订餐(home_icon_waimaidingcan)、家庭订餐(home_icon_jiatingcanting)、私厨预订(home_icon_sichuyuding)、邻里厨房(home_icon_linlichufang)
}

- (void)initWithLine
{
    /*CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kOMLOtherListButtonViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    [self.layer addSublayer:line];
     */
    
}

+ (NSInteger)getWithOtherSpace
{
    // #define kOMLOtherSpace (kiPhone6Plus?20:15)
    NSInteger space = 15;
    if (kiPhone6Plus)
    {
        space = 20;
    }
    else if (kiPhone5 || kiPhone4)
    {
        space = 8;
    }
    return space;
}

@end
