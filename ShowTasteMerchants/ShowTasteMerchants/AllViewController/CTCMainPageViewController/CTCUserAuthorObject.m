/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserAuthorObject.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/31 16:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCUserAuthorObject.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@implementation CTCUserAuthorObject

// 得到功能
- (void)addWithfunModel:(NSString *)title imgName:(NSString *)imgName addList:(NSMutableArray *)addList;
{
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = title;
    ent.thumalImgName = imgName;
    [addList addObject:ent];
//    return ent;
}


/*
 EN_USER_HIGHEST_AUTHOR = 0, ///< 管理员权限(开通所有的)
 EN_USER_CASHIER_AUTHOR = 1, ///< 收银
 EN_USER_ALLORDER_AUTHOR = 100, ///< 订单的所有权限
 EN_USER_TAKEORDER_AUTHOR = 101, ///< 点菜下单
 EN_USER_MEALINGORDER_AUTHOR, ///< 餐中订单
 EN_USER_HISTORYORDER_AUTHOR, ///< 历史订单
 EN_USER_RESERVATEORDER_AUTHOR, ///< 预定订单
 EN_USER_ALLSHOP_AUTHOR = 200, ///< 餐厅所有权限
 EN_USER_SHOPINFO_AUTHOR = 201, ///< 餐厅资料
 EN_USER_SHOPMENU_AUTHOR, ///< 菜单菜品
 EN_USER_SHOPSEAT_AUTHOR, ///< 餐位设置
 EN_USER_SHOPMOUTH_AUTHOR, ///< 档口设置
 EN_USER_MEPMANAGER_AUTHOR, ///< 员工管理
 EN_USER_FINANCIAL_AUTHOR = 300, ///< 财务所有权限
 //    EN_USER_EARNING_AUTHOR = 301, ///< 收益
 EN_USER_REPORT_AUTHOR = 302, ///< 报表
 */

// 添加订单功能，根据不同权限
- (void)addOrderOp:(NSArray *)array authorlist:(NSMutableArray *)authorlist
{
    // 订单
    NSMutableArray *addList = [NSMutableArray new];
//    debugLog(@"array=%@", array);
    self.isOrderOps = NO;
    if ([array containsObject:@(EN_USER_HIGHEST_AUTHOR)] || [array containsObject:@(EN_USER_ALLORDER_AUTHOR)])
    {// 0, 100
        [self addWithfunModel:@"点菜下单" imgName:@"home_oreder_icon_ordering" addList:addList];
        [self addWithfunModel:@"餐中订单" imgName:@"home_oreder_icon_canzhong" addList:addList];
        [self addWithfunModel:@"预定订单" imgName:@"home_oreder_icon_book" addList:addList];
        [self addWithfunModel:@"历史订单" imgName:@"home_oreder_icon_history" addList:addList];
        [self addWithfunModel:@"外卖订单" imgName:@"home_takeout_icon" addList:addList];
        self.isOrderOps = YES;
    }
    else
    {
        if ([array containsObject:@(EN_USER_TAKEORDER_AUTHOR)])
        {
            [self addWithfunModel:@"点菜下单" imgName:@"home_oreder_icon_ordering" addList:addList];
            self.isOrderOps = YES;
        }
        if ([array containsObject:@(EN_USER_MEALINGORDER_AUTHOR)])
        {
            [self addWithfunModel:@"餐中订单" imgName:@"home_oreder_icon_canzhong" addList:addList];
            self.isOrderOps = YES;
        }
        if ([array containsObject:@(EN_USER_HISTORYORDER_AUTHOR)])
        {
            [self addWithfunModel:@"历史订单" imgName:@"home_oreder_icon_history" addList:addList];
            self.isOrderOps = YES;
        }
        if ([array containsObject:@(EN_USER_RESERVATEORDER_AUTHOR)])
        {
            [self addWithfunModel:@"预定订单" imgName:@"home_oreder_icon_book" addList:addList];
            self.isOrderOps = YES;
        }
        if ([array containsObject:@(EN_USER_TAKEOUTORDER_AUTHOR)])
        {
            [self addWithfunModel:@"外卖订单" imgName:@"home_takeout_icon" addList:addList];
            self.isOrderOps = YES;
        }
    }
    if ([addList count] > 0)
    {
        [authorlist addObject:addList];
    }
}

/**
 *  添加财务功能
 */
- (void)addFinanceOp:(NSArray *)array authorlist:(NSMutableArray *)authorlist
{
    NSMutableArray *addList = [NSMutableArray new];
    self.isFiance = NO;
    if ([array containsObject:@(EN_USER_HIGHEST_AUTHOR)] || [array containsObject:@(EN_USER_FINANCIAL_AUTHOR)])
    {
        [self addWithfunModel:@"报表" imgName:@"home_finance_icon_statement" addList:addList];
        self.isFiance = YES;
    }
    else
    {
        if ([array containsObject:@(EN_USER_REPORT_AUTHOR)])
        {
            [self addWithfunModel:@"报表" imgName:@"home_finance_icon_statement" addList:addList];
            self.isFiance = YES;
        }
    }
    if ([addList count] > 0)
    {
        [authorlist addObject:addList];
    }
}

/**
 *  添加设置功能
 */
- (void)addSettingsOp:(NSArray *)array authorlist:(NSMutableArray *)authorlist
{
    NSMutableArray *addList = [NSMutableArray new];
    self.isSetting = NO;
    if ([array containsObject:@(EN_USER_HIGHEST_AUTHOR)] || [array containsObject:@(EN_USER_ALLSHOP_AUTHOR)])
    {
        [self addWithfunModel:@"餐厅资料" imgName:@"home_set_icon_information" addList:addList];
        
        [self addWithfunModel:@"菜单菜品" imgName:@"home_set_icon_menu" addList:addList];
        
        [self addWithfunModel:@"餐位设置" imgName:@"home_set_icon_table" addList:addList];
        
        [self addWithfunModel:@"员工管理" imgName:@"home_set_icon_staff" addList:addList];
        
        [self addWithfunModel:@"出单档口" imgName:@"home_set_icon_stall" addList:addList];
        self.isSetting = YES;
    }
    else
    {
        /*
         EN_USER_SHOPINFO_AUTHOR = 201, ///< 餐厅资料
         EN_USER_SHOPMENU_AUTHOR, ///< 菜单菜品
         EN_USER_SHOPSEAT_AUTHOR, ///< 餐位设置
         EN_USER_SHOPMOUTH_AUTHOR, ///< 档口设置
         EN_USER_MEPMANAGER_AUTHOR, ///< 员工管理
         */
        if ([array containsObject:@(EN_USER_SHOPINFO_AUTHOR)])
        {
            [self addWithfunModel:@"餐厅资料" imgName:@"home_set_icon_information" addList:addList];
            self.isSetting = YES;
        }
        if ([array containsObject:@(EN_USER_SHOPMENU_AUTHOR)])
        {
            [self addWithfunModel:@"菜单菜品" imgName:@"home_set_icon_menu" addList:addList];
            self.isSetting = YES;
        }
        if ([array containsObject:@(EN_USER_SHOPSEAT_AUTHOR)])
        {
            [self addWithfunModel:@"餐位设置" imgName:@"home_set_icon_table" addList:addList];
            self.isSetting = YES;
        }
        if ([array containsObject:@(EN_USER_SHOPMOUTH_AUTHOR)])
        {
            [self addWithfunModel:@"员工管理" imgName:@"home_set_icon_staff" addList:addList];
            self.isSetting = YES;
        }
        if ([array containsObject:@(EN_USER_MEPMANAGER_AUTHOR)])
        {
            [self addWithfunModel:@"出单档口" imgName:@"home_set_icon_stall" addList:addList];
            self.isSetting = YES;
        }
    }
    if ([addList count] > 0)
    {
        [authorlist addObject:addList];
    }
}


/**
 *  订单功能列表
 */
- (NSArray *)getWithOrderOps
{
    return @[@"点菜下单", @"餐中订单", @"历史订单", @"预定订单", @"外卖订单 "];
}

/**
 *  财务功能列表
 */
- (NSArray *)getWithFinances
{
    return @[@"报表"];
}

/**
 * 餐厅功能设置列表
 */
- (NSArray *)getWithShopSetings
{
    return @[@"餐厅资料", @"菜单菜品", @"餐位设置", @"员工管理", @"出单档口"];
}

- (void)getWithUserAuthor:(NSMutableArray *)authorlist
{
    // 用户权限
    NSArray *array = [UserLoginStateObject getWithUserAuthor];
    if (!array)
    {
        array = @[@(0)];
    }
    // 订单
    [self addOrderOp:array authorlist:authorlist];
    
    // 财务
    [self addFinanceOp:array authorlist:authorlist];
    
    // 设置
    [self addSettingsOp:array authorlist:authorlist];
}

@end
