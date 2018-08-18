//
//  OMNearFoodViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearFoodViewCell.h"
#import "LocalCommon.h"
#import "OrderMealDataEntity.h"

@interface OMNearFoodViewCell ()
{
    OMNearFoodTopView *_topView;
    
    OMNearFoodBottomView *_bottomView;
}

@property (nonatomic, strong) OrderMealDataEntity *dataEntity;

- (void)initWithTopView;

- (void)initWithBottomView;

@end

@implementation OMNearFoodViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    [self initWithTopView];
    
    [self initWithBottomView];
    
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOMNearFoodTopViewHeight);
        _topView = [[OMNearFoodTopView alloc] initWithFrame:frame];
        [self.contentView addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.touchWithMoreInfoBlock = ^()
    {
        if (weakSelf.touchWithMoreInfoBlock)
        {
            weakSelf.touchWithMoreInfoBlock();
        }
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        CGRect frame = CGRectMake(0, _topView.bottom, _topView.width, [OMNearFoodBottomView getNearFoodMidViewHeight]);
        _bottomView = [[OMNearFoodBottomView alloc] initWithFrame:frame];
        [self.contentView addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {// 附近美食
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}


+ (CGFloat)getNearFoodViewCellHeight
{
    return kOMNearFoodTopViewHeight + [OMNearFoodBottomView getNearFoodMidViewHeight];
}

- (void)updateCellData:(id)cellEntity
{
    self.dataEntity = cellEntity;
    // 标题“附近美食”
    [_topView updateViewData:_dataEntity.borad_name];
    
    // 餐厅图片和餐厅基本信息
    [_bottomView updateViewData:_dataEntity.content];
}

@end







