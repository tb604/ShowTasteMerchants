//
//  OMNearFoodBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearFoodBottomView.h"
#import "LocalCommon.h"
#import "OrderMealContentEntity.h"
#import "OMNearFoodSingleView.h"

@interface OMNearFoodBottomView ()
{
    UIScrollView *_scrollView;
    
    NSMutableArray *_allViewList;
    
    
}
@property (nonatomic, strong) NSArray *imgList;

/**
 *  上一次的imgList数量
 */
//@property (nonatomic, assign) NSInteger imgCount;

- (void)initWithScrollView;

- (void)initWithAddAllView;
@end

@implementation OMNearFoodBottomView

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
    
    _allViewList = [NSMutableArray new];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    [self initWithLine];
    
    [self initWithScrollView];

}

- (void)initWithLine
{
    [CALayer drawLine:self frame:CGRectMake(0, [[self class] getNearFoodMidViewHeight], [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#dbdbdb"]];
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
//    line.left = 0;
//    line.bottom = [[self class] getNearFoodMidViewHeight];
//    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
//    [self.layer addSublayer:line];
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
    debugMethod();
    __weak typeof(self)weakSelf =self;
    NSInteger count = [_allViewList count];
    for (OMNearFoodSingleView *view in _allViewList)
    {
        view.hidden = YES;
    }
    CGFloat scWidth = 0.0;
    CGRect frame = CGRectMake(0, 0, [[self class] getMidImageWidth], [[self class] getNearFoodMidViewHeight]);
    OMNearFoodSingleView *singleView = nil;
    for (NSInteger i=0; i<[_imgList count]; i++)
    {
        frame.origin.x = 0 + ([[self class] getMidImageWidth] + 10) * i;
        if (i < count)
        {
            singleView = _allViewList[i];
            [singleView updateViewData:_imgList[i]];
            singleView.hidden = NO;
        }
        else
        {
            singleView = [[OMNearFoodSingleView alloc] initWithFrame:frame];
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
    scWidth = singleView.right;

    
    _scrollView.contentSize = CGSizeMake(scWidth, _scrollView.height);
}



+ (CGFloat)getNearFoodMidViewHeight
{
    return [self getMidImageHeight] + 92.0;
}

+ (NSInteger)getMidImageWidth
{
    return [[UIScreen mainScreen] screenWidth] / 1.1718;
//    NSInteger width = (int)(([[UIScreen mainScreen] screenWidth] - 10.0) / 8.0);
//    return width * 7;
}

+ (NSInteger)getMidImageHeight
{
    return [[UIScreen mainScreen] screenWidth] / 1.63;
//    return [self getMidImageWidth] / 1.4;//[self getMidImageWidth] / 1.4;
}

- (void)updateViewData:(id)entity
{
    self.imgList = entity;
//    debugLog(@"imgLIst=%@", [_imgList modelToJSONString]);
    
    [self initWithAddAllView];
}



@end
