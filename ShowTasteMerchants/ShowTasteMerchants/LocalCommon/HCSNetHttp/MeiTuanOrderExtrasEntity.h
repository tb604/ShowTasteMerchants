//
//  MeiTuanOrderExtrasEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeiTuanOrderExtrasEntity : NSObject

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

@end

/*
 {\"mt_charge\":0,\"poi_charge\":5,\"reduce_fee\":0,\"remark\":\"满38.0元赠随机饮料*1\",\"type\":5}
 */





















