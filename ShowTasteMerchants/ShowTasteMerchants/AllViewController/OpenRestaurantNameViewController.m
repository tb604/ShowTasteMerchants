//
//  OpenRestaurantNameViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantNameViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantNameTopView.h"
#import "OpenRestaurantBottomView.h"
#import "UserLoginStateObject.h"
#import "CuisineContentDataEntity.h"

@interface OpenRestaurantNameViewController ()
{
    OpenRestaurantNameTopView *_topView;
    
    OpenRestaurantBottomView *_bottomView;
    
    UIImageView *_thumalImgView;
}

- (void)initWithTopView;

- (void)initWithBottomView;

- (void)initWithThumalImgView;

@end

@implementation OpenRestaurantNameViewController

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
    
    self.title = @"开餐厅";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithTopView];
    
    [self initWithBottomView];
    
    [self initWithThumalImgView];
}

- (void)initWithTopView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
    _topView = [[OpenRestaurantNameTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    __weak typeof(self)weakSelf = self;
    _topView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedNext];
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [_bottomView updateViewData:@"下一步"];
        _bottomView.bottom = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT;
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedNext];
    };
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"kaicanting_bg_name"];
    
    CGFloat height = _bottomView.top - _topView.bottom;
    CGFloat imageHeight = (height > image.size.height?image.size.height:height);
    CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - image.size.width)/2, _topView.bottom + (height-imageHeight)/2, image.size.width, imageHeight);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    [self.view addSubview:_thumalImgView];
}

- (void)clickedNext
{
    NSString *name = [_topView restaurantName];
    if (!name || [name isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入餐厅名称"];
        return;
    }
    _inputEntity.restaurantName = name;
    
    // 开餐厅第二步骤 城市
    [MCYPushViewController showWithOpenRestaurantCityVC:self data:_inputEntity completion:nil];
}

- (void)showWithEditShopInfo:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success || respond.errcode == 2)
    {// 2表示已存在
        NSDictionary *dict = respond.data;
        _inputEntity.shopId = [dict[@"shop_id"] integerValue];
        UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
        userInfo.shop_id = _inputEntity.shopId;
        userInfo.userMode = 1;
        [UserLoginStateObject saveWithUserInfo:userInfo];

        [SVProgressHUD dismiss];
        // 进入餐厅编辑
        [MCYPushViewController showWithOpenRestaurantInfoVC:self inputData:_inputEntity data:nil completion:nil];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

@end
