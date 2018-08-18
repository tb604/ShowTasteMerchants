//
//  ShopListDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/31.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  餐厅列表信息
 */
@interface ShopListDataEntity : NSObject

/**
 *  餐厅id
 */
@property (nonatomic, assign) NSInteger shop_id;

/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  餐厅口号
 */
@property (nonatomic, copy) NSString *slogan;

/**
 *  餐厅首图url
 */
@property (nonatomic, copy) NSString *image;

/**
 *  餐厅默认图片
 */
@property (nonatomic, copy) NSString *default_image;

/**
 *  经度
 */
@property (nonatomic, assign) double lng;

/**
 *  纬度
 */
@property (nonatomic, assign) double lat;

/**
 *
 */
@property (nonatomic, assign) NSInteger vip;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  餐厅简介
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  人均消费
 */
@property (nonatomic, assign) CGFloat average;

/**
 *  商圈
 */
@property (nonatomic, copy) NSString *mall_name;

/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments;

@property (nonatomic, copy) NSString *topchef_image;


/**
 *  餐厅的状态 1完成开店前三部 未发布；2上传资质，待审核；3审核失败；4审核通过；5餐厅已发布；6餐厅下架
 */
@property (nonatomic, assign) NSInteger state;

/// 员工数
@property (nonatomic, assign) NSInteger shop_employee_count;

/**
 *  餐厅分类。多个用空格隔开
 */
@property (nonatomic, copy) NSString *classify;

@property (nonatomic, copy) NSString *cx;

@property (nonatomic, copy) NSString *kw;

/**
 *  0表示没有收藏；1表示收藏了
 */
@property (nonatomic, assign) NSInteger favorite;

@property (nonatomic, copy) NSString *create_datetime;

/// 1表示自己开的餐厅；2表示有管理权限的餐厅
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, assign) BOOL selCheck;

@end

/*
 "default_image": "http://test-img.xiuwei.chinatopchef.com/xw-shop/4/2000/64d1bc08-03d8-f001-70de-044983cc2e96.jpg",
 "topchef_image": "http://test-img.xiuwei.chinatopchef.com/xw-shop/4/3000/50693f7c-3909-25e2-d484-9fd78cddf08a.jpg",
 "classify": "苏菜 浙菜"
 */

/*
 "shop_id": 32,
 "name": "夜里夏季",
 "image": "",
 "lng": "118.83",
 "lat": "32.11",
 "address": "江苏省南京市玄武区经五路89号",
 "status": 0,
 "cx": "",
 "kw": ""
*/










