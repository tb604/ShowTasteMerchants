/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: AlipayOrder.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 15/3/25 下午1:51
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>

@interface AlipayOrder : NSObject

@property(nonatomic, copy) NSString * partner;

/**
 *  卖家支付宝 用户号
 */
@property(nonatomic, copy) NSString * seller;

/**
 *  订单ID(由商家自行制定)
 */
@property(nonatomic, copy) NSString * tradeNO;

/**
 *  商品标题
 */
@property(nonatomic, copy) NSString * productName;

/**
 *  商品描述
 */
@property(nonatomic, copy) NSString * productDescription;

/**
 *  交易金额
 */
@property(nonatomic, copy) NSString * amount;

/**
 *  回调url
 */
@property(nonatomic, copy) NSString * notifyURL;

/**
 *  接口名称，mobile.securitypay.pay
 */
@property(nonatomic, copy) NSString * service;

/**
 *  支付类型 ,默认为1(商品购买)
 */
@property(nonatomic, copy) NSString * paymentType;

/**
 *  编码内型utf-8
 */
@property(nonatomic, copy) NSString * inputCharset;

/**
 *  未付款交 易的超时 时间。取值范围：1m~15d(m-分钟；h-小时；d-天)
 */
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

@end





























