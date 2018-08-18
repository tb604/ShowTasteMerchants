//
//  RestaurantAddressEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantAddressEditViewController.h"
#import "LocalCommon.h"
#import "ChoiceLocationView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import "ChoiceLocationCell.h"

// BMKPoiInfo

@interface RestaurantAddressEditViewController ()  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    ChoiceLocationView *_choiceLocationView;
    UITableView *_poiTableView;
    NSMutableArray *_poiArray;
    
    UIView *_searchBgView;
    
    UITextField *_txtFieldSearch;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

- (void)initWithChoiceLocationView;

- (void)initWithPoiTableView;

- (void)initWithSearchBgView;

- (void)clickedSubmit:(id)sender;

@end

@implementation RestaurantAddressEditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_choiceLocationView mapViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_choiceLocationView mapViewWillDisappear];
    
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
    
    _poiArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"地址";
    
    // 提交按钮
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSubmit.frame = CGRectMake(0.0f, 0.0f, 46, 30);
    [btnSubmit setTitle:@"完成" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSubmit.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnSubmit addTarget:self action:@selector(clickedSubmit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submitItem = [[UIBarButtonItem alloc] initWithCustomView:btnSubmit];
    self.navigationItem.rightBarButtonItem = submitItem;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    if (_isSearch)
//    {
        [self initWithSearchBgView];
//    }
    
    [self initWithChoiceLocationView];
    
    [self initWithPoiTableView];
    
}

- (void)initWithSearchBgView
{
    _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenHeight], 44)];
    _searchBgView.backgroundColor = [UIColor colorWithHexString:@"#f2f5f7"];
    [self.view addSubview:_searchBgView];
    
    
    /*UIImage *image = [UIImage imageNamed:@"main_search_bg"];
    image = [UIImage resizeableImage:image capInsets:UIEdgeInsetsMake(10, 30, 10, 30) leftCapWidth:30 topCapHeight:30];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgView.image = image;
    imgView.userInteractionEnabled = YES;
    [_searchBgView addSubview:imgView];
    PREPCONSTRAINTS(imgView);
    float space = 5.0f;
    NSDictionary *metrics = @{@"space":@(space)};
    [_searchBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[imgView]-space-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(imgView)]];
    
    [_searchBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[imgView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imgView)]];
    
    UIImage *icon = [UIImage imageNamed:@"search_icon"];
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:icon];
    [imgView addSubview:searchIcon];
    PREPCONSTRAINTS(searchIcon);
    [imgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[searchIcon]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(searchIcon)]];
    [imgView addConstraint:CONSTRAINT_CENTERING_V(searchIcon)];
    */
    _txtFieldSearch = [[UITextField alloc] initWithFrame:CGRectMake(15, (44-30)/2, [[UIScreen mainScreen] screenWidth] - 30, 30)];
    _txtFieldSearch.backgroundColor = [UIColor clearColor];
    _txtFieldSearch.font = [UIFont systemFontOfSize:15];
    _txtFieldSearch.borderStyle = UITextBorderStyleNone;
    _txtFieldSearch.placeholder = NSLocalizedString(@"输入地址", @"");
    _txtFieldSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtFieldSearch.returnKeyType = UIReturnKeySearch;
    _txtFieldSearch.keyboardType = UIKeyboardTypeDefault;
    _txtFieldSearch.delegate = self;
    [_searchBgView addSubview:_txtFieldSearch];
//    PREPCONSTRAINTS(_txtFieldSearch);
//    metrics = @{@"space": @(icon.size.width + 10 + 12)};
//    [_searchBgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[_txtFieldSearch]-10-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_txtFieldSearch)]];
//    [_searchBgView addConstraint:CONSTRAINT_CENTERING_V(_txtFieldSearch)];
//    addConstraintHeight(_txtFieldSearch, 30);
    
//    [imgView release], imgView = nil;
//    [searchIcon release], searchIcon = nil;
}

- (void)initWithChoiceLocationView
{
    CGRect frame = CGRectZero;
//    if (_isSearch)
//    {
        frame = CGRectMake(0.0f, 44.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenWidth] - 60 - 44);
//    }
//    else
//    {
//        frame = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenWidth] - 60);
//    }
    _choiceLocationView = [[ChoiceLocationView alloc] initWithFrame:frame];
    [self.view addSubview:_choiceLocationView];
    [_choiceLocationView searchAddress:_cityName cityName:_cityName];
    __block typeof(self)blockSelf = self;
    _choiceLocationView.GetReverseGeoCodeResult = ^(NSArray *poiList, CLLocationCoordinate2D coordinate)
    {// 得到数据
        [blockSelf reloadTableView:poiList coordinate:coordinate];
    };
}

- (void)reloadTableView:(NSArray *)poiList coordinate:(CLLocationCoordinate2D)coordinate
{
    [_poiArray removeAllObjects];
    [_poiArray addObjectsFromArray:poiList];
    [_poiTableView reloadData];
    self.coordinate = coordinate;
}

- (void)initWithPoiTableView
{
    _poiTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _poiTableView.backgroundView = nil;
    _poiTableView.backgroundColor = [UIColor clearColor];
    _poiTableView.delegate = self;
    _poiTableView.dataSource = self;
    _poiTableView.rowHeight = 60.0f;
    [self.view addSubview:_poiTableView];
    PREPCONSTRAINTS(_poiTableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_choiceLocationView][_poiTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_choiceLocationView, _poiTableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_poiTableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_poiTableView)]];
    
}

- (void)clickedSubmit:(id)sender
{
    if (_poiArray.count <= 0)
    {
        return;
    }
    BMKPoiInfo *info = _poiArray[_selectIndexPath.row];
    if (_ChoiceLocationInfoBlock)
    {
        _ChoiceLocationInfoBlock(info.name, info.address, _coordinate);
    }
    [self clickedBack:nil];
}

#pragma mark start UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchSubmit];
    return YES;
}
#pragma mark end UITextFieldDelegate

- (void)searchSubmit
{
    NSString *search = _txtFieldSearch.text;
    if (!search || [search isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    [_choiceLocationView searchAddress:search cityName:_cityName];
    [_txtFieldSearch resignFirstResponder];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoiceLocationCell *cell = [ChoiceLocationCell cellForTableView:tableView tableViewCellStyle:UITableViewCellStyleSubtitle];
    if (!_selectIndexPath && indexPath.row == 0)
    {
        self.selectIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell updateCellData:_poiArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
        ChoiceLocationCell *newCell = (ChoiceLocationCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        ChoiceLocationCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (ChoiceLocationCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.selectIndexPath = indexPath;
    }
    else
    {
        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}


@end



























