//
//  MyRestaurantEditShopViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantEditShopViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantEditShopCell.h"
#import "ShopListDataEntity.h"

@interface MyRestaurantEditShopViewController ()

@end

@implementation MyRestaurantEditShopViewController

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
    
    [self.baseList addObjectsFromArray:_allShops];
    
    for (ShopListDataEntity *selShop in _selectShopList)
    {
        for (ShopListDataEntity *shopEnt in self.baseList)
        {
            if (selShop.shop_id == shopEnt.shop_id)
            {
                shopEnt.selCheck = YES;
                break;
            }
        }
    }
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"管理分配";
    
    
    NSString *str = @"确认";
    float width = [str widthForFont:FONTSIZE_16];
    UIButton *btnSave = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithSubmit:)];
    btnSave.frame = CGRectMake(0, 0, width, 30);
    
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = itemSave;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)clickedWithSubmit:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_selectShopList);
    }
    [self clickedBack:nil];
}


- (void)editWithShop:(ShopListDataEntity *)shopEnt
{
    debugMethod();
    if (shopEnt.selCheck)
    {// 选中
//        debugLog(@"选中");
        BOOL isExist = NO;
        for (ShopListDataEntity *selEnt in _selectShopList)
        {
            if (selEnt.shop_id == shopEnt.shop_id)
            {
                isExist = YES;
                break;
            }
        }
        if (!isExist)
        {
            [_selectShopList addObject:shopEnt];
        }
    }
    else
    {// 不选中
//        debugLog(@"不选中");
        ShopListDataEntity *delEnt = nil;
        for (ShopListDataEntity *selEnt in _selectShopList)
        {
            if (selEnt.shop_id == shopEnt.shop_id)
            {
                delEnt = selEnt;
                break;
            }
        }
        if (delEnt)
        {
            [_selectShopList removeObject:delEnt];
        }
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
    MyRestaurantEditShopCell *cell = [MyRestaurantEditShopCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyRestaurantEditShopCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopListDataEntity *shopEnt = self.baseList[indexPath.row];
    
    shopEnt.selCheck = !shopEnt.selCheck;
    [self editWithShop:shopEnt];
    [tableView reloadData];
}

@end

















