//
//  OMMainBannerTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMMainBannerTopView.h"
#import "LocalCommon.h"
#import "SDCycleScrollView.h"
#import "OrderMealContentEntity.h"
#import "OrderMealDataEntity.h"
#import "TYZAnimatedImagesView.h" // 多张图片动画
//#import "SDImageCache.h"
#import "MKAnnotationView+WebCache.h"
#import "SDWebImageManager.h"

@interface OMMainBannerTopView () <TYZAnimatedImagesViewDataSource>
{
    
}

/// 多张图片动画
@property (nonatomic, strong) TYZAnimatedImagesView *anImagesView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *imageLists;

@property (nonatomic, strong) OrderMealDataEntity *contentEntity;

- (void)initWithCycleScrollView;

- (void)initWithAnImagesView;

@end

@implementation OMMainBannerTopView

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
    
    [self initWithLine];
        
}

- (void)initWithLine
{
    
    [CALayer drawLine:self frame:CGRectMake(0, [[self class] getWithBannerHeight], [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#dbdbdb"]];
    
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
//    line.left = 0;
//    line.bottom = kOMMainBannerTopViewHeight;
//    line.backgroundColor = [UIColor purpleColor];//[UIColor colorWithHexString:@"#dbdbdb"].CGColor;
//    [self.layer addSublayer:line];
}

- (void)initWithCycleScrollView
{
    if (!_cycleScrollView)
    {
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, self.height) delegate:nil placeholderImage:nil];
//        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//        _cycleScrollView.titlesGroup = nil;
//        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小点颜色
        [self addSubview:_cycleScrollView];
    }
//    NSMutableArray *array = [NSMutableArray new];
//    for (OrderMealBannerEntity *ent in _imageLists)
//    {
//        [array addObject:ent.image];
//    }
    _cycleScrollView.imageURLStringsGroup = _imageLists;
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger index)
    {
        
    };
}

- (void)initWithAnImagesView
{
    if (!_anImagesView)
    {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _anImagesView = [[TYZAnimatedImagesView alloc] initWithFrame:frame];
        _anImagesView.transitionDuration = 2.f;
        _anImagesView.dataSource = self;
        _anImagesView.layer.masksToBounds = YES;
        [self addSubview:_anImagesView];
    }
}

+ (NSInteger)getWithBannerHeight
{
    NSInteger height = [[UIScreen mainScreen] screenWidth] / 1.033;
    if (kiPhone5)
    {
        height = height - 7;
    }
    else if (kiPhone4)
    {
        height = height - 15;
    }
    return height;
}

#pragma mark -
#pragma mark TYZAnimatedImagesViewDataSource

- (NSUInteger)animatedImagesNumberOfImages:(TYZAnimatedImagesView *)animatedImagesView
{
    NSUInteger count = [_imageLists count];
    return count;
}

- (NSString *)animatedImagesView:(TYZAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
    NSString *imgurl = _imageLists[index];
    return imgurl;
}

- (void)updateViewData:(id)entity
{
    self.contentEntity = entity;
    self.imageLists = _contentEntity.content;
    debugLog(@"list=%@", _imageLists);
    
    [self initWithAnImagesView];
    
//    [self initWithCycleScrollView];
}

@end






















