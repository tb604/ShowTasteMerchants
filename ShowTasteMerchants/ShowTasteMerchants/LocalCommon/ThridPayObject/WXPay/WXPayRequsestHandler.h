//
//  WXPayRequsestHandler.h
//  51tourGuide
//
//  Created by 唐斌 on 16/5/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XMLHelper.h"
#import "WXUtil.h"

#define WXAPPID         @"wx41161bf0d227cc07"

#define WXAPPSecret     @"f5ddd72ff48831342d09945293e73991"

// 商户号
#define WXPartnerID     @"1344499701"

// 商户密钥
#define WXPartnerKey    @"3ehSdJNGouvV4UbKjMl2ciG10NHaQag2"


@interface WXPayRequsestHandler : NSObject
{
    //预支付网关url地址
    NSString *payUrl;
    
    //lash_errcode;
    long     last_errcode;
    //debug信息
    NSMutableString *debugInfo;
    NSString *appid,*mchid,*spkey;
    NSString *notifyurl;
    NSString *ordername;
    CGFloat orderprice;
    NSString *tradeno;
}

//初始化函数
- (BOOL)init:(NSString *)order_name order_price:(CGFloat)order_price notify_url:(NSString *)notify_url trade_no:(NSString *)trade_no;
- (NSString *)getDebugifo;
- (long)getLasterrCode;
//设置商户密钥
//- (void)setKey:(NSString *)key;
//创建package签名
- (NSString*)createMd5Sign:(NSMutableDictionary *)dict;
//获取package带参数的签名包
- (NSString *)genPackage:(NSMutableDictionary *)packageParams;
//提交预支付
- (NSString *)sendPrepay:(NSMutableDictionary *)prePayParams;
//签名实例测试
- (NSMutableDictionary *)sendPay_demo;

@end
