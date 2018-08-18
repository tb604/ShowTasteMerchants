//
//  MyWalletViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletViewController.h"
#import "LocalCommon.h"
#import "MyWalletViewCell.h"
#import "MyWalletHeaderView.h"
#import "CellCommonDataEntity.h"

@interface MyWalletViewController ()
{
    MyWalletHeaderView *_headerView;
    
    // requestWithUserAccount
}


@end

@implementation MyWalletViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    // wallet_btn_back
//    [self updateWithBackImage:@"wallet_btn_back"];
    
//    AppDelegate *app = [UtilityObject appDelegate];
//    [app updateWithNavType:1]
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
//    // 去除自带的顶部阴影
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#cbcbcb"]]];
//    // 设置导航栏控制器颜色
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]] forBarMetrics:UIBarMetricsDefault];
    //    debugLog(@"translucent=%d", [UINavigationBar appearance].translucent);
//    if ([[UINavigationBar appearance] respondsToSelector:@selector(setTranslucent:)])
//    {
//        [[UINavigationBar appearance] setTranslucent:NO];
//    }

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self updateWithBackImage:@"nav_btn_back_nor"];
    
    [super viewDidDisappear:animated];
}

//- (UIViewController *)childViewControllerForStatusBarStyle
//{
//    return self.navigationController.topViewController;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    debugLog(@"2222222");
//    return UIStatusBarStyleDefault;
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBarHidden = NO;
    
    
}


- (void)initWithVar
{
    [super initWithVar];
    
    NSMutableArray *addList = [NSMutableArray new];
    CellCommonDataEntity *entit = [[CellCommonDataEntity alloc] init];
    entit.title = @"第三方支持";
    entit.thumalImgName = @"wallet_icon_APP";
    entit.subTitle = @"2个";
    [addList addObject:entit];
    [self.baseList addObject:addList];
    
    addList = [NSMutableArray new];
    entit = [[CellCommonDataEntity alloc] init];
    entit.title = @"充值";
    entit.thumalImgName = @"wallet_icon_pay";
    [addList addObject:entit];
    entit = [[CellCommonDataEntity alloc] init];
    entit.title = @"提现";
    entit.thumalImgName = @"wallet_icon_withdraw";
    [addList addObject:entit];
    [self.baseList addObject:addList];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self initWithBackButton];
    
    self.title = @"我的钱包";
    
    // 明细
    NSString *str = @"明细";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    CGRect frame = CGRectMake(0, 0, width, 30);
    UIButton *btn = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"明细" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithBtnRight:)];
    btn.frame = frame;
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = itemRight;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyWalletHeaderViewHeight);
        _headerView = [[MyWalletHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    
    [_headerView updateViewData:_walletEntity];
}

- (void)clickedWithBtnRight:(id)sender
{
    [MCYPushViewController showWithMyWalletDetailVC:self data:nil completion:^(id data) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_WALLET_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    /*switch (section)
    {
        case NS_WALLET_THIRD_SECTION:
            count = 1;
            break;
        //case NS_WALLET_TOPDEPOST_SECTION:
          //  count = EN_WALLET_TOPDEPOST_MAX_ROW;
        default:
            break;
    }*/
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWalletViewCell *cell = [MyWalletViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.section][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyWalletViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*if (indexPath.section == NS_WALLET_THIRD_SECTION)
    {
        if (indexPath.row == 0)
        {// 第三方支持
            [MCYPushViewController showWithMyWalletPayWayVC:self data:nil completion:^(id data) {
                
            }];
        }
    }*/
    /*else if (indexPath.section == NS_WALLET_TOPDEPOST_SECTION)
    {// 充值、提现
        if (indexPath.row == EN_WALLET_TOPUP_ROW)
        {// 充值
            [MCYPushViewController showWithMyWalletTopUpVC:self data:nil completion:^(id data) {
                
            }];
        }
        else if (indexPath.row == EN_WALLET_WITHDRAWAL_ROW)
        {// 提现
            [MCYPushViewController showWithMyWalletDrawalVC:self data:nil completion:^(id data) {
                
            }];
        }
    }*/
}

@end






















