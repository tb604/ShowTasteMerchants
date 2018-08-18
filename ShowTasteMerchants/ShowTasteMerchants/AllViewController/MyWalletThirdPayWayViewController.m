//
//  MyWalletThirdPayWayViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletThirdPayWayViewController.h"
#import "LocalCommon.h"
#import "MyWalletThirdPayWayViewCell.h"
#import "CellCommonDataEntity.h"

@interface MyWalletThirdPayWayViewController ()

@end

@implementation MyWalletThirdPayWayViewController

- (void)initWithVar
{
    [super initWithVar];
    
    
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"支付宝";
    ent.subTitle = @"1212@qq.com";
    ent.thumalImgName = @"hall-order_pay_icon_zhifubao";
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"微信";
    ent.subTitle = @"1214342@qq.com";
    ent.thumalImgName = @"hall-order_pay_icon_weixin";
    [self.baseList addObject:ent];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"第三方";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
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
    MyWalletThirdPayWayViewCell *cell = [MyWalletThirdPayWayViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyWalletThirdPayWayViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellCommonDataEntity *ent = self.baseList[indexPath.row];
    NSDictionary *param = @{@"title":ent.title, @"data":objectNull(ent.subTitle), @"placeholder":[NSString stringWithFormat:@"请输入%@账号", ent.title], @"isNumber":@(NO)};
    [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
        ent.subTitle = data;
        [self.baseTableView reloadData];
    }];

}

@end

















