//
//  ShopPlaceOrderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlaceOrderView.h"
#import "LocalCommon.h"
#import "ShopOrderDetailBottomView.h"
#import "ShopAccountStatementRealPayView.h"
#import "ShopAccountStatementFoodCell.h"
#import "UserMeWantPayHeaderView.h"
#import "ShopAccountStatementMoneyFooterView.h"
#import "ShopPlaceOrderHeaderView.h"
#import "OrderEmptyView.h"
#import "ShopMouthDataEntity.h"

@interface ShopPlaceOrderView () <UITableViewDelegate, UITableViewDataSource>
{
    ShopPlaceOrderHeaderView *_headerView;
    
    UITableView *_placeOrderTableView;
    
    ShopOrderDetailBottomView *_bottomView;
    
    OrderEmptyView *_emptyView;
}


@property (nonatomic, strong) NSArray *foodList;

/**
 *  档口
 */
@property (nonatomic, strong) NSArray *printerList;
@property (nonatomic, assign) NSInteger selectPrinterIndex;

- (void)initWithPlaceOrderTableView;

- (void)initWithHeaderView;

- (void)initWithBottomView;

- (void)initWithEmptyView;

@end

@implementation ShopPlaceOrderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    _selectPrinterIndex = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithPlaceOrderTableView];
    
    [self initWithHeaderView];
    
    [self initWithBottomView];
    
    [self initWithEmptyView];
    
}

- (void)initWithPlaceOrderTableView
{
    if (!_placeOrderTableView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = self.bounds;
        frame.size.height = frame.size.height - [app tabBarHeight];
        _placeOrderTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _placeOrderTableView.delegate = self;
        _placeOrderTableView.dataSource = self;
        _placeOrderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_placeOrderTableView];
        _placeOrderTableView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopPlaceOrderHeaderViewHeight);
        _headerView = [[ShopPlaceOrderHeaderView alloc] initWithFrame:frame];
        _placeOrderTableView.tableHeaderView = _headerView;
    }
    __weak typeof(self)weakSelf = self;
    _headerView.viewCommonBlock = ^(id data)
    {// 点击按钮
        if (weakSelf.choicePrintBlock)
        {
            weakSelf.choicePrintBlock(data);
        }
    };
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
        _emptyView = [[OrderEmptyView alloc] initWithFrame:frame];
        [self addSubview:_emptyView];
        _emptyView.center = CGPointMake([[UIScreen mainScreen] screenWidth] / 2, [[UIScreen mainScreen] screenHeight] / 2 - 100);
        [_emptyView updateViewData:@"没有菜品要下单啦！"];
    }
    if ([_foodList count] != 0)
    {
        debugLog(@"ddfd");
        _emptyView.hidden = YES;
    }
    else
    {
        _emptyView.hidden = NO;
    }
}


- (void)initWithBottomView
{
    AppDelegate *app = [UtilityObject appDelegate];
//    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    CGRect frame = CGRectMake(0, self.height - [app tabBarHeight], [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - statusHeight - [app navBarHeight] - [app tabBarHeight]);
//    self.baseTableView.frame = frame;
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[ShopOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, self.height - [app tabBarHeight], [[UIScreen mainScreen] screenWidth], [app tabBarHeight])];
        [self addSubview:_bottomView];
    }
    if ([_foodList count] != 0)
    {
        [_bottomView updateViewData:nil type:5 leftTitle:@"取消" rightTitle:@"下单"];
    }
    else
    {
//        [_bottomView updateViewData:nil type:3 leftTitle:nil rightTitle:@"好的"];
        [_bottomView updateViewData:nil type:5 leftTitle:@"取消" rightTitle:@"补单"];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        if (blockSelf.viewCommonBlock)
        {
            blockSelf.viewCommonBlock(title);
        }
    };
    _bottomView.hidden = NO;
}

- (void)updateWithPrinterIndex:(NSInteger)index
{
    _selectPrinterIndex = index;
    ShopMouthDataEntity *mouthEnt = _printerList[_selectPrinterIndex];
    
    if ([_foodList count] != 0)
    {
        [_headerView updateViewData:@"新加菜品" printerName:mouthEnt.printer_name];
    }
    else
    {
        [_headerView updateViewData:@"提示" printerName:mouthEnt.printer_name];
    }
}

- (void)updateViewData:(id)entity printerList:(NSArray *)printerList
{
//    NSArray *array = entity;
//    id food = array[0];
//    debugLog(@"food.clas=%@", NSStringFromClass([food class]));
//    return;
    self.foodList = entity;
    self.printerList = printerList;
//    return;
//    debugLog(@"count=%d", (int)[_foodList count]);
    [self initWithEmptyView];
    [self initWithBottomView];
    
    ShopMouthDataEntity *mouthEnt = _printerList[_selectPrinterIndex];
//    return;
    if ([_foodList count] != 0)
    {
        [_headerView updateViewData:@"新加菜品" printerName:mouthEnt.printer_name];
    }
    else
    {
        [_headerView updateViewData:@"提示" printerName:mouthEnt.printer_name];
    }
    [_placeOrderTableView reloadData];
}

#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    debugLog(@"count=%d", (int)_foodList.count);
    if ([_foodList count] != 0)
    {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
    {
        count = [_foodList count];
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ShopAccountStatementFoodCell *cell = [ShopAccountStatementFoodCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_foodList[indexPath.row]];
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
    if (indexPath.section == 0)
    {
        OrderFoodInfoEntity *foodEntity = _foodList[indexPath.row];
        height = [ShopAccountStatementFoodCell getWithCellHeight:foodEntity];;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section == 0)
    {
        height = 30;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UserMeWantPayHeaderView *view = [[UserMeWantPayHeaderView alloc] initWithFrame:frame];
        return view;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return kShopAccountStatementMoneyFooterViewHeight;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    /*if (section == 0)
    {
        if (!_foodFooterView)
        {
            CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
            _foodFooterView = [[ShopAccountStatementMoneyFooterView alloc] initWithFrame:frame];
        }
        [_foodFooterView updateViewData:_orderDetailEntity.order];
        return _foodFooterView;
    }*/
    return nil;
}


@end
