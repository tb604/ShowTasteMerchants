//
//  OmHotFoodMiddleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMHotFoodMiddleView.h"
#import "LocalCommon.h"
#import "OMHotFoodSingleView.h"
#import "OrderMealContentEntity.h"

@interface OMHotFoodMiddleView ()
{
    UIScrollView *_scrollView;
    
    NSMutableArray *_allViewList;
}

@property (nonatomic, strong) NSArray *imgList;

- (void)initWithScrollView;

- (void)initWithAddAllView;

@end

@implementation OMHotFoodMiddleView

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
    
    _allViewList = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithScrollView];
    
    [self initWithAddAllView];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = [[self class] getHOtFoodMidViewHeight];
    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithScrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//        _scrollView.backgroundColor = [UIColor purpleColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
}

- (void)initWithAddAllView
{
    NSInteger count = [_allViewList count];
    for (OMHotFoodSingleView *view in _allViewList)
    {
        view.hidden = YES;
    }
    
    __weak typeof(self)weakSelf =self;
    CGFloat scWidth = 0.0;
    CGRect frame = CGRectMake(15, 0, [[self class] getMidImageWidth], [[self class] getHOtFoodMidViewHeight]);
    OMHotFoodSingleView *singleView = nil;
    for (NSInteger i=0; i<[_imgList count]; i++)
    {
        frame.origin.x = 15 + ([[self class] getMidImageWidth] + 10) * i;
        if (i< count)
        {
            singleView = _allViewList[i];
            [singleView updateViewData:_imgList[i]];
            singleView.hidden = NO;
        }
        else
        {
            singleView = [[OMHotFoodSingleView alloc] initWithFrame:frame];
            [singleView updateViewData:_imgList[i]];
            [_scrollView addSubview:singleView];
            [_allViewList addObject:singleView];
        }
        singleView.viewCommonBlock = ^(id data)
        {
            if (weakSelf.viewCommonBlock)
            {
                weakSelf.viewCommonBlock(data);
            }
        };
    }
    scWidth = singleView.right + 15;
    _scrollView.contentSize = CGSizeMake(scWidth, _scrollView.height);
}

+ (CGFloat)getHOtFoodMidViewHeight
{
    return [self getMidImageHeight] + 45.0;
}

+ (NSInteger)getMidImageWidth
{
    return [[UIScreen mainScreen] screenWidth] / 3.125;
//    NSInteger width = (int)(([[UIScreen mainScreen] screenWidth] - 15.0 - 10 * 2) / 17.0);
//    return width * 8;
}

+ (NSInteger)getMidImageHeight
{
    return [[UIScreen mainScreen] screenWidth] / 3.125;
//    return [self getMidImageWidth] / 1.6;
}

- (void)updateViewData:(id)entity
{
    self.imgList = entity;
    
    [self initWithAddAllView];
}

@end
















