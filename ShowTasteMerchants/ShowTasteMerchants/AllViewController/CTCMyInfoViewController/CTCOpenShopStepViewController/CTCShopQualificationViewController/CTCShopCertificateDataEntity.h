/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopCertificateDataEntity.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 17:54
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

@interface CTCShopCertificateDataEntity : NSObject

///
@property (nonatomic, assign) NSInteger id;

/// iamgetype
@property (nonatomic, assign) NSInteger type;

/// 图片地址
@property (nonatomic, copy) NSString *name;

/// 0：未处理 1：有问题 2：成功
@property (nonatomic, assign) NSInteger status;

/// 有问题的备注
@property (nonatomic, copy) NSString *remark;

@end

/*
 "id": 39,
 "type": 4000,
 "name": "http://test-img.xiuwei.chinatopchef.com/xw-test/4/4000/787431b7-b495-c084-1997-f74373a85776.jpg",
 "status": 1,
 "remark": "营业执照过期"
 */
















