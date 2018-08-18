//
//  MyInfoViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"


// 我的收藏(i_icon_collect)
// 推荐餐厅(i_icon_recommend)
// 邀请好友(i_icon_invite)
// 推广收益(i_icon_earnings)
// 设置(i_icon_set)
// 帮助(i_icon_help)

typedef NS_ENUM(NSInteger, EN_MYINFO_ROWS)
{
    EN_MYINFO_COLLECT_ROW = 0, ///< 我的收藏
    EN_MYINFO_RECOMMEND_ROW, ///< 推荐餐厅
    EN_MYINFO_INVITE_ROW, ///< 邀请好友
    EN_MYINFO_EARNINGS_ROW, ///< 推广收益
    EN_MYINFO_SETTINGS_ROW, ///< 设置
    EN_MYINFO_HELP_ROW, ///< 帮助
    EN_MYINFO_MAX_ROW
};


/**
 *  我的视图控制器
 */
@interface MyInfoViewController : TYZBaseTableViewController


@end
