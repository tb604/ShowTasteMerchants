//
//  RestaurantMallEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMallEditViewController.h"
#import "LocalCommon.h"
#import "MallDataEntity.h"
#import "MallEditTableViewCell.h"
#import "MallSelectInfoView.h" // 选中的视图
#import "OpenRestaurantBottomView.h"
#import "UserLoginStateObject.h"

@interface RestaurantMallEditViewController ()
{
    MallSelectInfoView *_selectInfoView;
    
    OpenRestaurantBottomView *_bottomView;
    
    BOOL _isShow;
    
}
@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) MallDataEntity *areaMallEntity;

@property (nonatomic, strong) MallListDataEntity *mallEntity;



- (void)getMallInfoList;

- (void)initWithSelectInfoView;

- (void)initWithBottomView;

@end

@implementation RestaurantMallEditViewController

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
    
    _isShow = NO;
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"选择商圈";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = self.baseTableView.frame;
    frame.size.height = frame.size.height - [app tabBarHeight];
    self.baseTableView.frame = frame;
    [self hiddenFooterView:YES];
    
    [self initWithSelectInfoView];
    
    [self initWithBottomView];
    
    
    // 隐藏景点列表手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [self doRefreshData];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getMallInfoList];
}

- (void)initWithSelectInfoView
{
    CGRect frame = self.baseTableView.frame;
    frame.origin.x = [[UIScreen mainScreen] screenWidth];
    _selectInfoView = [[MallSelectInfoView alloc] initWithFrame:frame];
    //    _sceneListView.backgroundColor = [UIColor orangeColor];
//    _sceneListView.delegate = self;
    
    _selectInfoView.layer.shadowColor = [UIColor blackColor].CGColor;
    _selectInfoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _selectInfoView.layer.shadowOpacity = 0.5;
    _selectInfoView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_selectInfoView.bounds].CGPath;
    _selectInfoView.layer.shadowRadius = 2;
    _selectInfoView.layer.masksToBounds = NO;
    
    [self.view addSubview:_selectInfoView];
    __weak typeof(self)weakSelf = self;
    _selectInfoView.viewCommonBlock = ^(id data)
    {
        weakSelf.mallEntity = data;
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:@"确认"];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf submitMall];
    };
}

- (void)getMallInfoList
{
    [HCSNetHttp requestWithMallCityId:_cityId completion:^(id result) {
        [self getMallInfoList:result];
    }];
}
- (void)getMallInfoList:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  景点列表视图显示或者隐藏
 *
 *  @param isShow <#isShow description#>
 */
- (void)mallTableViewAnimateShow:(BOOL)isShow data:(id)data
{
    CGRect frame = _selectInfoView.frame;
    if (isShow)
    {
        [_selectInfoView updateViewData:data];
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 3.0;
    }
    else
    {
        frame.origin.x = [[UIScreen mainScreen] screenWidth];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _selectInfoView.frame = frame;
//        _tableViewShadow.frame = frame;
    }];
}

/**
 *  处理隐藏景点列表手势
 *
 *  @param gesture <#gesture description#>
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateRecognized)
    {
        return;
    }
    
    // 隐藏景点列表视图
    _isShow = NO;
    [self mallTableViewAnimateShow:_isShow data:nil];
}

/**
 *  提交
 */
- (void)submitMall
{
    if (!_areaMallEntity || !_mallEntity)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择商圈！"];
        return;
    }
//    [HCSNetHttp requestWithShopSetShopMall:<#(NSInteger)#> areaId:<#(NSInteger)#> mallId:<#(NSInteger)#> completion:<#^(id result)completion#>]
    
    [SVProgressHUD showWithStatus:@"提交中"];
    [HCSNetHttp requestWithShopsetMall:[UserLoginStateObject getCurrentShopId] areaId:_areaMallEntity.id mallId:_mallEntity.id completion:^(id result) {
        [self responseWithShopsetMall:result];
    }];
}

- (void)responseWithShopsetMall:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        [self clickedBack:nil];
        
        if (self.popResultBlock)
        {
            self.popResultBlock(_mallEntity);
        }
    }
    else
    {
        [UtilityObject svProgressHUDError: respond viewContrller:self];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallEditTableViewCell *cell = [MallEditTableViewCell cellForTableView:tableView];
    UIColor *color = nil;
//    if (!_selectIndexPath && indexPath.row == 0)
//    {
//        color = [UIColor colorWithHexString:@"#ffffff"];
//        self.selectIndexPath = indexPath;
//    }
//    else
//    {
        color = [UIColor colorWithHexString:@"#f5f5f5"];
//    }
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;

//    debugLog(@"selc=%d", cell.selected);
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMallEditTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MallDataEntity *mallEntity = self.baseList[indexPath.row];
    self.areaMallEntity = mallEntity;
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
//        debugLog(@"if");
        MallEditTableViewCell *newCell = (MallEditTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];

        MallEditTableViewCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (MallEditTableViewCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        oldCell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        oldCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.selectIndexPath = indexPath;
        
        _isShow = YES;
        [self mallTableViewAnimateShow:_isShow data:mallEntity.malls];
        
    }
    else
    {
//        debugLog(@"else");
        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        if (!_isShow)
        {
            _isShow = YES;
            [self mallTableViewAnimateShow:_isShow data:mallEntity.malls];
        }
    }

    
    debugLog(@"mallEnt=%@", [mallEntity modelToJSONString]);
    
}


@end


























