//
//  CurrentPositionMapViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CurrentPositionMapViewController.h"
#import "LocalCommon.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import "BasicBMKMapAnnotation.h"
#import "HCSLocationManager.h"

#define kLocalLabelTag (1024)

@interface CurrentPositionMapViewController () <BMKMapViewDelegate, BMKGeoCodeSearchDelegate>

/**
 *  百度地图视图
 */
@property (nonatomic, strong) BMKMapView *bmkMapView;

/**
 *  geo搜索服务
 */
@property (nonatomic, strong) BMKGeoCodeSearch *bmkGeoCodeSearch;

/**
 *  初始化百度地图视图
 */
- (void)initWithBmkMapView;

- (void)initWithBmkGeoCodeSearch;


@end

@implementation CurrentPositionMapViewController

- (void)dealloc
{
    _bmkMapView.delegate = nil;
    if (_bmkMapView)
    {
        _bmkMapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_bmkMapView viewWillAppear];
    _bmkMapView.delegate = self;
    _bmkGeoCodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_bmkMapView viewWillDisappear];
    _bmkMapView.delegate = nil;
    _bmkGeoCodeSearch.delegate = nil;
    
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
    
    self.title = @"位置";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    [[HCSLocationManager shareInstance] startLocation];
    
    [self initWithBmkMapView];
    
    [self initWithBmkGeoCodeSearch];

}

/**
 *  初始化百度地图视图
 */
- (void)initWithBmkMapView
{
//    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]);
//    _bmkMapView = [[BMKMapView alloc] initWithFrame:frame];
//    _bmkMapView.mapType = BMKMapTypeStandard;
//    _bmkMapView.zoomLevel = 14;
//    [self.view addSubview:_bmkMapView];
    _bmkMapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _bmkMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _bmkMapView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_bmkMapView];
    _bmkMapView.delegate = self;
    // 设定是否显示定位图层
    _bmkMapView.showsUserLocation = NO;
    // 设置定位的状态
    _bmkMapView.userTrackingMode = BMKUserTrackingModeNone;
    _bmkMapView.zoomLevel = 14;
    // 设定是否显示定位图层
    _bmkMapView.showsUserLocation = YES;
    // 当前地图类型，可设定为标准地图、卫星地图
    _bmkMapView.mapType = BMKMapTypeStandard;
}

- (void)initWithBmkGeoCodeSearch
{
    _bmkGeoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _bmkGeoCodeSearch.delegate = self;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    //     geocodeSearchOption.city = self.currentCityName;
//    debugLog(@"add=%@", _address);
    geocodeSearchOption.address = self.address;
    if (![_bmkGeoCodeSearch geoCode:geocodeSearchOption])
    {
        debugLog(@"geo检索发送失败");
    }
//    [geocodeSearchOption release], geocodeSearchOption = nil;
}

#pragma mark start BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    debugLog(@"地图初始化完成");
}

// 根据anntation生成对应的View
// 一旦BMKMapView的addAnnotation方法被调用，就会除非地图的这个委托方法
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"PIN_ANNOTATION";
    BMKAnnotationView *newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (!newAnnotationView)
    {
        newAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        //        newAnnotationView.backgroundColor = [UIColor orangeColor];
        // 设置不可以拖拽
        newAnnotationView.draggable = NO;
        newAnnotationView.frame = CGRectMake(0, 0, 54, 54);
        newAnnotationView.backgroundColor = [UIColor clearColor];
        newAnnotationView.paopaoView = nil;
        newAnnotationView.exclusiveTouch = YES;
        newAnnotationView.autoresizesSubviews = YES;
        newAnnotationView.centerOffset = CGPointMake(0, -27);
        newAnnotationView.userInteractionEnabled = NO;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
        //        label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        label.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        label.layer.borderWidth = 1;
        label.layer.cornerRadius = 4;
        label.layer.borderColor = RGBACOLOR(190.f, 190.0f, 190.0f, 1).CGColor;
        label.font  = [UIFont systemFontOfSize:14];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        label.tag = kLocalLabelTag;
        label.textAlignment = NSTextAlignmentCenter;
        [newAnnotationView addSubview:label];
        
        UIImageView *papo = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.frame.size.height + 2, 30, 30)];
        papo.image = [UIImage imageNamed:@"locationmap_icon"];
        papo.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        [newAnnotationView addSubview:papo];
#if !__has_feature(objc_arc)
        [label release], label = nil;
        [papo release], papo = nil;
#endif
    }
    
    [newAnnotationView setAnnotation:annotation];
    
    UILabel *label = (UILabel *)[newAnnotationView viewWithTag:kLocalLabelTag];
    label.text = annotation.title;
    //    debugLog(@"title=%@", annotation.title);
    CGFloat width = [annotation.title widthForFont:FONTSIZE_14 height:22];//[annotation.title widthwithfont:[UIFont systemFontOfSize:14] height:22];
    width = width * 1.5;
    newAnnotationView.frame = CGRectMake(0, 0, width + 10, newAnnotationView.frame.size.height);
    
    return newAnnotationView;
}

#pragma mark end BMKMapViewDelegate

#pragma mark start BMKGeoCodeSearchDelegate
/**
 *返回地址信息搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKGeoCodeSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    debugMethod();
    if (error == 0)
    {
        debugLog(@"error==0");
        NSArray *array = _bmkMapView.annotations;
        [_bmkMapView removeAnnotations:array];
        
        // 调整地图位置和缩放比例(根据中心点经纬度坐标和跨度，创建这个对象)
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMakeWithDistance(result.location, 100, 100);
        // 设置重新调整地图显示区域
        [_bmkMapView setRegion:viewRegion animated:YES];
        
        // 添加一个pointAnnotation
        BasicBMKMapAnnotation *annotation = [[BasicBMKMapAnnotation alloc] init];
        debugLog(@"location.lon=%f; lat=%f", result.location.longitude, result.location.latitude);
        debugLog(@"address=%@", result.address);
        annotation.coordinate = result.location;
        annotation.title = result.address;
        [_bmkMapView addAnnotation:annotation];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
}
#pragma mark end BMKGeoCodeSearchDelegate



@end































