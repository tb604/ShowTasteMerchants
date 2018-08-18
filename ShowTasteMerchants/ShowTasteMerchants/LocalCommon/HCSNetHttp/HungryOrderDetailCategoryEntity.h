//
//  HungryOrderDetailCategoryEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrderDetailCategoryExtraEntity.h"
#import "HungryOrderFoodEntity.h"

/**
 *  订单详情类目
 */
@interface HungryOrderDetailCategoryEntity : NSObject

/// 自己重新组装的
@property (nonatomic, strong) NSMutableArray *newgroups;

/// group是篮子的概念，用户一次下单可以有多个篮子，最后一起结算，所有group里会有array嵌套。应用在饿了么的「多人拼单」功能等。
@property (nonatomic, strong) NSArray *group;

@property (nonatomic, strong) NSMutableArray *newextra;
/// extra数组中其中一个元素
@property (nonatomic, strong) NSArray *extra;

@property (nonatomic, strong) id abandoned_extra;

@end










