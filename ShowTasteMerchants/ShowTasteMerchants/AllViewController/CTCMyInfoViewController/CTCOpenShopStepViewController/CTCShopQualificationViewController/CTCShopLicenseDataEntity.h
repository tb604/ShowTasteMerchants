/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopLicenseDataEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 13:14
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import "CTCShopCertificateDataEntity.h"

/// 认证资质相关字段
@interface CTCShopLicenseDataEntity : NSObject

/// 1：未上传过资质图片 2：已上传，待审核  3：审核失败 4：审核成功
@property (nonatomic, assign) NSInteger state;

/// 0：不显示资质页面   1：显示资质页面
@property (nonatomic, assign) NSInteger display;

///
@property (nonatomic, strong) NSMutableArray *certificates;

@end
















