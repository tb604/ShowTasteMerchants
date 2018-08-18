/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualificationViewController.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 17:34
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseTableViewController.h"
#import "CTCShopLicenseDataEntity.h"

typedef NS_ENUM(NSInteger, EN_SHOPQ_ROWS)
{
    EN_SHOPQ_BUSLICENSE_ROW = 0, ///< 营业执照
    EN_SHOPQ_BUSHYGLICENSE_ROW, ///<经营许可证/卫生许可证
    EN_SHOPQ_HEALTHCERONE_ROW, ///< 健康证1
    EN_SHOPQ_HEALTHCERTWO_ROW, ///< 健康证2
    EN_SHOPQ_MAX_ROW
};

/**
 *  餐厅资质视图控制器
 */
@interface CTCShopQualificationViewController : TYZBaseTableViewController

@property (nonatomic, strong) CTCShopLicenseDataEntity *licenseEntity;

@property (nonatomic, assign) NSInteger shopId;

/// 1表示创建餐厅完成后，进入
//@property (nonatomic, assign) NSInteger comeType;

@end














