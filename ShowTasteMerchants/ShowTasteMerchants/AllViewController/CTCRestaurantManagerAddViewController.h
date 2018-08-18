/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerAddViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/20 22:21
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseTableViewController.h"
//#import "ShopManageDataEntity.h"
#import "ShopManageNewDataEntity.h"
#import "ShopManagePositionAuthEntity.h"


typedef NS_ENUM(NSInteger, EN_EMPLOYE_MANAGE_ROWS)
{
    EN_EMPLOYE_MANAGE_NAME_ROW = 0,   ///< 姓名
    EN_EMPLOYE_MANAGE_PROFESS_ROW,  ///< 职称
    EN_EMPLOYE_MANAGE_PHONE_ROW, ///< 手机号码
    EN_EMPLOYE_MANAGE_PASSWORD_ROW,    ///< 密码
    EN_EMPLOYE_MANAGE_PERMISS_ROW, ///< 权限
    EN_EMPLOYE_MANAGE_MAX_ROW
};


/// 添加或者编辑员工视图控制器
@interface CTCRestaurantManagerAddViewController : TYZBaseTableViewController

/// 是否添加
@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, strong) ShopManageNewDataEntity *managerEntity;

/**
 *  职位、权限
 */
@property (nonatomic, strong) ShopManagePositionAuthEntity *postionAuthEntity;

@end













