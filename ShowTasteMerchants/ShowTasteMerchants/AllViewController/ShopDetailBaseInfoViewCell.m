//
//  ShopDetailBaseInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailBaseInfoViewCell.h"
#import "LocalCommon.h"
#import "ShopBaseInfoDataEntity.h"

@interface ShopDetailBaseInfoViewCell ()
{
    ShopDetailBaseCookStyleView *_baseCookStyleView;
    
    ShopDetailBaseUserEvaluationView *_baseUserEvaluationView;
    
    ShopDetailBaseIntroView *_baseIntroView;
}

- (void)initWithBaseCookStyleView;

- (void)initWithBaseUserEvaluationView;

- (void)initWithBaseIntroView;

@end

@implementation ShopDetailBaseInfoViewCell

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
    
    [self initWithBaseCookStyleView];
    
    [self initWithBaseUserEvaluationView];
    
    [self initWithBaseIntroView];
}

- (void)initWithBaseCookStyleView
{
    if (!_baseCookStyleView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopDetailBaseCookStyleViewHeight);
        _baseCookStyleView = [[ShopDetailBaseCookStyleView alloc] initWithFrame:frame];
        [self.contentView addSubview:_baseCookStyleView];
    }
}

- (void)initWithBaseUserEvaluationView
{
    if (!_baseUserEvaluationView)
    {
        CGRect frame = CGRectMake(0, _baseCookStyleView.bottom, _baseCookStyleView.width, kShopDetailBaseUserEvaluationViewHeight);
        _baseUserEvaluationView = [[ShopDetailBaseUserEvaluationView alloc] initWithFrame:frame];
        [self.contentView addSubview:_baseUserEvaluationView];
    }
}

- (void)initWithBaseIntroView
{
    if (!_baseIntroView)
    {
        CGRect frame = CGRectMake(0, _baseUserEvaluationView.bottom, _baseUserEvaluationView.width, kShopDetailBaseIntroViewHeight);
        _baseIntroView = [[ShopDetailBaseIntroView alloc] initWithFrame:frame];
        [self.contentView addSubview:_baseIntroView];
    }
}

- (void)updateCellData:(id)cellEntity
{
    [_baseCookStyleView updateViewData:cellEntity];
    
    [_baseUserEvaluationView updateViewData:cellEntity];
    
    [_baseIntroView updateViewData:cellEntity];
}

@end
