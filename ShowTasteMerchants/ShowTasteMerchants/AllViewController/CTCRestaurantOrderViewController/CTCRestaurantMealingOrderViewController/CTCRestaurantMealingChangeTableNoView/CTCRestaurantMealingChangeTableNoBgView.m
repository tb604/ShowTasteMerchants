/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingChangeTableNoBgView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/24 11:41
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingChangeTableNoBgView.h"
#import "LocalCommon.h"
#import "CTCRestaurantMealingChangeTableNoView.h"
#import "ShopSeatInfoEntity.h"

@interface CTCRestaurantMealingChangeTableNoBgView ()
{
    CTCRestaurantMealingChangeTableNoView *_changeTableNoView;
}
- (void)initWithSubView;

- (void)initWithChangeTableNoView;

@end

@implementation CTCRestaurantMealingChangeTableNoBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithChangeTableNoView];
    
}

- (void)initWithChangeTableNoView
{
    if (!_changeTableNoView)
    {
        CGRect frame = CGRectMake(0, 0, 300, 300);
        _changeTableNoView = [[CTCRestaurantMealingChangeTableNoView alloc] initWithFrame:frame];
        _changeTableNoView.backgroundColor = [UIColor whiteColor];
        _changeTableNoView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 20);
        [self addSubview:_changeTableNoView];
    }
    __weak typeof(self)weakSelf = self;
    _changeTableNoView.textFieldDidBeginEditBlock = ^()
    {
        [weakSelf textFieldDidBeginEdit];
    };
    
    _changeTableNoView.textFieldDidEndEditBlock = ^()
    {
        [weakSelf textFieldDidEndEdit];
    };
    
    _changeTableNoView.touchChangeCancelBlock = ^()
    {// 取消
        if (weakSelf.touchChangeCancelBlock)
        {
            weakSelf.touchChangeCancelBlock();
        }
    };
    _changeTableNoView.touchChangeSubmitBlock = ^(ShopSeatInfoEntity *seatEnt, NSString *tableNo, NSInteger number)
    {// 确认
        if (weakSelf.touchChangeSubmitBlock)
        {
            weakSelf.touchChangeSubmitBlock(seatEnt, tableNo, number);
        }
    };
}

// 编辑开始
- (void)textFieldDidBeginEdit
{
    if (kiPhone5)
    {
        _changeTableNoView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 55);
    }
    else if (kiPhone4)
    {
        _changeTableNoView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
    }
    else if (kiPhone6)
    {
        _changeTableNoView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 40);
    }
}

// 编辑结束
- (void)textFieldDidEndEdit
{
    _changeTableNoView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 20);
}

/**
 *  更新信息
 *
 *  @param seatList 大厅、、、
 *  @param tableNo 桌号
 *  @param number 人数
 *
 */
- (void)updateWithSeat:(NSArray *)seatList tableNo:(NSString *)tableNo number:(NSInteger)number seatLocId:(NSInteger)seatLocId
{
    [_changeTableNoView updateWithSeat:seatList tableNo:tableNo number:number seatLocId:seatLocId];
}

@end

























