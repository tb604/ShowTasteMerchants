//
//  MyRestaurantDataViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "RestaurantDetailDataEntity.h"

typedef NS_ENUM(NSInteger, EN_RESTAURANT_INFO_ROWS)
{
    EN_RESTAURANT_INFO_IMAGE_ROW = 0, ///< 餐厅图片
    EN_RESTAURANT_INFO_FEATURE_ROW, ///< 餐厅名称、菜系、口号
    EN_RESTAURANT_INFO_INTRO_ROW, ///< 餐厅简介
    EN_RESTAURANT_INFO_AVERAGE_ROW, ///< 人均消费
    EN_RESTAURANT_INFO_ADDRESS_ROW, ///< 餐厅地址
    EN_RESTAURANT_INFO_MOBILE_ROW, ///< 联系电话
//    EN_RESTAURANT_INFO_PAYACCOUNT_ROW, ///< 支付账号
    EN_RESTAURANT_INFO_CHEFINFO_ROW, ///< 厨师信息
    EN_RESTAURANT_INFO_QUACERT_ROW, ///< 资质认证
    EN_RESTAURANT_INFO_MAX_ROW
};// average

// ORestQualifCertViewCell

/**
 *  餐厅资料视图控制器
 */
@interface MyRestaurantDataViewController : TYZRefreshTableViewController

/**
 *  餐厅详情信息
 */
@property (nonatomic, strong) RestaurantDetailDataEntity *detailEntity;

- (BOOL)refreshData;

- (void)refreshWithData:(id)detailEnt;

@end
