//
//  MyRestaurantDataViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantDataViewController.h"
#import "LocalCommon.h"
#import "UserLoginStateObject.h"
#import "MyRestaurantImageViewCell.h" // 餐厅不骗浏览cell
#import "MyRestaurantFeatureViewCell.h" //  我的餐厅特色cell(餐厅名、菜系、商圈、口号)
#import "RestaurantDetailDataEntity.h"
#import "MyRestaurantIntroViewCell.h" // 餐厅简介
#import "MyRestaurantCommonViewCell.h" // 人均消费、地址等
#import "ShopDetailChefInfoViewCell.h" // 厨师信息cell
#import "ORestQualifCertViewCell.h" // 资质认证cell
#import "OpenRestaurantInputEntity.h"
#import "ShopOrderDetailBottomView.h"


@interface MyRestaurantDataViewController ()
{
    ShopOrderDetailBottomView *_bottomView;
}
/**
 *  餐厅详情信息
 */
//@property (nonatomic, strong) RestaurantDetailDataEntity *detailEntity;

- (void)initWithBottomView;

/**
 *  得到餐厅详情信息
 */
- (void)getRestaurantDetailData;

@end

@implementation MyRestaurantDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐厅资料";
    
    UIImage *image = [UIImage imageNamed:@"data_btn_edit"];
    UIButton *btnEdit = [TYZCreateCommonObject createWithButton:self imgNameNor:@"data_btn_edit" imgNameSel:@"data_btn_edit" targetSel:@selector(clickedWithEdit:)];
    btnEdit.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = itemEdit;
}

- (void)initWithSubView
{
//    debugLog(@"餐厅信息");
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = self.baseTableView.frame;
    frame.size.height = frame.size.height - [app tabBarHeight];
    self.baseTableView.frame = frame;
    
    [self initWithBottomView];
    
//    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    AppDelegate *app = [UtilityObject appDelegate];
//    self.baseTableView.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] * 2 - STATUSBAR_HEIGHT - [app tabBarHeight];
//    self.baseTableView.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] * 2 - STATUSBAR_HEIGHT;
}

- (void)doRefreshData
{
    [super doRefreshData];
    // 得到餐厅详情信息
    [self getRestaurantDetailData];
}

- (BOOL)refreshData
{
    if (!_detailEntity)
    {
        return YES;
    }
    return NO;
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[ShopOrderDetailBottomView alloc] initWithFrame:frame];
        [self.view addSubview:_bottomView];
    }
    [_bottomView updateViewData:nil type:3 leftTitle:nil rightTitle:@"预览"];
    __weak typeof(self)weakSelf = self;
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [weakSelf touchWithBottom:title];
    };
}

- (void)refreshWithData:(id)detailEnt
{
//    debugMethod();
    if (!detailEnt)
    {
        return;
    }
    self.detailEntity = detailEnt;
    [self.baseTableView reloadData];
}

/// 编辑
- (void)clickedWithEdit:(id)sender
{
    OpenRestaurantInputEntity *inputEnt = [OpenRestaurantInputEntity new];
    inputEnt.shopId = _detailEntity.details.shopId;
    // 1表示从登录这里，点击的“我要开店”;2表示点击编辑按钮进入的；3表示从餐厅列表中进入的，创建餐厅
    inputEnt.comeType = 2;
    // 餐厅信息编辑视图
    [MCYPushViewController showWithOpenRestaurantInfoVC:self inputData:inputEnt data:nil completion:^(id data) {
        [self refreshWithData:data];
    }];
}

// 预览
- (void)touchWithBottom:(NSString *)title
{
    [MCYPushViewController showWithRestaurantPreviewVC:self data:nil completion:nil];
}

/**
 *  得到餐厅详情信息
 */
- (void)getRestaurantDetailData
{
    // 餐厅id
    NSInteger shopId = [UserLoginStateObject getUserInfo].shop_id;
    [HCSNetHttp requestWithShopShow:shopId completion:^(id result) {
        [self getRestaurantDetailData:result];
    }];
}

- (void)getRestaurantDetailData:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        self.detailEntity = respond.data;
        _detailEntity.details.sloganHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.slogan) font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        // 餐厅简介
        _detailEntity.details.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
        // 厨师简介
        _detailEntity.topchef.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.topchef.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
        [self.baseTableView reloadData];
        [SVProgressHUD dismiss];
        
        if (self.popResultBlock)
        {
            self.popResultBlock(_detailEntity.details.name);
        }
        
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_detailEntity)
    {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = EN_RESTAURANT_INFO_MAX_ROW;
    if (!_detailEntity)
    {
        count = 0;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     EN_RESTAURANT_INFO_IMAGE_ROW = 0, ///< 餐厅图片
     EN_RESTAURANT_INFO_FEATURE_ROW, ///< 餐厅名称、菜系、口号
     EN_RESTAURANT_INFO_INTRO_ROW, ///< 餐厅简介
     EN_RESTAURANT_INFO_AVERAGE_ROW, ///< 人均消费
     EN_RESTAURANT_INFO_ADDRESS_ROW, ///< 餐厅地址
     EN_RESTAURANT_INFO_MOBILE_ROW, ///< 联系电话
     EN_RESTAURANT_INFO_PAYACCOUNT_ROW,
     */

    if (indexPath.row == EN_RESTAURANT_INFO_IMAGE_ROW)
    {// 餐厅图片
        MyRestaurantImageViewCell *cell = [MyRestaurantImageViewCell cellForTableView:tableView];
        [cell updateCellData:_detailEntity.shopImages];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_FEATURE_ROW)
    {// 我的餐厅特色(餐厅名、菜系、商圈、口号)
        MyRestaurantFeatureViewCell *cell = [MyRestaurantFeatureViewCell cellForTableView:tableView];
        [cell updateCellData:_detailEntity.details];
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_INTRO_ROW)
    {// 餐厅简介
        MyRestaurantIntroViewCell *cell = [MyRestaurantIntroViewCell cellForTableView:tableView];
        [cell updateCellData:_detailEntity.details];
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_AVERAGE_ROW)
    {// 人均消费 hall_icon_consume
        MyRestaurantCommonViewCell *cell = [MyRestaurantCommonViewCell cellForTableView:tableView];
//        _detailEntity.details.average
        NSString *str = [NSString stringWithFormat:@"人均消费：%d", (int)
_detailEntity.details.average];
        [cell updateCellData:str imageName:@"hall_icon_consume"];
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_ADDRESS_ROW)
    {// 餐厅地址 hall_icon_addr
        MyRestaurantCommonViewCell *cell = [MyRestaurantCommonViewCell cellForTableView:tableView];
        [cell updateCellData:objectNull(_detailEntity.details.address) imageName:@"hall_icon_addr"];
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_MOBILE_ROW)
    {// 餐厅联系电话 hall_icon_phone
        MyRestaurantCommonViewCell *cell = [MyRestaurantCommonViewCell cellForTableView:tableView];
        [cell updateCellData:objectNull(_detailEntity.details.mobile) imageName:@"hall_icon_phone"];
        return cell;
    }
    /*else if (indexPath.row == EN_RESTAURANT_INFO_PAYACCOUNT_ROW)
    {// 支付账号 hall_icon_disanfang
        MyRestaurantCommonViewCell *cell = [MyRestaurantCommonViewCell cellForTableView:tableView];
        [cell updateCellData:objectNull(_detailEntity.pay.account) imageName:@"hall_icon_disanfang"];
        return cell;
    }*/
    else if (indexPath.row == EN_RESTAURANT_INFO_CHEFINFO_ROW)
    {// 厨师信息
        ShopDetailChefInfoViewCell *cell = [ShopDetailChefInfoViewCell cellForTableView:tableView];
        [cell updateCellData:_detailEntity.topchef];
        [cell hiddenWithLine:YES];
        return cell;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_QUACERT_ROW)
    {// 资质认证
        ORestQualifCertViewCell *cell = [ORestQualifCertViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_detailEntity];
        [cell hiddenWithTitle:YES];
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 46.0;
    if (indexPath.row == EN_RESTAURANT_INFO_IMAGE_ROW)
    {// 餐厅图片浏览
        height = kMyRestaurantImageViewCellHeight;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_FEATURE_ROW)
    {// 我的餐厅特色(餐厅名、菜系、商圈、口号)
        height = kMyRestaurantFeatureViewCellHeight - 20 + _detailEntity.details.sloganHeight;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_INTRO_ROW)
    {// 餐厅简介
        return kMyRestaurantIntroViewCellHeight - 20 + _detailEntity.details.introHeight;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_CHEFINFO_ROW)
    {// 厨师信息
        return kShopDetailChefInfoViewCellHeight - 20 + _detailEntity.topchef.introHeight;
    }
    else if (indexPath.row == EN_RESTAURANT_INFO_QUACERT_ROW)
    {
        return [ORestQualifCertViewCell getQualifCertViewCellHeight];
    }
    
    return height;
}

@end
















