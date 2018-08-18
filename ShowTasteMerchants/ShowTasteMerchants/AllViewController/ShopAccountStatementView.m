//
//  ShopAccountStatementView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAccountStatementView.h"
#import "LocalCommon.h"
#import "OrderDetailDataEntity.h"
#import "TYZBaseTableViewCell.h"
#import "ShopAccountStatementHeaderView.h"
//#import "ShopAccountStatementFoodTitleView.h"
#import "UserMeWantPayHeaderView.h"
//#import "UserPlaceEatingPayFoodViewCell.h"
#import "ShopAccountStatementFoodCell.h"
#import "ShopAccountStatementRealPayView.h"
#import "ShopAccountStatementMoneyFooterView.h"
#import "CTCMealOrderDetailsEntity.h"

@interface ShopAccountStatementView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_accountTableView;
    
    ShopAccountStatementHeaderView *_headerView;
    
    UIButton *_btnSubmit;
    
    ShopAccountStatementMoneyFooterView *_foodFooterView;
    
}

/**
 *  订单详情
 */
@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderDetailEntity;

- (void)initWithAccountTableView;

- (void)initWithHeaderView;

- (void)initWithSubmit;

@end

@implementation ShopAccountStatementView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithAccountTableView];
    
//    [self initWithHeaderView];
    
    [self initWithSubmit];
    
}


- (void)initWithAccountTableView
{
    if (!_accountTableView)
    {
        CGRect frame = self.bounds;
        frame.size.height = frame.size.height - 44;
        _accountTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
        _accountTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_accountTableView];
        _accountTableView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)initWithHeaderView
{
    __weak typeof(self)weakSelf = self;
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, self.width, [ShopAccountStatementHeaderView getWithViewHeight:_orderDetailEntity.type]);
        _headerView = [[ShopAccountStatementHeaderView alloc] initWithFrame:frame];
        _accountTableView.tableHeaderView = _headerView;
                                                     
    }
    [_headerView updateViewData:_orderDetailEntity];
    _headerView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(nil);
        }
    };
}


- (void)initWithSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = CGRectMake(0, _accountTableView.bottom, self.width, self.height - _accountTableView.height);
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认并发送给食客" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.tag = 101;
        _btnSubmit.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self addSubview:_btnSubmit];
    }
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_orderDetailEntity);
    }
}

- (void)updateViewData:(id)entity
{
    self.orderDetailEntity = entity;
    
//    [self initWithHeaderView];
    
    [_accountTableView reloadData];
    
    /*
    // 总金额
    CGFloat total_price = self.orderDetailEntity.order.total_price;
    
    // 活动价总额
    CGFloat total_ac_price = self.orderDetailEntity.order.total_act_price;
    
    //  预付订金
    CGFloat book_deposit_amount = self.orderDetailEntity.order.book_deposit_amount;
    
    // 商家折扣金额
    CGFloat shop_discount = self.orderDetailEntity.order.shop_discount;
    
    // 秀味折扣金额
    CGFloat xiuwei_discount = self.orderDetailEntity.order.xiuwei_discount;
    
    // 应付金额
    CGFloat pay_actually = self.orderDetailEntity.order.pay_actually;
    
    // 还需支付金额
    CGFloat pay_amount = self.orderDetailEntity.order.pay_amount;
    
    debugLog(@"总金额=%.2f; 活动价总额=%.2f; 预付订金=%.2f; 商家折扣金额=%.2f; 秀味折扣金额=%.2f; 应付金额=%.2f；还需支付金额=%.2f", total_price, total_ac_price, book_deposit_amount, shop_discount, xiuwei_discount, pay_actually, pay_amount);
    
    */
    
}


#pragma UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
    {
        count = [_orderDetailEntity.foods count];
    }
    else if (section == 1)
    {
        count = 1;
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        ShopAccountStatementFoodCell *cell = [ShopAccountStatementFoodCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_orderDetailEntity.foods[indexPath.row]];
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
        CTCMealOrderFoodEntity *foodEntity = _orderDetailEntity.foods[indexPath.row];
        height = [ShopAccountStatementFoodCell getWithCellHeight:foodEntity];
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
    else if (section == 1)
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
    else if (section == 1)
    {
        __weak typeof(self)weakSelf = self;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        ShopAccountStatementRealPayView *view = [[ShopAccountStatementRealPayView alloc] initWithFrame:frame];
        [view updateViewData:_orderDetailEntity];
        view.viewCommonBlock = ^(id data)
        {
//            debugMethod();
            if (weakSelf.modifyActuallyAmountBlock)
            {
                weakSelf.modifyActuallyAmountBlock(data);
            }
        };
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
    if (section == 0)
    {
        if (!_foodFooterView)
        {
            CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
            _foodFooterView = [[ShopAccountStatementMoneyFooterView alloc] initWithFrame:frame];
        }
        [_foodFooterView updateViewData:_orderDetailEntity];
        return _foodFooterView;
    }
    return nil;
}

@end












