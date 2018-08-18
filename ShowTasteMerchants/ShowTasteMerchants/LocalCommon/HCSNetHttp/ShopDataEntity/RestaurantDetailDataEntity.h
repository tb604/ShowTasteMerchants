//
//  RestaurantDetailDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantBaseDataEntity.h"
#import "PayInfoDataEntity.h"
#import "RestaurantChefDataEntity.h"
#import "RestaurantImageEntity.h"
#import "RestaurantImageEntity.h"

/**
 *  餐厅详情信息
 */
@interface RestaurantDetailDataEntity : NSObject

@property (nonatomic, strong) NSArray *images;

/**
 *  餐厅信息图片
 */
@property (nonatomic, strong) NSMutableArray *shopImages;

/**
 *  餐厅基本信息
 */
@property (nonatomic, strong) RestaurantBaseDataEntity *details;

/**
 *  支付信息
 */
@property (nonatomic, strong) PayInfoDataEntity *pay;

/**
 *  主厨信息
 */
@property (nonatomic, strong) RestaurantChefDataEntity *topchef;

/**
 *  餐厅主图
 */
@property (nonatomic, strong) RestaurantImageEntity *mainImageEntity;

/**
 *  大厅图片列表(2张)
 */
@property (nonatomic, strong) NSMutableArray *hallImageList;

/**
 *  包间图片(2张)
 */
@property (nonatomic, strong) NSMutableArray *roomImageList;

/**
 *  餐厅景观图片
 */
@property (nonatomic, strong) RestaurantImageEntity *landscapeImageEntity;


/**
 * 餐厅营业执照
 */
@property (nonatomic, strong) RestaurantImageEntity *busLicImageEntity;

/**
 * 餐厅经营许可证
 */
@property (nonatomic, strong) RestaurantImageEntity *busCertImageEntity;

/**
 * 餐厅消防安全证
 */
@property (nonatomic, strong) RestaurantImageEntity *fireSafeImageEntity;

/**
 * 餐厅从业人员健康证1
 */
@property (nonatomic, strong) RestaurantImageEntity *HealthCertOneImageEntity;

/**
 * 餐厅从业人员健康证2
 */
@property (nonatomic, strong) RestaurantImageEntity *HealthCertTwoImageEntity;

@end

/*
 EN_UPLOAD_IMAGE_BUSINESS_LICENSE = 4000, ///< 餐厅营业执照 1张
 EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE, ///< 餐厅经营许可证 1张
 EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE, ///< 餐厅消防安全证 1张
 EN_UPLOAD_IMAGE_HYGIENE_LICENSE,  ///< 餐厅卫生许可证 1张
 EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE, ///< 餐厅从业人员健康证1
 EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO, ///< 餐厅从业人员健康证2
 */



















