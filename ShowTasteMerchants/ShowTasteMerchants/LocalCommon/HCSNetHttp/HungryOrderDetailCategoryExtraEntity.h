//
//  HungryOrderDetailCategoryExtraEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HungryOrderDetailCategoryExtraEntity : NSObject

/// 订单项的名称
@property (nonatomic, copy) NSString *name;

/// 金额（单位：元），金额分正负，比如优惠为负，配送费为正
@property (nonatomic, assign) float price;

/// 说明(description)
@property (nonatomic, copy) NSString *desc;

/// id唯一标识这个实体（可能是活动，可能是打包费、配送费等)
@property (nonatomic, assign) NSInteger id;

/// 唯一标识该订单项目的ID
@property (nonatomic, assign) NSInteger category_id;

/// 项目类型，不同category_id下的type会不一样
@property (nonatomic, assign) NSInteger type;

/// 数量
@property (nonatomic, assign) NSInteger quantity;


#pragma mark - 美团

/// 优惠金额中美团承担的部分--美团
@property (nonatomic, assign) float mt_charge;

/// 优惠金额中商家承担的部分--美团
@property (nonatomic, assign) float poi_charge;


@end


/*
 /// 优惠金额中美团承担的部分
 @property (nonatomic, assign) float mt_charge;
 
 /// 优惠金额中商家承担的部分
 @property (nonatomic, assign) float poi_charge;
 
 /// 活动优惠金额，是美团承担活动费用和商户承担活动费用的总和
 @property (nonatomic, assign) float reduce_fee;
 
 /// 优惠说明（满10元减2.5元）
 @property (nonatomic, copy) NSString *remark;
 
 /// 活动类型
 @property (nonatomic, assign) int type;
 */



/*
 {
 "description": "",
 "price": 20,
 "name": "配送费",
 "category_id": 2,
 "id": -10,
 "quantity": 1
 }
*/

















