/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopLicenseInputEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/26 13:06
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

/// 添加餐厅经营资质传入参数
@interface CTCShopLicenseInputEntity : NSObject

/// 餐厅id
@property (nonatomic, assign) NSInteger shopId;

/// 营业执照url
@property (nonatomic, copy) NSString *biz_lic;

/// 经营许可证/卫生许可证
@property (nonatomic, copy) NSString *opt_lic;

/// 健康证1
@property (nonatomic, copy) NSString *health_lic1;

/// 健康证2
@property (nonatomic, copy) NSString *health_lic2;

@end


















