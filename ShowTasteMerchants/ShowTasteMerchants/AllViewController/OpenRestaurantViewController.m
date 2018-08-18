//
//  OpenRestaurantViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantViewController.h"
#import "LocalCommon.h"
#import "CuisineTypeDataEntity.h"
#import "OpenRestaurantHeadView.h"
#import "OpenRestaurantBottomView.h"
#import "ORestaurantBigTypeView.h"
#import "OpenRestaurantInputEntity.h"

@interface OpenRestaurantViewController ()
{
    OpenRestaurantHeadView *_topView;
    
    UIScrollView *_contentView;
    
    /**
     *  传统菜系视图
     */
    ORestaurantBigTypeView *_traditionCuisineView;
    
    /**
     *  特色菜系视图
     */
    ORestaurantBigTypeView *_featureCuisinedView;
    
    /**
     *  国际菜系视图
     */
    ORestaurantBigTypeView *_interCusinedView;
    
    OpenRestaurantBottomView *_bottomView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithTopView;

- (void)initWithContentView;

/**
 *  传统菜系
 */
- (void)initWithTraditionCuisineView;

/**
 *  特色菜系
 */
- (void)initWithFeatureCuisinedView;

/**
 *  国际菜系
 */
- (void)initWithInterCusinedView;

- (void)initWithBottomView;

@end

@implementation OpenRestaurantViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
    
    [self initWithTopView];
    
    [self initWithContentView];
    
    // 传统菜系
    [self initWithTraditionCuisineView];
    
    // 特色菜系
    [self initWithFeatureCuisinedView];
    
    // 国际菜系
    [self initWithInterCusinedView];
    
    [self initWithBottomView];
    
    _contentView.contentSize = CGSizeMake([[UIScreen mainScreen] screenWidth], _interCusinedView.bottom);
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOpenRestaurantHeadViewHeight);
        _topView = [[OpenRestaurantHeadView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _topView.bottom + 10, _topView.width, [[UIScreen mainScreen] screenHeight] - _topView.bottom - [app navBarHeight] - STATUSBAR_HEIGHT - [app tabBarHeight] - 10);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        [self.view addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
    }
}

/**
 *  传统菜系
 */
- (void)initWithTraditionCuisineView
{
    if (!_traditionCuisineView)
    {
        CGFloat height = kORestaurantBigTypeViewHeight;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height);
        _traditionCuisineView = [[ORestaurantBigTypeView alloc] initWithFrame:frame];
        [_contentView addSubview:_traditionCuisineView];
    }
    CuisineTypeDataEntity *entity = _restaurantEntity.chuantong;
//    debugLog(@"ent=%@", [entity modelToJSONString]);
    NSInteger col = 3;
    NSInteger num = ceilf((float)[entity.content count]/col);
    // (20 + 15 + 10 + 15 + 30 + 15)
    CGFloat space = 15;
    if (kiPhone4 || kiPhone5)
    {
        space = 10;
    }
    CGFloat height = kORestaurantBigTypeViewHeight - 30 + num * 30 + space*(num);
    _traditionCuisineView.height = height;
    entity.imageName = @"caixi_icon_chuantong";
    [_traditionCuisineView updateViewData:entity];
}

/**
 *  特色菜系
 */
- (void)initWithFeatureCuisinedView
{
    if (!_featureCuisinedView)
    {
        CGFloat height = kORestaurantBigTypeViewHeight;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height);
        _featureCuisinedView = [[ORestaurantBigTypeView alloc] initWithFrame:frame];
        [_contentView addSubview:_featureCuisinedView];
    }
    CuisineTypeDataEntity *entity = _restaurantEntity.tese;
    NSInteger col = 3;
    NSInteger num = ceilf((float)[entity.content count]/col);
    // (20 + 15 + 10 + 15 + 30 + 15)
    CGFloat space = 15;
    if (kiPhone4 || kiPhone5)
    {
        space = 10;
    }
    CGFloat height = kORestaurantBigTypeViewHeight - 30 + num * 30 + space*(num);
    _featureCuisinedView.height = height;
    _featureCuisinedView.top = _traditionCuisineView.bottom;
    entity.imageName = @"caixi_icon_tese";
    [_featureCuisinedView updateViewData:entity];
}

/**
 *  国际菜系
 */
- (void)initWithInterCusinedView
{
    if (!_interCusinedView)
    {
        CGFloat height = kORestaurantBigTypeViewHeight;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height);
        _interCusinedView = [[ORestaurantBigTypeView alloc] initWithFrame:frame];
        [_contentView addSubview:_interCusinedView];
//        _interCusinedView.backgroundColor = [UIColor redColor];
    }
    CuisineTypeDataEntity *entity = _restaurantEntity.guoji;
    NSInteger col = 3;
    NSInteger num = ceilf((float)[entity.content count]/col);
    // (20 + 15 + 10 + 15 + 30 + 15)
    CGFloat space = 15;
    if (kiPhone4 || kiPhone5)
    {
        space = 10;
    }
    CGFloat height = kORestaurantBigTypeViewHeight - 30 + num * 30 + space*(num);
    _interCusinedView.height = height;
    _interCusinedView.top = +_featureCuisinedView.bottom;
    entity.imageName = @"caixi_icon_guoji";
    [_interCusinedView updateViewData:entity];
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _contentView.bottom, _contentView.width, [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:@"创建店铺"];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedNext];
    };
}

- (void)clickedNext
{
    _inputEntity.traditions = _traditionCuisineView.selectedList;
    _inputEntity.features = _featureCuisinedView.selectedList;
    _inputEntity.inters = _interCusinedView.selectedList;
    
    if ([_inputEntity.traditions count] == 0 && [_inputEntity.features count] == 0 && [_inputEntity.inters count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择餐厅类型！"];
        return;
    }
    // 菜系完成后，提交数据库，然后跳到，上传资质视图控制器
    NSMutableDictionary *contentDict = [NSMutableDictionary new];
    contentDict[@"seller_id"] = @([UserLoginStateObject getUserInfo].seller_id); // 商户id
     contentDict[@"user_id"] = @([UserLoginStateObject getUserId]);
     contentDict[@"city_id"] = @(_inputEntity.cityId);
     contentDict[@"city_name"] = _inputEntity.cityName;
     contentDict[@"shop_name"] = _inputEntity.restaurantName;
     NSMutableArray *array = [NSMutableArray new];
     for (CuisineContentDataEntity *ent  in _inputEntity.traditions)
     {
     NSDictionary *dict = @{@"id":@(ent.id), @"name":ent.name};
     [array addObject:dict];
     }
     for (CuisineContentDataEntity *ent  in _inputEntity.features)
     {
     NSDictionary *dict = @{@"id":@(ent.id), @"name":ent.name};
     [array addObject:dict];
     }
     for (CuisineContentDataEntity *ent  in _inputEntity.inters)
     {
     NSDictionary *dict = @{@"id":@(ent.id), @"name":ent.name};
     [array addObject:dict];
     }
     contentDict[@"classify"] = array;
     NSString *json = [contentDict modelToJSONString];
     debugLog(@"json=%@", json);
    
     [SVProgressHUD showWithStatus:@"创建餐厅中"];
     [HCSNetHttp requestWithShopCreate:json completion:^(TYZRespondDataEntity *result) {
         
         if (result.errcode == respond_success)
         {
             // {"shop_id":13}
             NSDictionary *dict = result.data;
             // 餐厅id
             NSInteger shopId = [dict[@"shop_id"] integerValue];
             NSInteger empShopId = [UserLoginStateObject getCurrentShopId];
             // 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
             NSInteger state = [UserLoginStateObject getWithCurrentState];
             if (empShopId == 0 && state == 0)
             {
                 [UserLoginStateObject saveWithCurrentShopId:shopId]; // 餐厅id
                 [UserLoginStateObject saveWithCurrentShopName:_inputEntity.restaurantName]; // 餐厅名名称
             }
             [SVProgressHUD showSuccessWithStatus:@"创建完成"];
             // 上传资质
             debugLog(@"createShopid=%d", (int)shopId);
             [MCYPushViewController showWithShopQualificationVC:self data:nil shopId:shopId completion:nil];
         }
         else
         {
             [UtilityObject svProgressHUDError:result viewContrller:self];
         }
     }];
}

@end



























