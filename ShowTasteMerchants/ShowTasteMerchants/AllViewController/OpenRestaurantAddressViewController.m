//
//  OpenRestaurantAddressViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantAddressViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantAddressTopView.h"
#import "ChoiceLocationView.h"
#import "OpenRestaurantBottomView.h"

@interface OpenRestaurantAddressViewController ()
{
    OpenRestaurantAddressTopView *_topView;
    
    ChoiceLocationView *_locationView;
    
    OpenRestaurantBottomView *_bottomView;
}

- (void)initWithTopView;

- (void)initWithLocationView;

- (void)initWithBottomView;

@end

@implementation OpenRestaurantAddressViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_locationView mapViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_locationView mapViewWillDisappear];
    
    [super viewWillDisappear:animated];
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
    
    [self initWithLocationView];
    
    [self initWithBottomView];
}

- (void)initWithTopView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] / 3);
    _topView = [[OpenRestaurantAddressTopView alloc] initWithFrame:frame];
    [self.view addSubview:_topView];
    __weak typeof(self)weakSelf = self;
    _topView.viewCommonBlock = ^(id data)
    {
        [weakSelf searchAddress:data];
    };
}

- (void)initWithLocationView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _topView.height - [app navBarHeight] - STATUSBAR_HEIGHT - [app tabBarHeight]);
    _locationView = [[ChoiceLocationView alloc] initWithFrame:frame];
    [self.view addSubview:_locationView];
    __weak typeof(self)blockSelf = self;
    _locationView.ReverseGeoCodeResultBlock = ^(NSString *province, NSString *city, NSString *address, CLLocationCoordinate2D coordinate)
    {
        blockSelf.inputEntity.address = address;
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _locationView.bottom, _locationView.width, [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedNext];
    };
}

- (void)searchAddress:(NSString *)address
{
    debugLog(@"add=%@", address);
    [_locationView searchAddress:address cityName:nil];
//    [_choiceLocationView searchAddress:search cityName:_cityName];
}

- (void)clickedNext
{
//    debugLog(@"ent=%@", [_inputEntity modelToJSONString]);
    if (!_inputEntity.address || [_inputEntity.address isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"餐厅地址为空!"];
        return;
    }
    [MCYPushViewController showWithOpenRestaurantNameVC:self data:_inputEntity completion:nil];
}

@end
