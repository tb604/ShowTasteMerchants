//
//  MyRestaurantPreviewViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantPreviewViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"
#import "UserLoginStateObject.h"
#import "UINavigationBar+Awesome.h"
#import "ShopDetailHeadView.h"
#import "ShopDetailBaseInfoViewCell.h"
#import "ShopDetailPhoneAddressCell.h"
#import "ShopDetailChefInfoViewCell.h"
#import "ShopChefDataEntity.h"
#import "ShopDetailRecommendTitleViewCell.h"
#import "ShopDetailRecommendViewCell.h"
#import "CustomNavBarView.h"

@interface MyRestaurantPreviewViewController ()
{
    ShopDetailHeadView *_headerView;
    
    OpenRestaurantBottomView *_bottomView;
    
    BOOL _isTest;
}

@property (nonatomic, strong) NSArray *rightItemList;

@property (nonatomic, strong) UIImage *shareImage;

- (void)initWithBottomView;

@end

@implementation MyRestaurantPreviewViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    self.navigationController.navigationBarHidden = NO;
    
    
    [self scrollViewDidScroll:self.baseTableView];
    
    UIImage *image = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:image];
    
    _isTest = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    //    [self.navigationController.navigationBar wyx_reset];
    
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    [self.navigationController.navigationBar wyx_reset:color];
    
    _isTest = YES;
    
    [super viewWillDisappear:animated];
}

- (void)initWithVar
{
    [super initWithVar];
    
    [self scrollViewDidScroll:self.baseTableView];
    
    [self.navigationController.navigationBar wyx_setBackgroundColor:[UIColor clearColor]];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
//    self.title = _shopDetailEntity.details.name;
    
    
    
    
    /*UIImage *image = [UIImage imageNamed:@"nav_btn_collect_nor"];
    if (!_rightItemList)
    {
        
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *btnCollect = [TYZCreateCommonObject createWithButton:self imgNameNor:@"nav_btn_collect_nor" imgNameSel:@"nav_btn_collect_nor" targetSel:@selector(clickedButton:)];
        btnCollect.frame = frame;
        btnCollect.tag = 100;// 收藏
//        UIBarButtonItem *itemCollect = [[UIBarButtonItem alloc] initWithCustomView:btnCollect];
        
        image = [UIImage imageNamed:@"nav_btn_share_nor"];
        frame = CGRectMake(0, 0, image.size.width+10, image.size.height);
        UIButton *btnShare = [TYZCreateCommonObject createWithButton:self imgNameNor:@"nav_btn_share_nor" imgNameSel:@"nav_btn_share_nor" targetSel:@selector(clickedButton:)];
        btnShare.frame = frame;
        btnShare.tag = 101;// 分享
        UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
        self.rightItemList = [NSArray arrayWithObjects:itemShare, nil];
    }
    self.navigationItem.rightBarButtonItems = _rightItemList;
     */
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(64, 0, [[UIScreen mainScreen] screenWidth] - 64*2, [app navBarHeight]);
    CustomNavBarView *titleView = [[CustomNavBarView alloc] initWithFrame:frame];
    [titleView updateViewData:_shopDetailEntity.details.name titleColor:nil];
    self.navigationItem.titleView = titleView;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }

    
    [self hiddenFooterView:YES];
    [self hiddenHeaderView:YES];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app tabBarHeight]);
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeadView];
    
    [self initWithBottomView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *strUrl = [_shopDetailEntity.images objectOrNilAtIndex:0];
        // imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", imgUrl];
        strUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", strUrl];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
        self.shareImage = [UIImage imageWithData:data];
    });
}

- (void)initWithHeadView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [ShopDetailHeadView getHeadViewHeight]);
        _headerView = [[ShopDetailHeadView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:_shopDetailEntity.images];
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5701"];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    
    
    
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedBottom:data];
    };
    
    /*
     EN_SHOP_NOTAUDIT_STATE = 0, ///< 未审核
     EN_SHOP_WAITINGAUDIT_STATE = 1, ///< 待审核
     EN_SHOP_HAVEGAUDIT_STATE = 2, ///< 已审核
     EN_SHOP_PUBLISHED_STATE = 3, ///< 已发布
     EN_SHOP_OFFSHELVES_STATE = 4, ///< 已下架
     */
    
//    debugLog(@"state=%d", (int)_shopDetailEntity.details.state);
    if (_shopDetailEntity.details.state == EN_SHOP_HAVEGAUDIT_STATE || _shopDetailEntity.details.state == EN_SHOP_OFFSHELVES_STATE)
    {// 已审核 已下架
        /*  状态为2 时 预览界面底部bottom 显示为发布
         *  状态为3 时 预览界面底部bottom 显示为下架
         *  状态为4 时 预览界面底部bottom 显示为发布或者重新发布
         */
        [_bottomView updateViewData:@"发布"];
    }
    else if (_shopDetailEntity.details.state == EN_SHOP_PUBLISHED_STATE)
    {// 已发布
        [_bottomView updateViewData:@"下架"];
    }
    else
    {
        [_bottomView updateViewData:@"发布"];;
    }
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(nil);
    }
    [super clickedBack:sender];
}

- (void)clickedBottom:(id)data
{
    if ([data isEqualToString:@"发布"])
    {
        [SVProgressHUD showWithStatus:@"发布中"];
        [HCSNetHttp requestWithShopPublish:_shopDetailEntity.details.shopId userId:[UserLoginStateObject getUserId] completion:^(id result) {
            [self responseWithShopPublish:result];
        }];
    }
    else if ([data isEqualToString:@"下架"])
    {
        [SVProgressHUD showWithStatus:@"下架中"];
        [HCSNetHttp requestWithShopOffline:_shopDetailEntity.details.shopId userId:[UserLoginStateObject getUserId] completion:^(id result) {
            [self requestWithShopOffline:result];
        }];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    debugLog(@"%d", (int)button.tag);
    if (button.tag == 100)
    {// 收藏
        
    }
    else if (button.tag == 101)
    {// 分享
        NSInteger shopId = _shopDetailEntity.details.shopId;
//        debugLog(@"shopId=%d", (int)shopId);
//        self.shareImage = [UIImage imageNamed:@"book_icon_failure"];
//        [UtilityObject showWithShareView:self.view shareImage:self.shareImage shareContent:kShopDetailShareMsg shareUrl:kShopDetailShareUrl((int)shopId)];
        
        NSString *shareMsg = [NSString stringWithFormat:@"%@ %d元/人 %@", kShopDetailShareMsg, (int)_shopDetailEntity.details.average, _shopDetailEntity.details.intro];
        [UtilityObject showWithShareView:self.view shareImage:_shareImage shareTitle:_shopDetailEntity.details.name shareContent:shareMsg shareUrl:kShopDetailShareUrl((int)shopId)];
    }
}

// 发布后，返回来的状态
- (void)responseWithShopPublish:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        _shopDetailEntity.details.state = EN_SHOP_PUBLISHED_STATE;
        [self initWithBottomView];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 下架后，返回来的状态
- (void)requestWithShopOffline:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"下架成功"];
        _shopDetailEntity.details.state = EN_SHOP_OFFSHELVES_STATE;
        [self initWithBottomView];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        if (!_isTest)
        {
            [self initWithNavBar];
        }
        else
        {
            [self performSelector:@selector(initWithNavBar) withObject:nil afterDelay:0.0];
        }
    }
    else
    {
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:0]];
//        [self.navigationController.navigationBar wyx_setTitleColor:[UIColor colorWithWhite:1 alpha:0]];
    }
}


/**
 *  电话、地址
 *
 *  @param data <#data description#>
 */
- (void)phoneAddress:(id)data
{
    if ([data integerValue] == 100)
    {// 电话
        [MCYPushViewController callWithPhone:self phone:_shopDetailEntity.details.mobile];
    }
    else if ([data integerValue] == 101)
    {// 地址
        if ([objectNull(_shopDetailEntity.details.address) isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"暂时没有地址"];
            return;
        }
        [MCYPushViewController showWithPositionMapVC:self data:_shopDetailEntity.details.address completion:nil];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 3;
    if ([_shopDetailEntity.recommends count] != 0)
    {
       count += _shopDetailEntity.recommends.count + 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 0)
    {
        ShopDetailBaseInfoViewCell *cell = [ShopDetailBaseInfoViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_shopDetailEntity.details];
        return cell;
    }
    else if (indexPath.row == 1)
    {// 联系方式、地址
        ShopDetailPhoneAddressCell *cell = [ShopDetailPhoneAddressCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_shopDetailEntity.details];
        cell.baseTableViewCellBlock = ^(id data)
        {
            [weakSelf phoneAddress:data];
        };
        return cell;
    }
    else if (indexPath.row == 2)
    {// 厨师信息
        ShopDetailChefInfoViewCell *cell = [ShopDetailChefInfoViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ShopChefDataEntity *chefEnt = [ShopChefDataEntity new];
        chefEnt.chef_name = _shopDetailEntity.topchef.name;
        ShopChefImageDataEntity *imageEnt = [ShopChefImageDataEntity new];
        imageEnt.imageId = _shopDetailEntity.topchef.image_id;
        imageEnt.name = _shopDetailEntity.topchef.image;
        chefEnt.chef_image = [NSArray arrayWithObjects:imageEnt, nil];
        chefEnt.chef_title = _shopDetailEntity.topchef.title;
        chefEnt.chef_intro = _shopDetailEntity.topchef.intro;
        chefEnt.chef_introHeight = _shopDetailEntity.topchef.introHeight;
        
        [cell updateCellData:chefEnt];
        return cell;
    }
    else if ([_shopDetailEntity.recommends count] > 0 && ([_shopDetailEntity.recommends count]+1 > (indexPath.row-3)))
    {// 推荐列表，1为标题
        if (indexPath.row == 3)
        {// 标题
            ShopDetailRecommendTitleViewCell *cell = [ShopDetailRecommendTitleViewCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            id recommendEnt = _shopDetailEntity.recommends[indexPath.row-4];
            ShopDetailRecommendViewCell *cell = [ShopDetailRecommendViewCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:recommendEnt];
            return cell;
        }
    }
    
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {// 基本信息
        return kShopDetailBaseInfoViewCellHeight - 20 + _shopDetailEntity.details.introHeight;
    }
    else if (indexPath.row == 1)
    {// 联系方式、地址
        return kShopDetailPhoneAddressCellHeight;
    }
    else if (indexPath.row == 2)
    {// 厨师信息
        return kShopDetailChefInfoViewCellHeight - 20 + _shopDetailEntity.topchef.introHeight;
    }
    else if ([_shopDetailEntity.recommends count] > 0 && ([_shopDetailEntity.recommends count]+1 > (indexPath.row-3)))
    {
        if (indexPath.row == 3)
        {
            return kShopDetailRecommendTitleViewCellHeight;
        }
        else
        {
            return kShopDetailRecommendViewCellHeight;
        }
    }
    return 60;
}





@end
