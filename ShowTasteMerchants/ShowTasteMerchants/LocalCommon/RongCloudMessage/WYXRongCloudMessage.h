//
//  WYXRongCloudMessage.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h> // 融云
#import "NotifyMessageEntity.h"

// 接收到信息后调用
#define kWYXClientReceiveMessageNotification @"WYXClientReceiveMessageNotification"

@interface WYXRongCloudMessage : NSObject <RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate, RCIMUserInfoDataSource, RCIMGroupInfoDataSource>

+ (WYXRongCloudMessage *)shareInstance;

/**
 *  连接融云服务器
 */
- (void)connectRCIMServer;

/**
 *  重新连接
 */
- (void)reconnectServer;

- (void)setDeviceTokend:(NSString *)token;

- (void)sendMsg:(NSString *)content targetId:(NSString *)targetId;

@end




























