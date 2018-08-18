//
//  RestaurantImageEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 "key": "b67800074634251804f428a68e4f83a8",
 "type": 2000,
 "name": "http://7xsdmx.com2.z0.glb.qiniucdn.com/shop/69/4001/1467544960.jpg"
 */

@interface RestaurantImageEntity : NSObject

@property (nonatomic, assign) NSInteger id;

/**
 *  图片标示
 */
@property (nonatomic, copy) NSString *key;

/**
 *  图片类型 参见七牛上传时的图片类型
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  图片地址
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger tag;

@end
