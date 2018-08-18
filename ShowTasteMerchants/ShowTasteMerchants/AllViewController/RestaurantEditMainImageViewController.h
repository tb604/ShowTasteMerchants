//
//  RestaurantEditMainImageViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "RestaurantDetailDataEntity.h"


typedef NS_ENUM(NSInteger, EN_SHOP_IMAGE_SECTIONS)
{
    EN_SHOP_IMAGE_IMAGE_SECTION = 0, ///< 形象照片
    EN_SHOP_IMAGE_HALL_SECTION, ///< 大堂照片
    EN_SHOP_IMAGE_ROOM_SECTION, ///< 包间照片
    EN_SHOP_IMAGE_LANDSCAPE_SECTION, ///< 餐厅景观照片
    EN_SHOP_IMAGE_MAX_SECTION
};// Landscape

/**
 *  餐厅组图编辑视图控制器
 */
@interface RestaurantEditMainImageViewController : TYZBaseTableViewController

/**
 *  餐厅详情
 */
@property (nonatomic, strong) RestaurantDetailDataEntity *detailEntity;


@end
