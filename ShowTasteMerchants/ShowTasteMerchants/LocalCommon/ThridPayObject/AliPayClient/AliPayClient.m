/*
 *   Copyright (c) 2015年 51tour. All rights reserved.
 *
 * 项目名称: 51tour
 * 文件名称: AliPayClient.m
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

#import "AliPayClient.h"
#import "AlipayOrder.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LocalCommon.h"
#include "UtilityObject.h"

@implementation AliPayClient

- (void)dealloc
{
//    CC_SAFE_RELEASE_NULL(_AliPayStateBlock);
    
//    [super dealloc];
}

#pragma mark start public methods

- (void)payProductWithPrice:(CGFloat)price tradeNo:(NSString *)tradeNo title:(NSString *)title notifiyUrl:(NSString *)notifiyUrl
{
    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = AlipayPartnerID;
    order.seller = AlipaySellerID;
    order.tradeNO = tradeNo; // 订单ID（由商家自行制定）
    order.productName = @"51导游快捷支付订单I"; // 商品标题
    order.productDescription = @"51导游快捷支付订单I"; // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    
    // (购买支付回调)http://192.168.0.105:8099/vtg/spbuy/api.do?method=alipayClientCallback
    
    order.notifyURL = [notifiyUrl stringByURLEncode];
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"1d";
    order.showUrl = @"m.alipay.com";
    
    // 应用注册scheme
    NSString *appScheme = @"tourGuide51";//@"touralipay";
    
    // 将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //    debugLog(@"orderSpec=%@", orderSpec);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(AlipayPartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    
    /*
     "errcode": 0,
     "msg": "",
     "data": {
     "payUrl": "partner= 2088221480907573&seller_id=2083491727@qq.com&out_trade_no=abcxxx&subject=name&body=body&total_fee=100&notify_url=http://182.254.132.142/Pay/alipayNotify&service=mobile.securitypay.pay&payment_type=1&_input_charset=utf-8&it_b_pay=30m&return_url=m.alipay.com&sign=rMcxufs0SOeQUHydAyVkWsk2M3kh6RJSMjxLpKllZIapgwHV8Scz4bIYgbHuWb7GrBXryJhjuhreeLma7NC0KcOzbh7pGoQfcprQXbO%2F9p5dlnhdRUtFNji6kCxI9%2Bdv5xJZcWRh13tlzCIbaH0nB29tIFX%2B%2BFw0JOUg7FTTwuY%3D&sign_type=RSA"
     }
     */
    
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
        // 开始发送支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //            debugLog(@"%s--得到了支付结果：result=%@", __func__, resultDic);
            if (_AliPayStateBlock)
            {
                _AliPayStateBlock([resultDic[@"resultStatus"] integerValue]);
            }
        }];
    }
//    [order release], order = nil;
}

/**
 *  支付宝支付，从服务端获取签名
 *
 *  @param price   价格
 *  @param orderNo 订单编号
 *  @param name    名字
 *  @param body  商品详情
 */
- (void)payProductWithPriceUrl:(CGFloat)price orderNo:(NSString *)orderNo name:(NSString *)name body:(NSString *)body
{
    // 应用注册scheme
    NSString *appScheme = @"alipayshowtaste";
    NSString *strPrice = [NSString stringWithFormat:@"%.2f",price];
    [HCSNetHttp requestWithPayAlipayPayUrl:orderNo name:name body:body money:strPrice completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {// Show the taste
            [[AlipaySDK defaultService] payOrder:respond.data fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                debugLog(@"%s--得到了支付结果：result=%@", __func__, resultDic);
                if (_AliPayStateBlock)
                {
                    _AliPayStateBlock([resultDic[@"resultStatus"] integerValue]);
                }
            }];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:nil];
        }
    }];
}

#pragma mark end public methods

@end



























