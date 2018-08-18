//
//  ShopDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "LocalCommon.h"
#import "OrderMealContentEntity.h"
#import "UINavigationBar+Awesome.h"
#import "ShopDetailBottomView.h"
#import "ShopDetailDataEntity.h" // 餐厅详情
#import "ShopDetailHeadView.h"
#import "ShopDetailBaseInfoViewCell.h"
#import "ShopDetailPhoneAddressCell.h" // 联系电话、地址
#import "ShopDetailChefInfoViewCell.h" // 厨师信息cell
#import "ShopDetailRecommendTitleViewCell.h" // 推荐标题cell
#import "ShopDetailRecommendViewCell.h" // 推荐cell
#import "RestaurantReservationInputEntity.h"
#import "UserLoginStateObject.h"
#import "ShopCommentViewCell.h"
#import "TYZDBManager.h"
#import "CustomNavBarView.h"
#import "ShopDetailMoreViewCell.h" // 更多

@interface ShopDetailViewController ()
{
    ShopDetailBottomView *_bottomView;
    
    BOOL _isShowHUD;
    
    ShopDetailHeadView *_headerView;
    
    BOOL _isTest;
}

@property (nonatomic, strong) CustomNavBarView *titleView;

/**
 *  分享的图片
 */
@property (nonatomic, strong) UIImage *shareImage;

/**
 *  收藏按钮
 */
@property (nonatomic, strong) UIButton *btnCollect;

@property (nonatomic, strong) ShopDetailHeadView *headerView;

@property (nonatomic, strong) ShopDetailDataEntity *shopDetailEntity;

@property (nonatomic, strong) NSArray *rightButtonImtes;

- (void)initWithBottomView;

- (void)initWithHeadView;

- (void)getShopDetailData;

@end

@implementation ShopDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.baseTableView];
    UIImage *image = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:image];
    _isTest = NO;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
////    [self initWithNavBar];
//    
//    _isTest = NO;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    [self.navigationController.navigationBar wyx_reset:color];
    
    _isTest = YES;
    
}


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
    
    [self.navigationController.navigationBar wyx_setBackgroundColor:[UIColor clearColor]];
}

- (void)initWithNavBar
{
//    [super initWithNavBar];
    [self initWithBackButton];
    
    self.title = _mealEntity.name;
    if ([_rightButtonImtes count] <= 0)
    {
        UIImage *image = [UIImage imageNamed:@"nav_btn_collect_nor"];
        CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton *btnCollect = [TYZCreateCommonObject createWithButton:self imgNameNor:@"hall_btn_like_nor" imgNameSel:@"hall_btn_like_sel" targetSel:@selector(clickedButton:)];
        btnCollect.frame = frame;
        btnCollect.tag = 100;// 收藏
        UIBarButtonItem *itemCollect = [[UIBarButtonItem alloc] initWithCustomView:btnCollect];
        self.btnCollect = btnCollect;
        _btnCollect.selected = [[TYZDBManager shareInstance] selectWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
        image = [UIImage imageNamed:@"nav_btn_share_nor"];
        frame = CGRectMake(0, 0, image.size.width+10, image.size.height);
        UIButton *btnShare = [TYZCreateCommonObject createWithButton:self imgNameNor:@"nav_btn_share_nor" imgNameSel:@"nav_btn_share_nor" targetSel:@selector(clickedButton:)];
        btnShare.frame = frame;
        btnShare.tag = 101;// 分享
        UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
        self.rightButtonImtes = [NSArray arrayWithObjects:itemShare, itemCollect, nil];
    }
    
    self.navigationItem.rightBarButtonItems = _rightButtonImtes;
    
    // title
//    _btnCollect.width
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(_btnCollect.width*2, 0, [[UIScreen mainScreen] screenWidth] - _btnCollect.width*4, [app navBarHeight]);
    CustomNavBarView *titleView = [[CustomNavBarView alloc] initWithFrame:frame];
//    titleView.backgroundColor = [UIColor lightGrayColor];
    self.titleView = titleView;
    [_titleView updateViewData:_mealEntity.name titleColor:nil];
    self.navigationItem.titleView = _titleView;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    AppDelegate * app = [UtilityObject appDelegate];
    CGRect frame = self.baseTableView.frame;
    frame.size.height = [[UIScreen mainScreen] screenHeight] - app.rootViewController.appTabBarHeight;
    self.baseTableView.frame = frame;
    [self hiddenFooterView:YES];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeadView];
    
    [self initWithBottomView];
    
    _isShowHUD = YES;
    [self doRefreshData];
    
    
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getShopDetailData];
}

- (void)clickedBack:(id)sender
{
    [UtilityObject removeCacheDataLocalKey:kCacheBookingShopingCartData fileName:kCacheBookingShopingCartFileName];
    
    [UtilityObject removeCacheDataLocalKey:kCacheInstantShopingCartData fileName:kCacheInstantShopingCartFileName];
    
    [super clickedBack:sender];
}

- (void)initWithHeadView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [ShopDetailHeadView getHeadViewHeight]);
        _headerView = [[ShopDetailHeadView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight]- app.rootViewController.appTabBarHeight, [[UIScreen mainScreen] screenWidth], app.rootViewController.appTabBarHeight);
        _bottomView = [[ShopDetailBottomView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {// 即时就餐、餐厅预订
        [weakSelf bottomViewBlock:data];
    };
}

- (void)getShopDetailData
{
    if (_isShowHUD)
    {
        [SVProgressHUD showWithStatus:@"加载中"];
    }
    _isShowHUD = NO;
    [HCSNetHttp requestWithShop:_mealEntity.shop_id completion:^(id result) {
        [self getShopDetailData:result];
    }];
}

- (void)getShopDetailData:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        self.shopDetailEntity = respond.data;
        
        [_titleView updateViewData:_shopDetailEntity.details.name titleColor:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *strUrl = [_shopDetailEntity.images objectOrNilAtIndex:0];
            strUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", strUrl];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
            self.shareImage = [UIImage imageWithData:data];
        });
        BOOL iscol = [[TYZDBManager shareInstance] selectWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
        debugLog(@"iscol=%d", iscol);
        if (iscol)
        {
            _shopDetailEntity.details.favorite = 1;
        }
        else
        {
            _shopDetailEntity.details.favorite = 0;
        }
        debugLog(@"评论条数=%d", (int)[_shopDetailEntity.comments count]);
//        debugLog(@"shopid=%d", (int)_shopDetailEntity.details.shopId);
//        debugLog(@"intro=%@", _shopDetailEntity.shop.base.intro);
        _shopDetailEntity.details.introHeight = [UtilityObject mulFontHeights:_shopDetailEntity.details.intro font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        _shopDetailEntity.topchef.introHeight = [UtilityObject mulFontHeights:_shopDetailEntity.topchef.intro font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
        CGFloat width = [[UIScreen mainScreen] screenWidth] - 15 - 120 - 10 - 15;
        for (ShopRecommendDataEntity *ent in _shopDetailEntity.recommends)
        {
            ent.introHeight = [UtilityObject mulFontHeights:ent.intro font:FONTSIZE_12 maxWidth:width];
        }
        
        // 评论
        for (ShopCommentDataEntity *commentEnt in _shopDetailEntity.comments)
        {
            CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 15 - 30 - 10 - 15;
            CGFloat fontHeight = [UtilityObject mulFontHeights:commentEnt.content font:FONTSIZE_15 maxWidth:maxWidth];
            commentEnt.contentHeight = fontHeight;
            commentEnt.imgWidth = (maxWidth - 8 * 2) / 3.0;
        }
        /*
         CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 10 * 3 - 40;
         CGFloat fontHeight = [ent.content heightForFont:FONTSIZE_16 width:maxWidth];
         fontHeight = (fontHeight > 20 ? fontHeight:20);
         ent.contentHeight = fontHeight;
         CGFloat imgWidth = ([[UIScreen mainScreen] screenWidth] - 10 * 3 -40.0 - 8 *2) / 3.0;
         ent.imgWidth = imgWidth;
         */
        
        [_headerView updateViewData:_shopDetailEntity.images];
        
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
    [SVProgressHUD dismiss];
}

- (void)bottomViewBlock:(NSString *)title
{
    NSInteger loginState = [UserLoginStateObject userLoginState];
    if (loginState == EUserUnlogin)
    {
        [MCYPushViewController showWithUserLoginVC:self data:@(1) completion:nil];
        return;
    }
    
    RestaurantReservationInputEntity *inputEntity = [RestaurantReservationInputEntity new];
    inputEntity.userId = [UserLoginStateObject getUserId];
    inputEntity.shopId = _shopDetailEntity.details.shopId;
    inputEntity.shopName = _shopDetailEntity.details.name;
    inputEntity.shopMobile = _shopDetailEntity.details.mobile;
    inputEntity.shopAddress = _shopDetailEntity.details.address;
    inputEntity.addType = 1; // 表示点餐
    // 即时就餐、餐厅预订
//    debugLog(@"=%@", title);
    if ([title isEqualToString:@"即时就餐"])
    {
//        inputEntity.fixedShopingCartList
        NSArray *cartList = [UtilityObject readCacheDataLocalKey:kCacheInstantShopingCartData saveFilename:kCacheInstantShopingCartFileName];
        if ([cartList count] != 0)
        {
            inputEntity.fixedShopingCartList = [NSMutableArray arrayWithArray:cartList];
        }
        inputEntity.type = 2;
        // 点击进入及时，就餐视图控制器
        [MCYPushViewController showWithRecipeVC:self data:inputEntity completion:^(id data) {
            
        }];
    }
    else if ([title isEqualToString:@"餐厅预订"])
    {// 进入餐厅预订
        NSArray *cartList = [UtilityObject readCacheDataLocalKey:kCacheBookingShopingCartData saveFilename:kCacheBookingShopingCartFileName];
        if ([cartList count] != 0)
        {
            inputEntity.fixedShopingCartList = [NSMutableArray arrayWithArray:cartList];
        }
        inputEntity.type = 1;
        NSDate *date = [NSDate date];
        inputEntity.dueDate = [date stringWithFormat:@"yyyy-MM-dd"];
        inputEntity.arriveShopTime = [date stringWithFormat:@"HH:mm"];
        inputEntity.number = 5;
        inputEntity.shopLocation = 1;
        inputEntity.shopLocationNote = @"包间";
        [MCYPushViewController showWithRestaurantReservationVC:self data:inputEntity completion:nil];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100)
    {// 收藏
        if (_shopDetailEntity.details.favorite == 0)
        {// 添加收藏
            [SVProgressHUD showWithStatus:@"收藏中"];
            [HCSNetHttp requestWithUserFavoriteAdd:[UserLoginStateObject getUserId] shopId:_shopDetailEntity.details.shopId completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    _shopDetailEntity.details.favorite = 1;
                    _btnCollect.selected = YES;
                    [[TYZDBManager shareInstance] insertWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
                    // [[TYZDBManager shareInstance] selectWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
        else
        {// 取消收藏
            [SVProgressHUD showWithStatus:@"取消中"];
            [HCSNetHttp requestWithUserFavoriteCancel:[UserLoginStateObject getUserId] shopId:_shopDetailEntity.details.shopId completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                    _shopDetailEntity.details.favorite = 0;
                    _btnCollect.selected = NO;
                    [[TYZDBManager shareInstance] deleteWithCollection:[UserLoginStateObject getUserId] shopId:_mealEntity.shop_id];
                }
                else
                {
                    [UtilityObject svProgressHUDError:respond viewContrller:self];
                }
            }];
        }
        
        
    }
    else if (btn.tag == 101)
    {// 分享
        // 分享餐厅详情
        NSInteger shopId = _shopDetailEntity.details.shopId;
//        NSString *url = [_shopDetailEntity.images objectOrNilAtIndex:0];
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

//        [UtilityObject showWithShareView:self.view shareImage:_shareImage shareContent:kShopDetailShareMsg shareUrl:kShopDetailShareUrl((int)shopId)];
        
        NSString *shareMsg = [NSString stringWithFormat:@"%@ %d元/人 %@", kShopDetailShareMsg, (int)_shopDetailEntity.details.average, _shopDetailEntity.details.intro];
        [UtilityObject showWithShareView:self.view shareImage:_shareImage shareTitle:_shopDetailEntity.details.name shareContent:shareMsg shareUrl:kShopDetailShareUrl((int)shopId)];
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
        if (!_shopDetailEntity.details.address || [_shopDetailEntity.details.address isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"暂时没有地址"];
            return;
        }
        [MCYPushViewController showWithPositionMapVC:self data:_shopDetailEntity.details.address completion:^(id data) {
            
        }];
    }
}

/// 更多评论
- (void)tapGestureMoreComment:(UITapGestureRecognizer *)tap
{
    [MCYPushViewController showWithShopCommentListVC:self data:@(_shopDetailEntity.details.shopId) completion:nil];
}

/// 更多菜品推荐
- (void)tapGestureMoreRecomment:(UITapGestureRecognizer *)tap
{
    [MCYPushViewController showWithShopMenuVC:self data:@(_shopDetailEntity.details.shopId) completion:nil];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    debugMethod();
    UIColor *color = [UIColor colorWithHexString:@"#393b40"];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        //debugLog(@"if");
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY)/64));
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
        //debugLog(@"else");
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 1;
    if ([_shopDetailEntity.recommends count] != 0)
    {
        count += 1;
    }
    if ([_shopDetailEntity.comments count] != 0)
    {
        count += 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        // 基本信息、电话地址、厨师信息
        NSInteger count = 3;
        if (!_shopDetailEntity)
        {
            count = 0;
        }
        return count;
    }
    else if (section == 1)
    {// 推荐
        NSInteger count = 0;
        if ([_shopDetailEntity.recommends count] > 0)
        {// 评论数，1为标题
            count =[_shopDetailEntity.recommends count] + 1 + 1;
        }
        return count;
    }
    
    // 评论
    return [_shopDetailEntity.comments count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {// 基本信息
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
            [cell updateCellData:_shopDetailEntity.topchef];
            return cell;
        }
        /*else if ([_shopDetailEntity.recommends count] > 0 && ([_shopDetailEntity.recommends count]+1 > (indexPath.row-3)))
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
        }*/
    }
    else if (indexPath.section == 1)
    {// 推荐列表，1为标题
        if (indexPath.row == 0)
        {// 标题
            ShopDetailRecommendTitleViewCell *cell = [ShopDetailRecommendTitleViewCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.row == _shopDetailEntity.recommends.count+1)
        {// 更多菜品
            ShopDetailMoreViewCell *cell = [ShopDetailMoreViewCell cellForTableView:tableView];
//            cell.textLabel.text = @"更多菜品";
            [cell updateCellData:@"更多菜品"];
            return cell;
        }
        else
        {
            NSInteger row = indexPath.row - 1;
            id recommendEnt = _shopDetailEntity.recommends[row];
            BOOL hidden = NO;
            if (row == _shopDetailEntity.recommends.count - 1)
            {
                hidden = YES;
            }
            ShopDetailRecommendViewCell *cell = [ShopDetailRecommendViewCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:recommendEnt];
            [cell hiddenWithLine:hidden];
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {// 评论
//        debugLog(@"评论");
        if (indexPath.row == _shopDetailEntity.comments.count)
        {
            ShopDetailMoreViewCell *cell = [ShopDetailMoreViewCell cellForTableView:tableView];
            [cell updateCellData:@"更多评论"];
            return cell;
        }
        else
        {
            BOOL hidden = NO;
            if (indexPath.row == _shopDetailEntity.comments.count - 1)
            {
                hidden = YES;
            }
            BOOL topHidden = YES;
            if (indexPath.row == 0)
            {
                topHidden = NO;
            }
            ShopCommentViewCell *cell = [ShopCommentViewCell cellForTableView:tableView];
            [cell updateCellData:_shopDetailEntity.comments[indexPath.row]];
            [cell hiddenWithLine:hidden];
            [cell hiddenWithTopLine:topHidden];
            return cell;
        }
    }

    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
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
        /*else if ([_shopDetailEntity.recommends count] > 0 && ([_shopDetailEntity.recommends count]+1 > (indexPath.row-3)))
        {
            if (indexPath.row == 3)
            {
                return kShopDetailRecommendTitleViewCellHeight;
            }
            else
            {
                return kShopDetailRecommendViewCellHeight;
            }
        }*/
    }
    else if (indexPath.section == 1)
    {// 推荐
        if (indexPath.row == 0)
        {
            return kShopDetailRecommendTitleViewCellHeight;
        }
        else if (indexPath.row == _shopDetailEntity.recommends.count+1)
        {// 更多菜品
            return 50.0;
        }
        else
        {
            return kShopDetailRecommendViewCellHeight;
        }
    }
    else if (indexPath.section == 2)
    {// 评论
        if (indexPath.row == _shopDetailEntity.comments.count)
        {
            return kShopDetailMoreViewCellHeight;
        }
        else
        {
            ShopCommentDataEntity *commentEnt = _shopDetailEntity.comments[indexPath.row];
            CGFloat height = kShopCommentViewCellHeight - 20 + commentEnt.contentHeight;
            if ([commentEnt.images count] > 0)
            {
                height = height + commentEnt.imgWidth + 5;
            }
            return height;
        }
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 10;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /*if (section == 1)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] / 2, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"更多菜品";
        UIImage *image = [UIImage imageNamed:@"hall_icon_zhuan"];
        UIImageView *thanImgView = [[UIImageView alloc] initWithImage:image];
        thanImgView.size = image.size;
        thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        thanImgView.centerY = label.centerY;
        [view addSubview:thanImgView];
        
        // tapGestureMoreRecomment
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMoreRecomment:)];
        [view addGestureRecognizer:tap];

        return view;
    }
    else if (section == 2)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] / 2, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"更多评论";
        UIImage *image = [UIImage imageNamed:@"hall_icon_zhuan"];
        UIImageView *thanImgView = [[UIImageView alloc] initWithImage:image];
        thanImgView.size = image.size;
        thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        thanImgView.centerY = label.centerY;
        [view addSubview:thanImgView];
        
//        [CALayer drawLine:view frame:CGRectMake(0, 39.4, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#c0c0c0"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureMoreComment:)];
        [view addGestureRecognizer:tap];
        return view;
    }*/
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {// 基本信息
//        NSInteger index = indexPath.row - 4;
//        ShopRecommendDataEntity *entity = _shopDetailEntity.recommends[index];
//        // 进入菜品详情视图控制器
//        [MCYPushViewController showWithDinersRecipeFoodDetailVC:self data:@(entity.id) shopCartList:nil isBrowse:YES completion:nil];
    }
    else if (indexPath.section == 1)
    {// 推荐
        if (indexPath.row == _shopDetailEntity.recommends.count+1)
        {// 更多菜品
            [self tapGestureMoreRecomment:nil];
        }
        else
        {
            NSInteger index = indexPath.row - 1;
            ShopRecommendDataEntity *entity = _shopDetailEntity.recommends[index];
            // 进入菜品详情视图控制器
            [MCYPushViewController showWithDinersRecipeFoodDetailVC:self data:@(entity.id) shopCartList:nil isBrowse:YES completion:nil];
        }
    }
    else if (indexPath.section == 2)
    {// 评论
//        debugLog(@"dfdf");
        if (indexPath.row == _shopDetailEntity.comments.count)
        {// 更多评论
            [self tapGestureMoreComment:nil];
        }
    }
}

@end













