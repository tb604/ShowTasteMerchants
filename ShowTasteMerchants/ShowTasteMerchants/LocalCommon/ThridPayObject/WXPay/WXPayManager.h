//
//  WXPayManager.h
//  51tourGuide
//
//  Created by 唐斌 on 16/5/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXPayRequsestHandler.h"

@interface WXPayManager : NSObject <WXApiDelegate>

/**
 *  state 0表示成功；1表示失败
 */
@property (nonatomic, copy) void (^wxPayStateBlock)(int state);

+ (instancetype)sharedManager;

- (BOOL)wxRegisterApp:(NSString *)appId withDesc:(NSString *)desc;

/**
 *  微信购买函数
 *
 *  @param price      金额
 *  @param tradeNo    交易号
 *  @param title      标题
 *  @param notifiyUrl 回掉地址
 */
- (void)payProductWithPrice:(CGFloat)price tradeNo:(NSString *)tradeNo title:(NSString *)title notifiyUrl:(NSString *)notifiyUrl;

@end



















