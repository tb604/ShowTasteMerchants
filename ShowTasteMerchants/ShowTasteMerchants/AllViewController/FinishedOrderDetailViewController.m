//
//  FinishedOrderDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FinishedOrderDetailViewController.h"
#import "LocalCommon.h"
#import "ShopOrderDetailStateHeaderView.h"
#import "ShopOrderDetailBottomView.h"
#import "FinishedOrderBaseInfoCell.h"
#import "UserEvaluationServiceViewCell.h"
#import "FinishedOrderRecommentRemarkCell.h"
#import "FinishedOrderRecommentContentCell.h"
#import "ShopSupplementFoodCell.h"
#import "DinersOrderDetailFoodViewCell.h"
#import "FinishedOrderDetailSectionFoodHeaderView.h"
#import "DinersOrderDetailFoodTitleView.h"
#import "ShopOrderDetailFooterView.h"
#import "OrderFoodNumberEntity.h"

@interface FinishedOrderDetailViewController ()
{
    ShopOrderDetailStateHeaderView *_headerView;
    
    ShopOrderDetailFooterView *_sectionFooterView;
}


- (void)initWithSectionFooterView;

- (void)getWithOrderDetailData;

@end

@implementation FinishedOrderDetailViewController

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
    
    self.title = @"订单详情";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithSectionFooterView];
    
    [self hiddenFooterView:YES];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithOrderDetailData];
}

/**
 *  刷新视图
 */
- (void)reloadWithOrderDetail
{
    [self initWithHeaderView];
    
    [self.baseTableView reloadData];
}

- (void)initWithSectionFooterView
{
    if (!_sectionFooterView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopOrderDetailFooterViewHeight);
        _sectionFooterView = [[ShopOrderDetailFooterView alloc] initWithFrame:frame];
        
    }
}

- (void)getWithOrderDetailData
{
    [HCSNetHttp requestWithShopOrderDetail:_orderDetailEntity.order_id shopId:_orderDetailEntity.shop_id completion:^(id result) {
        [self requestWithShopOrderDetail:result];
    }];
    
    
//    [HCSNetHttp requestWithOrderShowWholeOrderTwo:_orderDetailEntity.order.order_id shopId:_orderDetailEntity.order.shop_id completion:^(id result) {
//        [self responseWithOrderShowWholeOrderTwo:result];
//    }];
}

- (void)requestWithShopOrderDetail:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        CTCOrderDetailEntity *orderDetailEnt = respond.data;
        
        NSInteger num = 0;
        NSMutableDictionary *categoryDict = [NSMutableDictionary new];
        for (OrderFoodInfoEntity *foodEnt in orderDetailEnt.details)
        {
            OrderFoodNumberEntity *foodNumEnt = [OrderFoodNumberEntity new];
            foodNumEnt.categoryId = foodEnt.category_id;
            foodNumEnt.categoryName = foodEnt.category_name;
            foodNumEnt.number = foodEnt.number;
            foodNumEnt.unit = foodEnt.unit;
            if ([[categoryDict allKeys] containsObject:@(foodNumEnt.categoryId)])
            {
                OrderFoodNumberEntity *foodNumberEnt = categoryDict[@(foodNumEnt.categoryId)];
                foodNumberEnt.number += foodNumEnt.number;
            }
            else
            {
                categoryDict[@(foodNumEnt.categoryId)] = foodNumEnt;
            }
            
            // 所有菜品总的数量
            num += foodEnt.number;
        }
        /*NSMutableString *mutStr = [NSMutableString new];
        for (OrderFoodNumberEntity *ent in [categoryDict allValues])
        {
            if ([mutStr length] == 0)
            {
                [mutStr appendFormat:@"%@%d%@", ent.categoryName, (int)ent.number, ent.unit];
            }
            else
            {
                [mutStr appendFormat:@" / %@%d%@", ent.categoryName, (int)ent.number, ent.unit];
            }
        }*/
//        orderDetailEnt.foodTotalDesc = mutStr;
//        orderDetailEnt.foodTotalDescHeight = [UtilityObject mulFontHeights:mutStr font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        orderDetailEnt.totalCount = num;
        
        
        
        orderDetailEnt.comment.contentHeight = [UtilityObject mulFontHeights:orderDetailEnt.comment.content font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        orderDetailEnt.comment.imgWidth = ([[UIScreen mainScreen] screenWidth] - 30 - 8 * 2) / 3.0;
        
        NSInteger row = 0;
        CGFloat maxWidth = [[UIScreen mainScreen] screenWidth] - 30;
        CGFloat singleHeight = 25;
        CGFloat midSpace = 20; // 列中间的space
        CGFloat rowSpace = 10; // 行之间的space
        CGFloat fontWidth = 0;
        CGFloat allWidth = 0;
        //            debugLog(@"count=%d", [orderDetailEnt.order.comment.classify count]);
        for (NSInteger i=0; i<[orderDetailEnt.comment.classify count]; i++)
        {
            CommentClassifyEntity *classEnt = orderDetailEnt.comment.classify[i];
            if (i == 0)
            {
                classEnt.color = [UIColor colorWithHexString:@"#cce198"];
            }
            else if (i == 1)
            {
                classEnt.color = [UIColor colorWithHexString:@"#facd89"];
            }
            else if (i == 2)
            {
                classEnt.color = [UIColor colorWithHexString:@"#f19ec2"];
            }
            fontWidth = [classEnt.classify_name widthForFont:FONTSIZE_15] + 30;
            classEnt.classifyNameWidth = fontWidth;
            //                debugLog(@"fontWidth=%.2f", fontWidth);
            if (allWidth == 0)
            {
                allWidth += fontWidth;
            }
            else
            {
                allWidth += (fontWidth + midSpace);
            }
            //                debugLog(@"allWidth=%.2f", allWidth);
            if (allWidth > maxWidth)
            {
                row += 1;
                allWidth = fontWidth;
            }
        }
        if (row == 0)
        {
            row = 1;
        }
        orderDetailEnt.comment.classifyRow = row;
        orderDetailEnt.comment.classifyHeight = row * singleHeight + (row - 1) * rowSpace;
        self.orderDetailEntity = orderDetailEnt;
        
        [self reloadWithOrderDetail];
        [self.baseTableView reloadData];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    
    [self endAllRefreshing];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_orderDetailEntity.comment_status == 0)
    {// 未评论
        return EN_FINISH_ORDER_MAX_SECTION - EN_FINISH_ORDER_RECOMMENTMSG_SECTION + 1;
    }
    else
    {// 已评论
        return EN_FINISH_ORDER_MAX_SECTION;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EN_FINISH_ORDER_BASEINFO_SECTION)
    {// 基本信息
        return 1;
    }
    else if (section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜单
        return [_orderDetailEntity.detailFoods count];
    }
    else if (section == EN_FINISH_ORDER_STAR_SECTION)
    {// 总体、口味、服务、环境
        return 2;
    }
    else if (section == EN_FINISH_ORDER_RECOMMENTMSG_SECTION)
    {// 评论内容
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EN_FINISH_ORDER_BASEINFO_SECTION)
    {// 基本信息
        FinishedOrderBaseInfoCell *cell = [FinishedOrderBaseInfoCell cellForTableView:tableView];
        [cell updateCellData:_orderDetailEntity];
        return cell;
    }
    else if (indexPath.section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜单
        OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];
        if (foodEnt.isSub)
        {// 子cell
            ShopSupplementFoodCell *cell = [ShopSupplementFoodCell cellForTableView:tableView];
            [cell updateCellData:foodEnt];
            return cell;
        }
        else
        {
            DinersOrderDetailFoodViewCell *cell = [DinersOrderDetailFoodViewCell cellForTableView:tableView];
            [cell updateCellData:foodEnt];
            
            return cell;
        }
    }
    else if (indexPath.section == EN_FINISH_ORDER_STAR_SECTION)
    {// 总体、口味、服务、环境
        if (indexPath.row == 0)
        {
            UserEvaluationServiceViewCell *cell = [UserEvaluationServiceViewCell cellForTableView:tableView];
            [cell updateCellData:_orderDetailEntity.comment];
            return cell;
        }
        else
        {// 标签
            FinishedOrderRecommentRemarkCell *cell = [FinishedOrderRecommentRemarkCell cellForTableView:tableView];
            [cell updateCellData:_orderDetailEntity.comment];
            return cell;
        }
    }
//    else if (indexPath.section == EN_FINISH_ORDER_REMARK_SECTION)
//    {// 标签
//        
//    }
    else if (indexPath.section == EN_FINISH_ORDER_RECOMMENTMSG_SECTION)
    {// 评论内容
        FinishedOrderRecommentContentCell *cell = [FinishedOrderRecommentContentCell cellForTableView:tableView];
        [cell updateCellData:_orderDetailEntity.comment];
        return cell;
    }
    
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80.0;
    if (indexPath.section == EN_FINISH_ORDER_BASEINFO_SECTION)
    {// 基本信息
        height = kFinishedOrderBaseInfoCellHeight;
    }
    else if (indexPath.section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜单
        OrderFoodInfoEntity *foodEnt = _orderDetailEntity.detailFoods[indexPath.row];
        if (foodEnt.isSub)
        {
            height = kShopSupplementFoodCellHeight;
        }
        else
        {
            height = [DinersOrderDetailFoodViewCell getWithCellHeight:foodEnt];
        }
    }
    else if (indexPath.section == EN_FINISH_ORDER_STAR_SECTION)
    {// 总体、口味、服务、环境
        if (indexPath.row == 0)
        {
            height = kUserEvaluationServiceViewCellHeight;
        }
        else
        {
            height = 10 + 20 + 10 + 30 + 10;
            height = height - 30 + _orderDetailEntity.comment.classifyHeight;
        }
    }
//    else if (indexPath.section == EN_FINISH_ORDER_REMARK_SECTION)
//    {// 标签
//        
//    }
    else if (indexPath.section == EN_FINISH_ORDER_RECOMMENTMSG_SECTION)
    {// 评论内容
        height = kFinishedOrderRecommentContentCellHeight - 20 + _orderDetailEntity.comment.contentHeight;
        if ([_orderDetailEntity.comment.images count] > 0)
        {
            height = height + _orderDetailEntity.comment.imgWidth + 5;
        }
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_FINISH_ORDER_BASEINFO_SECTION)
    {// 基本信息
        return 0.001;
    }
    else if (section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜单
        return kFinishedOrderDetailSectionFoodHeaderViewHeight;
    }
    else if (section == EN_FINISH_ORDER_STAR_SECTION)
    {// 总体、口味、服务、环境
        return 30;
    }
    else if (section == EN_FINISH_ORDER_RECOMMENTMSG_SECTION)
    {// 评论内容
        return 30;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == EN_FINISH_ORDER_STAR_SECTION || section == EN_FINISH_ORDER_RECOMMENTMSG_SECTION)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 30) textColor:[UIColor colorWithHexString:@"646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        if (section == EN_FINISH_ORDER_STAR_SECTION)
        {
            label.text = @"我的餐厅印象";
        }
        else
        {
            label.text = @"我的评论";
        }
        return view;
    }
    else if (section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜品头
        FinishedOrderDetailSectionFoodHeaderView *view = [[FinishedOrderDetailSectionFoodHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kFinishedOrderDetailSectionFoodHeaderViewHeight)];
        [view updateViewData:_orderDetailEntity];
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == EN_FINISH_ORDER_BASEINFO_SECTION)
    {
        return 10.;
    }
    else if (section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜品
        return kShopOrderDetailFooterViewHeight;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 菜品
        [_sectionFooterView updateViewData:_orderDetailEntity];
        return _sectionFooterView;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderFoodInfoEntity *foodInfoEntity = nil;
    if (indexPath.section == EN_FINISH_ORDER_FOOD_SECTION)
    {// 下单的菜品列表
        foodInfoEntity = _orderDetailEntity.detailFoods[indexPath.row];
        
        if ([foodInfoEntity.subFoods count] > 1)
        {
            foodInfoEntity.isCheck = !foodInfoEntity.isCheck;
            
            DinersOrderDetailFoodViewCell *cell = (DinersOrderDetailFoodViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [cell updateCellData:foodInfoEntity];
            
            NSMutableArray *foodList = [NSMutableArray new];
            if (foodInfoEntity.isCheck)
            {
                [_orderDetailEntity.detailFoods insertObjects:foodInfoEntity.subFoods atIndex:indexPath.row+1];
                for (NSInteger i=1; i<=foodInfoEntity.subFoods.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView insertRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [_orderDetailEntity.detailFoods removeObjectsInArray:foodInfoEntity.subFoods];
                for (NSInteger i=1; i<=foodInfoEntity.subFoods.count; i++)
                {
                    [foodList addObject:[NSIndexPath indexPathForRow:i+indexPath.row inSection:indexPath.section]];
                }
                [tableView deleteRowsAtIndexPaths:foodList withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
        
    }
}

@end
