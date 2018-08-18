//
//  UserPaySuccessOrderViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPaySuccessOrderViewController.h"
#import "LocalCommon.h"
#import "UserPaySuccessOrderViewCell.h"
#import "UserPaySuccessOrderFooterView.h"
//#import "UserOrderViewController.h" // 订单

@interface UserPaySuccessOrderViewController ()
{
    UserPaySuccessOrderFooterView *_footerView;
}

- (void)initWithFooterView;

@end

@implementation UserPaySuccessOrderViewController

- (void)initWithVar
{
    [super initWithVar];
    
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"订单详情";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.baseTableView.scrollEnabled = NO;
    [self initWithFooterView];
}

- (void)clickedBack:(id)sender
{
    /*UserOrderViewController *userOrderVC = nil;
    NSArray *array = self.navigationController.viewControllers;
    for (id vc in array)
    {
//        debugLog(@"class=%@", NSStringFromClass([vc class]));
        if ([vc isKindOfClass:[UserOrderViewController class]])
        {
            userOrderVC = vc;
            break;
        }
    }
    if (userOrderVC)
    {
        [self.navigationController popToViewController:userOrderVC animated:YES];
    }
    else
    {*/
        [super clickedBack:sender];
    //}
}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kUserPaySuccessOrderFooterViewHeight);
    _footerView = [[UserPaySuccessOrderFooterView alloc] initWithFrame:frame];
    self.baseTableView.tableFooterView = _footerView;
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {
        [weakSelf showWithRecommend];
    };
}

// 进入评论视图控制器
- (void)showWithRecommend
{
    [MCYPushViewController showWithEvaluationPaySucVC:self data:_orderDetailEnt completion:^(id data) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserPaySuccessOrderViewCell *cell = [UserPaySuccessOrderViewCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:_orderDetailEnt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUserPaySuccessOrderViewCellHeight;
}

@end
























