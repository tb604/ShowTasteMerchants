/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: AliPayClient.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 15/3/25 下午2:05
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 合作伙伴身份（PID）：2088221480907573
 支付宝账号：2083491727@qq.com
 */

//合作身份者id，以2088开头的16位纯数字
#define AlipayPartnerID @"2088221480907573"
//收款支付宝账号
#define AlipaySellerID  @"2083491727@qq.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define AlipayMD5_KEY @"jz70x4fch6z9iaw50bopsjm5lfokalu4"

//商户私钥，自助生成
#define AlipayPartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAP4VAIy/Z29JVnZHnHe9lLSe0TezKQMKP+55vaGRSPOLkwn4f5pWKXe9FU2aQo8OZvIYv35zGVpDmubribiG7JCilVWQ1l5AsTCYUvXQSiqomL3aTqPhgwI3fav1VTzg/jpZu6YCPLdY2YIiR/42KLQYD7/RuBpE0xdwm5/F1sUJAgMBAAECgYEA0Oh5zD/wDttw4M2ehAF3jE7s3OxNMzexOyYT2g03uy+ulUsht8dSTyZDpsvIIBGKaVIZ2SFP3hyp92YAlZ0yUVJG/OLcgADCG7IGgk+/7hMQSltEBPcQhLRY5tRoIAY4EmNm5ZKMYp0Xbd23ftBdJ2kXufEic//AgAxlZUznfEUCQQD/ReYGj882YvvnsfXf9Npkwt6akrK366b8Ibms+isTy7GuicXbfEe9Jhymvs5OXbIne9HysVAJFg1SB6a3I1gvAkEA/s48Pu9G0QTkptAKiWeekssABvlOyr9fu0hbl+xfW5DfnxaZ3XSmRilO5DvMQcFiJyjpQ3ZpJ0FPIrpopOewRwJBAIz1ryB+duDEZe+6QFhr39D2Hm/ig9e1w97ETMBs4C6tMy97Goupo/+ZtQaKpGd3q7HL2NIYAWcTC0X5vaCxXrcCQD30aWOoDGEAPpRs21MDleP9ZflMHyNfGujPtC2hdKIv/J+TAEB/f3ppytvlyklmuvXolacooHLCB3rbNlx6VTsCQQDjbzY1chvyDoEvRgZV9Hv5ehiBaIQIcGI+SIOq92u0nS2ChYm8tzGom0+Te5Ok4c644peHbXw8Y0EN0GSXStDT"


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

@interface AliPayClient : NSObject

@property (nonatomic, copy) void (^AliPayStateBlock)(NSInteger state);

//- (void)payProductWithPrice:(CGFloat)price tradeNo:(NSString *)tradeNo title:(NSString *)title;

/**
 *  支付宝支付
 *
 *  @param price      金额
 *  @param tradeNo    流水号
 *  @param title      标题
 *  @param notifiyUrl 回掉地址
 */
- (void)payProductWithPrice:(CGFloat)price tradeNo:(NSString *)tradeNo title:(NSString *)title notifiyUrl:(NSString *)notifiyUrl;

/**
 *  支付宝支付，从服务端获取签名
 *
 *  @param price   价格
 *  @param orderNo 订单编号
 *  @param name    名字
 *  @param body  商品详情
 */
- (void)payProductWithPriceUrl:(CGFloat)price orderNo:(NSString *)orderNo name:(NSString *)name body:(NSString *)body;

@end





















