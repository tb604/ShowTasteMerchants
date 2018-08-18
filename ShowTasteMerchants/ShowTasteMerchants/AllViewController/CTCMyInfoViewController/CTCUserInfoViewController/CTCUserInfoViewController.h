/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserInfoViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 14:10
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseTableViewController.h"


typedef NS_ENUM(NSInteger, EN_UINFO_SECTIONS)
{
    EN_UINFO_HEADIMAGE_SECTION = 0,   ///< 头像
    EN_UINFO_BAICINFO_SECTION,         ///< 基本信息
    EN_UINFO_MAX_SECTION
};


typedef NS_ENUM(NSInteger, EN_UINFO_BAICINFO_ROWS)
{
    EN_UINFO_BAICINFO_NAME_ROW = 0, ///< 姓名
    EN_UINFO_BAICINFO_POST_ROW, ///< 职位
    EN_UINFO_BAICINFO_AUTHOR_ROW,   ///< 权限
    EN_UINFO_BAICINFO_PHONE_ROW,   ///< 手机号码
    EN_UINFO_BAICINFO_PWD_ROW,   ///< 密码
    EN_UINFO_BAICINFO_MAX_ROW
};


/// 用户信息视图控制器
@interface CTCUserInfoViewController : TYZBaseTableViewController

@end

















