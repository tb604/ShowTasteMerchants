//
//  RestaurantChefDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  餐厅厨师信息
 */
@interface RestaurantChefDataEntity : NSObject

/**
 *  图片id
 */
@property (nonatomic, assign) NSInteger image_id;

/**
 *  厨师头像url
 */
@property (nonatomic, copy) NSString *image;

/**
 *  厨师名称
 */
@property (nonatomic, copy) NSString *name;

/**
 *  厨师职称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  厨师简介
 */
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) CGFloat introHeight;

@end



/*
 "image_id": 0,
 "image": "http://7xsdmx.com2.z0.glb.qiniucdn.com/shop/69/4001/1467544960.jpg",
 "name": "陆远",
 "title": "米其林三星",
 "intro": "哦了秃头哦魔王勇者莫有样在真魔王勇者兔子在真我兔子在真我可以找我我在学校。"
 */




















