//
//  HungryOrderBodyEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//
#import <RongIMLib/RongIMLib.h>
#import <Foundation/Foundation.h>
#import "HungryOrdersEntity.h"

#define JCBNotifyHungryMsgTypeIdentifier @"RC:CtcMsgWaiMai"

@interface HungryOrderBodyEntity : RCMessageContent

@property (nonatomic, assign) NSInteger shop_id;

/// 通知类型 2 外卖
@property (nonatomic, assign) NSInteger type;

/// 订单的状态(cmd)
@property (nonatomic, assign) NSInteger commend;

@property (nonatomic, strong) HungryOrdersEntity *body;

/// (description)
@property (nonatomic, copy)NSString *desc;

@property (nonatomic, copy) NSString *request_id;


@end

/*
 notify_body":{"msg_show":"您有新的外卖订单,请及时处理","msg_voice":"","notify_cmd":2000,"order_id":"{\"platform\":\"ele\",\"orderIds\":[\"101582797453145710\"]}","shop_id":76}
*/
