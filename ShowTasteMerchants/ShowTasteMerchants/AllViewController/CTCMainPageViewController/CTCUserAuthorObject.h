/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserAuthorObject.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/31 16:40
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

@interface CTCUserAuthorObject : NSObject

/// 是否有订单功能
@property (nonatomic, assign) BOOL isOrderOps;

/// 是否有财务功能
@property (nonatomic, assign) BOOL isFiance;

/// 是否有设置功能
@property (nonatomic, assign) BOOL isSetting;


- (void)getWithUserAuthor:(NSMutableArray *)authorlist;

/**
 *  订单功能列表
 */
- (NSArray *)getWithOrderOps;

/**
 *  财务功能列表
 */
- (NSArray *)getWithFinances;

/**
 * 餐厅功能设置列表
 */
- (NSArray *)getWithShopSetings;

@end
