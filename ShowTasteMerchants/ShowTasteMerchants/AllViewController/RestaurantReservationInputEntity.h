//
//  RestaurantReservationInputEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  预订餐厅传入参数
 */
@interface RestaurantReservationInputEntity : NSObject

@property (nonatomic, copy) NSString *orderId;

/**
 *  -1表示还没有提交的订单；其它状态按照规定来
 */
@property (nonatomic, assign) NSInteger orderState;

@property (nonatomic, assign) NSInteger userId;

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shopId;

/**
 *  预订日期
 */
@property (nonatomic, copy) NSString *dueDate;

/**
 *  到店时段
 */
@property (nonatomic, copy) NSString *arriveShopTime;

/**
 *  人数
 */
@property (nonatomic, assign) NSInteger number;

/**
 *  餐厅位置。0大厅；1包间；2走廊
 */
@property (nonatomic, assign) NSInteger shopLocation;
@property (nonatomic, copy) NSString *shopLocationNote;

/// 桌号(台号)
@property (nonatomic, copy) NSString *tableNo;

/**
 *  备注
 */
@property (nonatomic, copy) NSString *note;

/**
 *  菜单明细json
 */
@property (nonatomic, copy) NSString *content;

/**
 *  菜品
 */
@property (nonatomic, strong) NSArray *foodList;

/**
 *  购物车数据，这些数据是从服务器获取到的，也就是说食客之前提交的菜品数据
 */
@property (nonatomic, strong) NSMutableArray *fixedShopingCartList;

@property (nonatomic, assign) CGFloat totalPrice;


/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *shopName;


@property (nonatomic, copy) NSString *shopAddress;

/**
 *  餐厅电话
 */
@property (nonatomic, copy) NSString *shopMobile;

/**
 *  类型。1预订就餐(预订订单)；2即时就餐(即时订单)
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  1表示点餐；2表示加菜（修改，可以 添加，可以删除）
 */
@property (nonatomic, assign) NSInteger addType;

/**
 *  0表示食客；1表示商家
 */
@property (nonatomic, assign) NSInteger userType;

@end

















