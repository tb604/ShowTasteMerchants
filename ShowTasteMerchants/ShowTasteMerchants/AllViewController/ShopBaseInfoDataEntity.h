//
//  ShopBaseInfoDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  餐厅基本信息
 */
@interface ShopBaseInfoDataEntity : NSObject

/**
 * 餐厅名称
 */
@property (nonatomic, copy) NSString *name;

/**
 * 口号标语
 */
@property (nonatomic, copy) NSString *slogan;

/**
 * 商圈id
 */
@property (nonatomic, assign) NSInteger mall_id;

/**
 * 商圈中文名称
 */
@property (nonatomic, copy) NSString *mall_name;

/**
 * 餐厅地址
 */
@property (nonatomic, copy) NSString *address;

/**
 * 联系电话
 */
@property (nonatomic, copy) NSString *mobile;

/**
 * 餐厅简介
 */
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) CGFloat introHeight;

/**
 *  经度
 */
@property (nonatomic, assign) double lng;

/**
 *  纬度
 */
@property (nonatomic, assign) double lat;

/**
 * 投票数
 */
@property (nonatomic, assign) NSInteger vote;

/**
 * 口味评分
 */
@property (nonatomic, assign) float score1;

/**
 * 服务评分
 */
@property (nonatomic, assign) float score2;

/**
 * 环境评分
 */
@property (nonatomic, assign) float score3;

/**
 * 人均消费
 */
@property (nonatomic, assign) float average;

/**
 * 评论次数
 */
@property (nonatomic, assign) NSInteger comments;

/**
 * 餐厅状态。0为审核；1待审核；2已审核；3已发布；4已下架
 *  0、1状态是预览功能不可用；2时，预览界面底部buttom显示为发布；3时，预览界面底部buttom显示为下架；4时，预览界面底部buttom显示为发布。
 */
@property (nonatomic, assign) NSInteger status;

/**
 * 菜系,多个用逗号隔开
 */
@property (nonatomic, copy) NSString *cx;

/**
 * 口味
 */
@property (nonatomic, copy) NSString *kw;

@end

