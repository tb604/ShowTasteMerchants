//
//  MyFinanceDayViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"

typedef NS_ENUM(NSInteger, EN_FD_SECTIONS)
{
    EN_FD_BASE_INFO_SECTION = 0, ///< 基本信息
    EN_FD_ORDER_SECTION, ///< 今日订单
    EN_FD_ABNORMAL_ORDER_SECTION, ///< 异常订单
    EN_FD_MAX_SECTION
};

/**
 *  财务日视图控制器
 */
@interface MyFinanceDayViewController : TYZRefreshTableViewController

@end






























