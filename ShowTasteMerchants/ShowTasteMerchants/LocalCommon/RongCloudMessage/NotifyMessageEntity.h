//
//  NotifyMessageEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "NotifyBodyEntity.h"

#define JCBNotifyMessageTypeIdentifier @"RC:CtcMsg"

@interface NotifyMessageEntity : RCMessageContent

/**
 *  0系统通知；1订单通知；2饿了么通知
 */
@property (nonatomic, assign) NSInteger notify_type;

/**
 *  不同的通知类型，通知消旋体是不一样的
 */
@property (nonatomic, strong) id notify_body;

@end




















