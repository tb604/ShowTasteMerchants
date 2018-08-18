//
//  MyWalletConsumeEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletConsumeEntity : NSObject

/**
 *
 */
@property (nonatomic, copy) NSString *serial_no;

/**
 * 1表示收入；2表示支出
 */
@property (nonatomic, assign) NSInteger category;

/**
 * 描述
 */
@property (nonatomic, copy) NSString *category_desc;

/**
 * 1预订支出；2结算支出；3分佣收益
 */
@property (nonatomic, assign) NSInteger type;

/**
 * 描述
 */
@property (nonatomic, copy) NSString *type_desc;

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *order_id;

/**
 * 金额
 */
@property (nonatomic, assign) CGFloat money;

/**
 * 余额
 */
@property (nonatomic, assign) CGFloat balance;

/**
 *
 */
@property (nonatomic, copy) NSString *remark;

/**
 *
 */
@property (nonatomic, copy) NSString *create_datetime;

/**
 *  显示的时间
 */
@property (nonatomic, copy) NSString *showDate;

@property (nonatomic, strong) NSMutableArray *subConsumeList;

@end

NS_ASSUME_NONNULL_END

/*
 "serial_no": "201608291622214750986093576",
 "category": 2,
 "category_desc": "支出",
 "type": 2,
 "type_desc": "结算支出",
 "order_id": "2016082457565549",
 "money": "389.99",
 "balance": "0.00",
 "remark": "柠檬鱼消费",
 "create_datetime": "2016-08-29 16:22:19"
*/




























