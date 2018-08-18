/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCLoginViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/18 17:25
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseViewController.h"

/**
 *  登录视图控制器
 */
@interface CTCLoginViewController : TYZBaseViewController

/// 1表示老板登录；2表示员工登录
@property (nonatomic, assign) NSInteger userLoginType;

// 3 从餐厅列表，资质 
@property (nonatomic, assign) NSInteger comeType;

@end
