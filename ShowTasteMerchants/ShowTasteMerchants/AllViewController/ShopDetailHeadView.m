//
//  ShopDetailHeadView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailHeadView.h"
#import "LocalCommon.h"
#import "ShopDetailBaseDataEntity.h"
#import "SDCycleScrollView.h"
#import "RestaurantImageEntity.h"

@interface ShopDetailHeadView ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *imageLists;

@property (nonatomic, strong) ShopDetailBaseDataEntity *shopEntity;

- (void)initWithCycleScrollView;

@end


@implementation ShopDetailHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)initWithCycleScrollView
{
    if (!_cycleScrollView)
    {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height) delegate:nil placeholderImage:nil];
        //        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //        _cycleScrollView.titlesGroup = nil;
                _cycleScrollView.currentPageDotColor = [UIColor colorWithHexString:@"#fb2b03"]; // 自定义分页控件小点颜色
        [self addSubview:_cycleScrollView];
    }
    _cycleScrollView.imageURLStringsGroup = _imageLists;
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger index)
    {
        
    };
}

- (void)updateViewData:(id)entity
{
    if ([entity isKindOfClass:[NSArray class]])
    {
        NSMutableArray *addList = [[NSMutableArray alloc] initWithCapacity:0];
        for (id ent in entity)
        {
            if ([ent isKindOfClass:[RestaurantImageEntity class]])
            {
                [addList addObject:((RestaurantImageEntity *)ent).name];
            }
            else
            {
                [addList addObject:ent];
            }
        }
        self.imageLists = addList;
    }
    else
    {
        self.shopEntity = entity;
        self.imageLists = _shopEntity.images;
    }
    
    [self initWithCycleScrollView];
}

+ (NSInteger)getHeadViewHeight
{
    return ([[UIScreen mainScreen] screenWidth] / 1.45);
}

@end
