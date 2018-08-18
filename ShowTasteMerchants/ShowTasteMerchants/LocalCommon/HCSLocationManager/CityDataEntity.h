//
//  CityDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDataEntity : NSObject

/*
 "city_id": 1,
 "city_name": "南京",
 "first_letter": "",
 "letter_short": "",
 "letter_full": "",
 "parent_city_id": 1
 */

@property (nonatomic, copy) NSString *address;
/**
 *  电话区号，如：南京025
 */
@property (nonatomic, copy) NSString *vtg_city_code;

/**
 *  城市id
 */
@property (nonatomic, assign) NSInteger city_id;

/**
 *  城市名称
 */
@property (nonatomic, copy) NSString *city_name;

/**
 *  英文城市名称
 */
@property (nonatomic, copy) NSString *vtg_city_enname;

/**
 *  城市名称拼音首字母
 */
@property (nonatomic, copy) NSString *first_letter;

/**
 *  城市名称拼音首字母组合
 */
@property (nonatomic, copy) NSString *letter_short;

/**
 *  城市名称全拼
 */
@property (nonatomic, copy) NSString *letter_full;

/**
 *  父级城市ID
 */
@property (nonatomic, assign) NSInteger parent_city_id;

/*
 city_id             城市ID
 city_name           城市名称
 first_letter        城市名称拼音首字母
 letter_short        城市名称拼音首字母组合
 letter_full         城市名称全拼
 parent_city_id      父级城市ID
 */

@property (nonatomic, copy) NSString *prefixLetter;

@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) double latitude;

@property (nonatomic, copy) NSString *lyPrefixLetter;

@property (nonatomic, assign) int lyId;

/**
 *  导游抢单，是否开通城市，0未开通；1已开通
 */
@property (nonatomic, assign) NSInteger  guideFlag;

// <city><id>229</id><name>无锡</name><enName>Wuxi</enName><prefixLetter>W</prefixLetter></city>


@end
