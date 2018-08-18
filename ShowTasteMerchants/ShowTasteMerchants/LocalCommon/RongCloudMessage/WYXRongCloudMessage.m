//
//  WYXRongCloudMessage.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "WYXRongCloudMessage.h"
#import "LocalCommon.h"
#import "NotifyMessageEntity.h"
#import "TYZKit.h"
#import "TYZDBManager.h"
//#import "UserLoginDataEntity.h"
#import "UserLoginStateObject.h"
#import "UserInfoDataEntity.h"
#import "HungryBaseInfoObject.h"
#import "HungryOrderBodyEntity.h"

@interface WYXRongCloudMessage ()
{
    /**
     *  0表示连接成功；1表示连接失败
     */
    NSInteger _connectionState;

}

/// 饿了么 接收到的订单信息
@property (nonatomic, strong) HungryBaseInfoObject *hungryInfoObject;

/**
 *  初始化融云sdk
 */
- (void)initWithRongCloud;
@end

@implementation WYXRongCloudMessage

+ (WYXRongCloudMessage *)shareInstance
{
    static WYXRongCloudMessage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        [instance initWithRongCloud];
    });
    return instance;
}

#pragma mark private methods
/**
 *  初始化融云sdk
 */
- (void)initWithRongCloud
{
    
//    NotifyMessageEntity
//    NotifyBodyEntity *bodyEnt = [NotifyBodyEntity new];
//    bodyEnt.notify_cmd = 2000;
//    bodyEnt.order_id = @"123456";
//    NotifyMessageEntity *msgEnt = [NotifyMessageEntity new];
//    msgEnt.notify_type = 2;
//    msgEnt.notify_body = bodyEnt;
//    debugLog(@"bod=%@", [msgEnt modelToJSONString]);
    
    /*
     {"notify_type":2,"notify_body":{"order_id":"123456","notify_cmd":2000,"shop_id":0}}
     */
    
    self.hungryInfoObject = [HungryBaseInfoObject shareInstance];
    
    //
    // 初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:kRYAppKey];
    
    // 注册自定义消息
    [[RCIM sharedRCIM] registerMessageType:[NotifyMessageEntity class]];
    [[RCIM sharedRCIM] registerMessageType:[HungryOrderBodyEntity class]];
    
    // 连接状态
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    // 设置回话列表头像和回话界面头像
    if (kiPhone6Plus)
    {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    }
    else
    {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    
    // 设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].groupInfoDataSource = self;
    
    // 设置群组内用户信息源。如果不实用群名片功能，可以不设置
//    [RCIM sharedRCIM].groupUserInfoDataSource = self;
    
    // 设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    // 开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    
    // 开启发送已读回执(只支持单聊)
    [RCIM sharedRCIM].enableReadReceipt = YES;
    
//    [RCIM sharedRCIM].showUnkownMessage = YES;
//    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
}

- (void)sendMsg:(NSString *)content targetId:(NSString *)targetId
{
    RCTextMessage *msg = [RCTextMessage messageWithContent:content];
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:targetId content:msg pushContent:@"哈哈" pushData:nil success:^(long messageId) {
        debugLog(@"发送“%@” 成功。", content);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        debugLog(@"errorCode=%d", (int)nErrorCode);
    }];
}

#pragma mark public methods
- (void)connectRCIMServer
{
    debugMethod();
    /*
     {"code":200,"userId":"4","token":"OncKSSQKkw0sDvgts1efmRaibZ/eKStHMPaOAUIGXueXd9moOlsyXp8YG9u0/CWmtGGHFeKcSf3DtSyMKJCcHw=="}
     */
//    NSString *ryToken = @"OncKSSQKkw0sDvgts1efmRaibZ/eKStHMPaOAUIGXueXd9moOlsyXp8YG9u0/CWmtGGHFeKcSf3DtSyMKJCcHw==";
    UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
//    debugLog(@"userId=%d", (int)userLogEntity.vtgUser.userId);
    //    debugLog(@"ryToken=%@", userLogEntity.vtgUser.ryToken);
    __weak typeof(self)blockSelf = self;
    debugLog(@"userId=%d; msgToken=%@", (int)userInfo.user_id, userInfo.msg_token);
    if (userInfo.msg_token)
    {
        // 登录融云服务器
        [[RCIM sharedRCIM] connectWithToken:userInfo.msg_token success:^(NSString *userId) {
            debugLog(@"连接融云服务器成功。userId=%@", userId);
        } error:^(RCConnectErrorCode status) {
            debugLog(@"连接融云服务器失败。");
        } tokenIncorrect:^{
            debugLog(@"token错误或者过期");
            [HCSNetHttp requestWithPush:userInfo.user_id completion:^(id result) {
                TYZRespondDataEntity *respond = result;
                if (respond.errcode == respond_success)
                {
                    [blockSelf resetConnection];
                }
                else if (respond.errcode == 200)
                {
                    
                }
            }];
        }];
    }
    else
    {
        debugLog(@"else");
        [HCSNetHttp requestWithPush:userInfo.user_id completion:^(id result) {
            TYZRespondDataEntity *respond = result;
            if (respond.errcode == respond_success)
            {
                [blockSelf resetConnection];
            }
        }];
    }
}

- (void)resetConnection
{
//    NSString *ryToken = @"OncKSSQKkw0sDvgts1efmRaibZ/eKStHMPaOAUIGXueXd9moOlsyXp8YG9u0/CWmtGGHFeKcSf3DtSyMKJCcHw==";
    UserInfoDataEntity *userInfo = [UserLoginStateObject getUserInfo];
    if (userInfo.msg_token)
    {
        // 登录融云服务器
        [[RCIM sharedRCIM] connectWithToken:userInfo.msg_token success:^(NSString *userId) {
            debugLog(@"连接融云服务器成功。");
        } error:^(RCConnectErrorCode status) {
            debugLog(@"连接融云服务器失败。");
        } tokenIncorrect:^{
            debugLog(@"token错误或者过期");
        }];
    }
}

- (void)reconnectServer
{
    if (_connectionState != 0)
    {
        debugLog(@"开始重新连接");
        [self connectRCIMServer];
    }
}

- (void)setDeviceTokend:(NSString *)token
{
    debugLog(@"token=%@", token);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}


#pragma mark RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
//    {"shop_id":76,"type":2,"cmd":2000,"body":"{\"platform\":\"ele\",\"eleme_order_ids\":[\"101582797453145710\"]}","description":"ddd","request_id":"c38dca418e6bfb0877ce8a4373df7a8b"}
    
    debugLog(@"%s-------start-------", __func__);
//    debugLog(@"direction=%d", (int)message.messageDirection);
//    debugLog(@"nleft=%d", left);
//    debugLog(@"targetId=%@", message.targetId);
//    debugLog(@"senderUserId=%@", message.senderUserId);
    debugLog(@"objectName=%@", message.objectName);
    debugLog(@"content.class=%@", NSStringFromClass([message.content class]));
    debugLog(@"body=%@", [message.content modelToJSONString]);
    debugLog(@"%s-------end-------", __func__);
    if ([message.content isMemberOfClass:[HungryOrderBodyEntity class]])
    {// 通知消息
        debugLog(@"systemMessage");
//        debugLog(@"conen=%@", [message.content modelToJSONString]);
        HungryOrderBodyEntity *notifyMsg = (HungryOrderBodyEntity *)message.content;
        [_hungryInfoObject revcOrderInfo:notifyMsg];
//        debugLog(@"type=%d", (int)notifyMsg.notify_type);
//        debugLog(@"commend=%d", (int)notifyMsg.commend);
//        debugLog(@"request_id=%@", notifyMsg.request_id);
//        debugLog(@"desc=%@", notifyMsg.desc);
//        debugLog(@"platform=%@", notifyMsg.body.platform);
//        id array = notifyMsg.body.eleme_order_ids;
//        debugLog(@"array=%@", NSStringFromClass([array class]));
//        for (NSString *orderId in array)
//        {
//            debugLog(@"orderId=%@", orderId);
//        }
        /**
         *
         {"notify_type":2,"notify_body":{"msg_show":"您有新的外卖订单,请及时处理","msg_voice":"","notify_cmd":2000,"order_id":"{\"platform\":\"ele\",\"orderIds\":[\"101582797453145710\"]}","shop_id":76}}
         */
        
        /*if (notifyMsg.notify_type == 2)
        {// 饿了么的推送
            NSDictionary *dict = [notifyMsg.notify_body modelToJSONObject];
            HungryOrderBodyEntity *entity = [HungryOrderBodyEntity modelWithJSON:dict];
            notifyMsg.notify_body = entity;
            [_hungryInfoObject revcOrderInfo:entity];
        }
        else if (notifyMsg.notify_type == 1)
        {// 订单通知
            
        }*/
//        NotifyBodyEntity *entity = [NotifyBodyEntity modelWithJSON:dict];
//        notifyMsg.notify_body = entity;
//        debugLog(@"entity=%@", [entity modelToJSONString]);
//        debugLog(@"cmd=%d", (int)entity.notify_cmd);
//        [[NSNotificationCenter defaultCenter] postNotificationName:kWYXClientReceiveMessageNotification object:notifyMsg];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kWYXClientReceiveMessageNotification object:message];
    }
}

#pragma mark RCIMConnectionStatusDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    _connectionState = status;
}

#pragma mark RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
}

#pragma mark RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
}

@end
