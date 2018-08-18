//
//  MyRestaurantAddManagerViewController.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "ShopManageNewDataEntity.h"


typedef NS_ENUM(NSInteger, EN_EDIT_MANAGER_ROWS)
{
    EN_EDIT_MANAGER_HEADER_ROW = 0, ///< 头像
    EN_EDIT_MANAGER_PHONE_ROW,      ///< 手机号码
    EN_EDIT_MANAGER_NAME_ROW,       ///< 姓名
    EN_EDIT_MANAGER_ROLE_ROW,       ///< 角色
//    EN_EDIT_MANAGER_PASSWORD_ROW,   ///< 密码
    EN_EDIT_MANAGER_MGSHOP_ROW,     ///< 管理餐厅
    EN_EDIT_MANAGER_MAX_ROW
};

/**
 *  添加管理员视图控制器
 */
@interface MyRestaurantAddManagerViewController : TYZBaseTableViewController

/// 是否添加
@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) ShopManageNewDataEntity *managerEntity;

@end























