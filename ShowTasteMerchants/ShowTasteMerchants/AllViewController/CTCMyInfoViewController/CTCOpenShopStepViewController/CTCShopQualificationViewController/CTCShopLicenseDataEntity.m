/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopLicenseDataEntity.m
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

#import "CTCShopLicenseDataEntity.h"


@implementation CTCShopLicenseDataEntity

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"certificates" : [CTCShopCertificateDataEntity class]};
}

@end
