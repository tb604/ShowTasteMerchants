//
//  DRFoodDetailStandardViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodDetailStandardViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"


@interface DRFoodDetailStandardViewCell ()
{
    /**
     *  1表示工艺；2表示口味
     */
    DRFoodStandardView *_standardView;
    
    DRFoodStandardActivityView *_activityView;
}

@property (nonatomic, assign)BOOL isBrowse;

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

@property (nonatomic, strong) CALayer *line;

- (void)initWithStandardView;

- (void)initWithActivityView;

@end


@implementation DRFoodDetailStandardViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)initWithLine
{
    if (!_line)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
        line.left = 0;
        line.bottom = _foodEntity.standard.totalHeight;
        line.backgroundColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        [self.contentView.layer addSublayer:line];
        self.line = line;
    }
}

- (void)initWithStandardView
{
    if (!_standardView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _foodEntity.standard.totalHeight - (kDRFoodStandardActivityViewHeight - 20 + _foodEntity.remarkHeight));
        _standardView = [[DRFoodStandardView alloc] initWithFrame:frame];
//        _standardView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_standardView];
    }
    __weak typeof(self)weakSelf = self;
    _standardView.touchStandardBlock = ^(NSInteger type, NSString *title)
    {
        if (weakSelf.touchStandardBlock)
        {
            weakSelf.touchStandardBlock(type, title);
        }
    };
}

- (void)initWithActivityView
{
    if (!_activityView)
    {
        CGRect frame = CGRectMake(0, _standardView.bottom, [[UIScreen mainScreen] screenWidth], kDRFoodStandardActivityViewHeight - 20 + _foodEntity.remarkHeight);
        _activityView = [[DRFoodStandardActivityView alloc] initWithFrame:frame];
//        _activityView.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_activityView];
    }
}


- (void)updateCellData:(id)cellEntity
{
    ShopFoodDataEntity *foodEntity = cellEntity;
    self.foodEntity = foodEntity;
    [self initWithLine];
    
    if (_foodEntity.standard.state == 1)
    {
        [self initWithStandardView];
        
        [_standardView updateViewData:foodEntity isBrowse:_isBrowse];
    }
    
    [self initWithActivityView];
    // 活动信息
    [_activityView updateViewData:_foodEntity];
    
}

- (void)updateCellData:(id)cellEntity isBrowse:(BOOL)isBrowse
{
    self.isBrowse = isBrowse;
    [self updateCellData:cellEntity];
}

@end
