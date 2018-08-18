//
//  RestaurantBaseDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  餐厅基本信息
 */
@interface RestaurantBaseDataEntity : NSObject

@property (nonatomic, assign) NSInteger shopId;

/**
 *  餐厅名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  餐厅口号标语
 */
@property (nonatomic, copy) NSString *slogan;
@property (nonatomic, assign) CGFloat sloganHeight;

/**
 *  商圈id
 */
@property (nonatomic, assign) NSInteger mall_id;

/**
 *  商圈名称
 */
@property (nonatomic, copy) NSString *mall_name;

/**
 *  餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 *  联系方式
 */
@property (nonatomic, copy) NSString *mobile;

/**
 *  餐厅简介
 */
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) CGFloat introHeight;

/**
 *  投票数
 */
@property (nonatomic, assign) NSInteger vote;

/**
 *  经度
 */
@property (nonatomic, assign) double lng;

/**
 *  纬度
 */
@property (nonatomic, assign) double lat;

/**
 *  口味评分
 */
@property (nonatomic, assign) NSInteger score1;

/**
 *  服务评分
 */
@property (nonatomic, assign) NSInteger score2;

/**
 *  环境评分
 */
@property (nonatomic, assign) NSInteger score3;

/**
 *  人均消费
 */
@property (nonatomic, assign) NSInteger average;

/**
 *  0 未认证 掌柜推荐 1 认证过的名厨推荐
 */
@property (nonatomic, assign) NSInteger vip;

/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger comments;

/**
 *  餐厅状态 0 未审核 1 待审核 2 已审核 3 已发布 4 已下架
 *  0或者1状态是预览功能不可用
 *  状态为2 时 预览界面底部bottom 显示为发布
 *  状态为3 时 预览界面底部bottom 显示为下架
 *  状态为4 时 预览界面底部bottom 显示为发布或者重新发布
 */
@property (nonatomic, assign) NSInteger state;

/**
 *  营业执照
 */
//@property (nonatomic, copy) NSString *business_lic_image;

/**
 *  卫生许可证
 */
//@property (nonatomic, copy) NSString *secure_lic_image;

/**
 *  法人身份证
 */
//@property (nonatomic, copy) NSString *master_lic_image;

/**
 *  餐厅菜品类型
 */
@property (nonatomic, copy) NSString *classify;

/**
 *  城市id
 */
@property (nonatomic, assign) NSInteger city_id;

/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *city_name;

/**
 *  0表示未收藏；1表示已收藏
 */
@property (nonatomic, assign) NSInteger favorite;



@end










































