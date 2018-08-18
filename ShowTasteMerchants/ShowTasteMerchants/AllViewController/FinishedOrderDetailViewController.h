//
//  FinishedOrderDetailViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OrderDetailDataEntity.h"
#import "CTCOrderDetailEntity.h"


typedef NS_ENUM(NSInteger, EN_FINISH_ORDER_SECTIONS)
{
    EN_FINISH_ORDER_BASEINFO_SECTION = 0, ///< 基本信息
    EN_FINISH_ORDER_FOOD_SECTION, ///< 菜单
    EN_FINISH_ORDER_STAR_SECTION, ///< 总体、口味、服务、环境
    EN_FINISH_ORDER_RECOMMENTMSG_SECTION, ///< 评论内容
    EN_FINISH_ORDER_MAX_SECTION
};


/**
 *  完成的订单详情视图控制器
 */
@interface FinishedOrderDetailViewController : TYZRefreshTableViewController

/**
 *  订单详情
 */
@property (nonatomic, strong) CTCOrderDetailEntity *orderDetailEntity;

/**
 *  1表示餐厅端；2表示食客端
 */
//@property (nonatomic, assign) NSInteger modeType;

@property (nonatomic, strong) OrderDataEntity *orderEnt;

@end
