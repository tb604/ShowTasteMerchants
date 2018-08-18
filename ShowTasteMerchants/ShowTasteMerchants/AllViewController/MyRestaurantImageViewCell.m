//
//  MyRestaurantImageViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantImageViewCell.h"
#import "LocalCommon.h"
#import "SDCycleScrollView.h"
#import "RestaurantImageEntity.h"

@interface MyRestaurantImageViewCell ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *imageLists;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)initWithCycleScrollView;

- (void)initWithTitleLabel;

@end

@implementation MyRestaurantImageViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    self.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    [self initWithTitleLabel];
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:CGRectZero textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 60, 30);
        _titleLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2;
        _titleLabel.centerY = kMyRestaurantImageViewCellHeight / 2;
        _titleLabel.text = @"无图片";
    }
}

- (void)initWithCycleScrollView
{
    if (!_cycleScrollView)
    {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyRestaurantImageViewCellHeight) delegate:nil placeholderImage:nil];
        //        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        _cycleScrollView.titlesGroup = nil;
        //        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小点颜色
        [self addSubview:_cycleScrollView];
    }
        NSMutableArray *array = [NSMutableArray new];
        for (RestaurantImageEntity *ent in _imageLists)
        {
            [array addObject:ent.name];
        }
    _cycleScrollView.imageURLStringsGroup = array;
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger index)
    {
        
    };
}

- (void)updateCellData:(id)cellEntity
{
    self.imageLists = cellEntity;
    if ([_imageLists count] > 0)
    {
        [self initWithCycleScrollView];
        _cycleScrollView.hidden = NO;
        _titleLabel.hidden = YES;
    }
    else
    {
        _cycleScrollView.hidden = YES;
        _titleLabel.hidden = NO;
    }
}


@end

























