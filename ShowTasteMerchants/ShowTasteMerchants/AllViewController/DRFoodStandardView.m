//
//  DRFoodStandardView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DRFoodStandardView.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"
#import "DRFoodStandardSingleView.h"

@interface DRFoodStandardView ()
{
    UILabel *_titleLabel;
    
    /**
     *  工艺
     */
    DRFoodStandardSingleView *_modeView;
    
    /**
     *  口味
     */
    DRFoodStandardSingleView *_tasteView;
}
@property (nonatomic, assign) BOOL isBrowse;

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

@property (nonatomic, strong) CALayer *verLine;

- (void)initWithVerLine;

- (void)initWithTitleLabel;

/**
 *  工艺
 */
- (void)initWithModeView;

/**
 *  口味
 */
- (void)initWithTasteView;

@end

@implementation DRFoodStandardView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithVerLine];
    
    [self initWithTitleLabel];
    
}

- (void)initWithVerLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(2, 16);
    line.top = 15;
    line.left = 15;
    
    line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    [self.layer addSublayer:line];
    self.verLine = line;
}

- (void)initWithTitleLabel
{
    UIImage *image = [UIImage imageNamed:@"order_icon_biaoqian"];
    CGRect frame = CGRectMake(15 + image.size.width, 10, 160, 16);
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"可选规格";
        _titleLabel.centerY = _verLine.centerY;
    }
}

/**
 *  工艺
 */
- (void)initWithModeView
{
    if (!_modeView)
    {
        if ([_foodEntity.standard.mode count] != 0)
        {
            CGRect frame = CGRectMake(0, _verLine.bottom + 10, [[UIScreen mainScreen] screenWidth], _foodEntity.standard.modeHeight);
            _modeView = [[DRFoodStandardSingleView alloc] initWithFrame:frame];
            [self addSubview:_modeView];
//            _modeView.backgroundColor = [UIColor purpleColor];
        }
    }
    [_modeView updateViewData:_foodEntity.standard.mode title:@"工艺" isBrowse:_isBrowse];
    __weak typeof(self)weakSelf = self;
    _modeView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.touchStandardBlock)
        {
            weakSelf.touchStandardBlock(1, data);
        }
    };
}

/**
 *  口味
 */
- (void)initWithTasteView
{
    if (!_tasteView)
    {
        NSInteger tasts = [_foodEntity.standard.taste count];
        NSInteger modes = [_foodEntity.standard.mode count];
        if (tasts != 0)
        {
            CGRect frame = CGRectMake(0, _modeView.bottom + 15, [[UIScreen mainScreen] screenWidth], _foodEntity.standard.tasteHeight);
            if (modes == 0)
            {
                frame.origin.y = _verLine.bottom + 10;
            }
            _tasteView = [[DRFoodStandardSingleView alloc] initWithFrame:frame];
//            _tasteView.backgroundColor = [UIColor purpleColor];
            [self addSubview:_tasteView];
        }
    }
    __weak typeof(self)weakSelf = self;
    _tasteView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.touchStandardBlock)
        {
            weakSelf.touchStandardBlock(2, data);
        }
    };
    [_tasteView updateViewData:_foodEntity.standard.taste title:@"口味" isBrowse:_isBrowse];
}

- (void)updateViewData:(id)entity
{
    self.foodEntity = entity;
    
    // 工艺
    [self initWithModeView];
//    debugLogFrame(_modeView.frame);
    
    // 口味
    [self initWithTasteView];

    
}

- (void)updateViewData:(id)entity isBrowse:(BOOL)isBrowse
{
    self.isBrowse = isBrowse;
    [self updateViewData:entity];
}

@end

























