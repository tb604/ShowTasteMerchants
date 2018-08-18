//
//  NotifyBodyEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrdersEntity.h"

@interface NotifyBodyEntity : NSObject

/**
 * 详情请见 LocalCommon.h文件
 */
@property (nonatomic, assign) NSInteger notify_cmd;

/**
 * 订单id
 */
@property (nonatomic, strong) id order_id;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *
 */
@property (nonatomic, copy) NSString *msg_show;

/**
 *  音频文件
 */
@property (nonatomic, copy) NSString *msg_voice;

@end




























