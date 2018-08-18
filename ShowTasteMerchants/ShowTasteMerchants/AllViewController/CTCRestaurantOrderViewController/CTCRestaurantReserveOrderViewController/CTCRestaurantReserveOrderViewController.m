/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantReserveOrderViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:53
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantReserveOrderViewController.h"
#import "LocalCommon.h"
#import "CTCEmptyOrderView.h"
#import "CTCRestaurantReserveOrderCell.h"


@interface CTCRestaurantReserveOrderViewController ()
{
    CTCEmptyOrderView *_emptyView;
}

- (void)getWithOrderData;

@end

@implementation CTCRestaurantReserveOrderViewController

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark override
- (void)initWithVar
{
    [super initWithVar];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [self.baseList addObject:array];
    
    array = [NSMutableArray new];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [array addObject:@"1"];
    [self.baseList addObject:array];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    // requestWithShopOrderWaitOrders
    
    if (_type == 1)
    {
        self.title = @"餐前订单";
    }
    else
    {
        self.title = @"预定订单";
    }
    
    UIImage *image = [UIImage imageNamed:@"btn_add_shop"];
    CGRect frame = CGRectMake(0, 0, image.size.width*1.5, image.size.height*1.5);
    UIButton *btnAdd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"btn_add_shop" imgNameSel:@"btn_add_shop" targetSel:@selector(clickedWithCreateOrder:)];
    btnAdd.frame = frame;
    UIBarButtonItem *itemCreate = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = itemCreate;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithEmptyView];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderData];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithOrderData];
}

#pragma mark -
#pragma mark private

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, 230, 230);
        _emptyView = [[CTCEmptyOrderView alloc] initWithFrame:frame];
        _emptyView.userInteractionEnabled = NO;
        _emptyView.center = CGPointMake(self.baseTableView.width / 2., self.baseTableView.height / 2. - 60);
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

- (void)clickedWithCreateOrder:(id)sender
{
    debugMethod();
}

- (void)getWithOrderData
{
    if (_type == 1)
    {// 餐前订单
        [HCSNetHttp requestWithShopOrderWaitOrders:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
            [self responseWithShopOrderWaitOrders:result];
        }];
    }
    else
    {
        [self endAllRefreshing];
    }
}

- (void)responseWithShopOrderWaitOrders:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [self.baseList removeAllObjects];
        [self.baseList addObjectsFromArray:respond.data];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.baseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.baseList[section];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCRestaurantReserveOrderCell *cell = [CTCRestaurantReserveOrderCell cellForTableView:tableView];
    id ent = self.baseList[indexPath.section][indexPath.row];
    [cell updateCellData:ent];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCTCRestaurantReserveOrderCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 20)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    UILabel *label = [TYZCreateCommonObject createWithLabel:headerView labelFrame:CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] - 40, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(11) labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = @"今天";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end












