//
//  OpenRestaurantInfoViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZRefreshTableViewController.h"
#import "OpenRestaurantInputEntity.h"
#import "RestaurantDetailDataEntity.h"


typedef NS_ENUM(NSInteger, EN_OPRT_INFO_SECTIONS)
{
    EN_OPRT_INFO_RESTIMAGE_SECTION = 0, ///< 餐厅图片
    EN_OPRT_INFO_BASEDATA_SECTION, ///< 基本资料
//    EN_OPRT_INFO_ACCOUNT_SECTION, ///< 支付账号设置
    EN_OPRT_INFO_COOKINFO_SECTION, ///< 厨师信息
    EN_OPRT_INFO_QUACERT_SECTION, ///< 资质认证
    EN_OPRT_INFO_MAX_SECTION
};

// 餐厅图片
typedef NS_ENUM(NSInteger, EN_OPRT_INFO_RESTIMAGE_ROWS)
{
    EN_OPRT_INFO_RESTIMAGE_ROW = 0, ///< 餐厅图片
    EN_OPRT_INFO_RESTIMAGE_MAX_ROW
};

// 基本资料
typedef NS_ENUM(NSInteger, EN_OPRT_INFO_BASEDATA_ROWS)
{
    EN_OPRT_INFO_BD_NAME_ROW = 0, ///< 餐厅名字
    EN_OPRT_INFO_BD_RECOMMENDWORD_ROW,       ///< 餐厅推荐词
    EN_OPRT_INFO_BD_BUSC_ROW,           ///< 商圈
    EN_OPRT_INFO_BD_ADDRESS_ROW,    ///< 地址
    EN_OPRT_INFO_BD_MOBILE_ROW, ///< 联系方式
    EN_OPRT_INFO_BD_INTRO_ROW, ///< 餐厅介绍
    EN_OPRT_INFO_BD_AVERAGE_ROW, ///< 人均消费
    EN_OPRT_INFO_BASEDATA_MAX_ROW
};

// 账号设置
/*typedef NS_ENUM(NSInteger, EN_OPRT_INFO_ACCOUNT_ROWS)
{
    EN_OPRT_INFO_THIRD_ACCOUNT_ROW = 0, ///< 第三方支付账号
    EN_OPRT_INFO_ACCOUNT_MAX_ROW
};*/

// 总厨信息
typedef NS_ENUM(NSInteger, EN_OPRT_INFO_COOKINFO_ROWS)
{
    EN_OPRT_INFO_COOKINFO_ROW = 0, ///< 总厨信息
    EN_OPRT_INFO_COOKINFO_MAX_ROW
};


// 资质认证
typedef NS_ENUM(NSInteger, EN_OPRT_INFO_QUACERT_ROWS)
{
    EN_OPRT_INFO_QUACERT_BUSLIC_ROW = 0, ///< 营业执照
//    EN_OPRT_INFO_QUACERT_HYGLIC_ROW, ///< 卫生许可证
//    EN_OPRT_INFO_QUACERT_LPIDCARD_ROW, ///< 法人身份证
    EN_OPRT_INFO_QUACERT_MAX_ROW
};





/**
 *  餐厅信息视图控制器
 */
@interface OpenRestaurantInfoViewController : TYZRefreshTableViewController


@property (nonatomic, strong) OpenRestaurantInputEntity *inputEntity;

/**
 *  餐厅详情
 */
@property (nonatomic, strong) RestaurantDetailDataEntity *detailEntity;

@end


















