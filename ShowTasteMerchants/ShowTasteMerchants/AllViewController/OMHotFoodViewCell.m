//
//  OMHotFoodView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMHotFoodViewCell.h"
#import "LocalCommon.h"
#import "OrderMealDataEntity.h"

@interface OMHotFoodViewCell ()
{
    OMNearFoodTopView *_topView;
    
    OMHotFoodMiddleView *_bottomView;
}

@property (nonatomic, strong) OrderMealDataEntity *dataEntity;

- (void)initWithTopView;

- (void)initWithBottomView;

@end

@implementation OMHotFoodViewCell

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
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTopView];
    
    [self initWithBottomView];
}

- (void)initWithTopView
{
    if (!_topView)
    {
        _topView = [[OMNearFoodTopView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOMNearFoodTopViewHeight)];
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
    __weak typeof(self)weakSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[OMHotFoodMiddleView alloc] initWithFrame:CGRectMake(0, _topView.bottom, _topView.width, [OMHotFoodMiddleView getHOtFoodMidViewHeight])];
        [self.contentView addSubview:_bottomView];
    }
    _bottomView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}

+ (CGFloat)getHotFoodViewCellHeight
{
    CGFloat height = kOMNearFoodTopViewHeight + [OMHotFoodMiddleView getHOtFoodMidViewHeight];
    return height;
}

- (void)updateCellData:(id)cellEntity
{
    self.dataEntity = cellEntity;
    [_topView updateViewData:_dataEntity.borad_name];
    [_bottomView updateViewData:_dataEntity.content];
}

@end













