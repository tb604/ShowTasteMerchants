//
//  WXPayManager.m
//  51tourGuide
//
//  Created by 唐斌 on 16/5/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WXPayManager.h"
#import "LocalCommon.h"
#import "WXPayRequsestHandler.h"

@interface WXPayManager ()

@property (nonatomic, strong) WXPayRequsestHandler *payReqHandler;

@end

@implementation WXPayManager

+ (instancetype)sharedManager
{
    static WXPayManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WXPayManager alloc] init];
        
    });
    return instance;
}

- (id)init
{
    if (self = [super init])
    {
        _payReqHandler = [WXPayRequsestHandler new];
    }
    return self;
}

- (BOOL)wxRegisterApp:(NSString *)appId withDesc:(NSString *)desc
{
    BOOL bret = [WXApi registerApp:appId withDescription:desc];
    if (bret)
    {
        debugLog(@"微信支付注册成功");
    }
    else
    {
        debugLog(@"微信支付注册失败");
    }
    return bret;
}

/**
 *  微信购买函数
 *
 *  @param price      金额
 *  @param tradeNo    交易号
 *  @param title      标题
 *  @param notifiyUrl 回掉地址
 */
- (void)payProductWithPrice:(CGFloat)price tradeNo:(NSString *)tradeNo title:(NSString *)title notifiyUrl:(NSString *)notifiyUrl
{
    [_payReqHandler init:title order_price:price notify_url:notifiyUrl trade_no:tradeNo];
    NSMutableDictionary *dict = [_payReqHandler sendPay_demo];
    if (!dict)
    {
        debugLog(@"错误=%@", [_payReqHandler getDebugifo]);
        if (_wxPayStateBlock)
        {// 1表示失败
            _wxPayStateBlock(1);
        }
        return;
    }
    
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq *payReq             = [[PayReq alloc] init];
//    payReq.openID              = [dict objectForKey:@"appid"];
    payReq.partnerId           = [dict objectForKey:@"partnerid"];
    payReq.prepayId            = [dict objectForKey:@"prepayid"];
    payReq.nonceStr            = [dict objectForKey:@"noncestr"];
    payReq.timeStamp           = stamp.intValue;
    payReq.package             = [dict objectForKey:@"package"];
    payReq.sign                = [dict objectForKey:@"sign"];
    
    [WXApi sendReq:payReq];
    
    /*__weak typeof(self)weakSelf = self;
    
    
    
    [self requestWithWX:price tradeNo:tradeNo title:title notifiyUrl:notifiyUrl complation:^(NSString *sign, NSString *prepayId) {
        [weakSelf wxPay:sign prepayId:prepayId];
    }];*/
}

#pragma mark WXApiDelegate
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {// 支付返回结果，实际支付结果需要去微信服务器端查询
        PayResp *response = (PayResp *)resp;
        int state = 1;
        if (response.errCode == WXSuccess)
        {
            debugLog(@"支付成功");
            state = 0;
        }
        else
        {
            debugLog(@"支付失败");
            state = 1;
        }
        if (_wxPayStateBlock)
        {
            _wxPayStateBlock(state);
        }
    }
}

//- (void)onReq:(BaseReq *)req
//{
//    debugMethod();
//}

@end
















