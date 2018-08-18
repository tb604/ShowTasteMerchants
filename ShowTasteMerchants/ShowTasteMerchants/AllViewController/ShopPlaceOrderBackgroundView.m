//
//  ShopPlaceOrderBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlaceOrderBackgroundView.h"
#import "ShopPlaceOrderView.h"
#import "LocalCommon.h"
#import "ShopPlacePrinterView.h"
#import "ShopMouthDataEntity.h"

@interface ShopPlaceOrderBackgroundView ()
{
    ShopPlaceOrderView *_placeOrderView;
}

/**
 *  打印机列表视图
 */
@property (nonatomic, strong) ShopPlacePrinterView *printerListView;

/**
 *  阴影效果
 */
@property (nonatomic, strong) UIView *tableViewShadow;

/**
 *  打印机list
 */
@property (nonatomic, strong) NSArray *printerList;

- (void)initWithSubView;

- (void)initWithPlaceOrderView;

/**
 *  初始化打印机列表视图
 */
- (void)initWithPrinterListView;

/**
 *  初始化阴影效果
 */
- (void)initWithTableViewShadow;

/**
 *  打印机列表视图显示或者隐藏
 *
 *  @param isShow <#isShow description#>
 */
- (void)scenicTableViewAnimateShow:(BOOL)isShow;

/**
 *  处理隐藏列表手势
 *
 *  @param gesture <#gesture description#>
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture;

@end


@implementation ShopPlaceOrderBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithPlaceOrderView];
    
    [self initWithPrinterListView];
    
    [self initWithTableViewShadow];
    
    // 隐藏景点列表手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipe];
#if !__has_feature(objc_arc)
    CC_SAFE_RELEASE_NULL(swipe);
#endif
}

- (void)initWithPlaceOrderView
{
    if (!_placeOrderView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, STATUSBAR_HEIGHT + [app navBarHeight], [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - [app navBarHeight]);
        _placeOrderView = [[ShopPlaceOrderView alloc] initWithFrame:frame];
        [self addSubview:_placeOrderView];
    }
    __weak typeof(self)weakSelf = self;
    _placeOrderView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(data);
        }
    };
    _placeOrderView.choicePrintBlock = ^(id data)
    {
        [weakSelf choiceWithPrinter];
    };
}

/**
 *  选择打印机
 */
- (void)choiceWithPrinter
{
    [self scenicTableViewAnimateShow:YES];
}

/**
 *  初始化景点列表视图
 */
- (void)initWithPrinterListView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = _placeOrderView.frame;
    frame.size.height = frame.size.height - [app tabBarHeight];
    frame.origin.x = [[UIScreen mainScreen] screenWidth];
    _printerListView = [[ShopPlacePrinterView alloc] initWithFrame:frame];
    _printerListView.backgroundColor = [UIColor orangeColor];
//    _sceneListView.delegate = self;
    [self addSubview:_printerListView];
    __weak typeof(self)weakSelf = self;
//    _printerListView.viewCommonBlock = ^(id data)
//    {
//        [weakSelf choiceWithPrinter:data];
//    };
    _printerListView.choicePrinterInfoBlock = ^(id data, NSInteger index)
    {
        [weakSelf choiceWithPrinter:data index:index];
    };
}

- (void)choiceWithPrinter:(ShopMouthDataEntity *)printEnt index:(NSInteger)index
{
    [_placeOrderView updateWithPrinterIndex:index];
    [self scenicTableViewAnimateShow:NO];
    
    if (self.choiceWithPrintIdBlock)
    {
        self.choiceWithPrintIdBlock(printEnt.id);//printEnt.id
    }
}

/**
 *  初始化阴影效果
 */
- (void)initWithTableViewShadow
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = _placeOrderView.frame;
    frame.size.height = frame.size.height - [app tabBarHeight];
    frame.origin.x = [[UIScreen mainScreen] screenWidth];
    _tableViewShadow = [[UIView alloc] initWithFrame:frame];
    _tableViewShadow.layer.shadowColor = [UIColor blackColor].CGColor;
    _tableViewShadow.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _tableViewShadow.layer.shadowOpacity = 0.5;
    _tableViewShadow.layer.shadowPath = [UIBezierPath bezierPathWithRect:_printerListView.bounds].CGPath;
    _tableViewShadow.layer.shadowRadius = 2;
    _tableViewShadow.layer.masksToBounds = NO;
    [self insertSubview:_tableViewShadow belowSubview:_printerListView];
}
#pragma mark end init

/**
 *  景点列表视图显示或者隐藏
 *
 *  @param isShow <#isShow description#>
 */
- (void)scenicTableViewAnimateShow:(BOOL)isShow
{
    CGRect frame = _printerListView.frame;
    if (isShow)
    {
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 3 * 2;
    }
    else
    {
        frame.origin.x = [[UIScreen mainScreen] screenWidth];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _printerListView.frame = frame;
        _tableViewShadow.frame = frame;
    }];
}

/**
 *  处理隐藏景点列表手势
 *
 *  @param gesture <#gesture description#>
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateRecognized)
    {
        return;
    }
    
    // 隐藏景点列表视图
    [self scenicTableViewAnimateShow:NO];
}


- (void)updateWithData:(id)data printerList:(NSArray *)printerList
{
    self.printerList = printerList;
    // ShopMouthDataEntity
//    debugLog(@"count=%d", (int)[_printerList count]);
    
    [_printerListView updateViewData:printerList];
    
    [_placeOrderView updateViewData:data printerList:printerList];
}


@end












