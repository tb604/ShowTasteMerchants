//
//  MyFinanceWeekViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"


typedef NS_ENUM(NSInteger, EN_FW_SECTIONS)
{
    EN_FW_ORDERNUM_SECTION = 0, ///<
    EN_FW_ORDERCHART_SECTION, ///<
    EN_FW_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_FW_CHART_ROWS)
{
    EN_FW_CHART_TOTALAMOUNT_ROW = 0, ///< 营业总额
    EN_FW_CHART_AMOUNTWEEK_ROW, ///< 以周为单位的统计
    EN_FW_CHART_ORDERDATA_ROW, ///< 本周订单数据图
    EN_FW_CHART_MAX_ROW
};


/**
 *  我的财务周视图控制器
 */
@interface MyFinanceWeekViewController : TYZRefreshTableViewController

@end














