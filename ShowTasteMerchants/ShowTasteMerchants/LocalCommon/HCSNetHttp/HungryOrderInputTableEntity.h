//
//  HungryOrderInputTableEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  订单信息，插入数据库的参数
 */
@interface HungryOrderInputTableEntity : NSObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger shopId;

/// 提供者 1为饿了么，2为美团，3为百度外卖
@property (nonatomic, assign) NSInteger provider;

/// 订单id
@property (nonatomic, copy) NSString *orderId;

/// 0表示通过订单id，获取订单详情失败；1表示获取成功
@property (nonatomic, assign) NSInteger state;

@end

/*
 create table if not exists %@(autoid integer primary key autoincrement not null, userId integer, shopId integer, orderId varchar(50), provider integer, state integer, regtime datetime);
*/
