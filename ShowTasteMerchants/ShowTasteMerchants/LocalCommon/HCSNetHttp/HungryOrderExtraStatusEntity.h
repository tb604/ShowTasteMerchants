//
//  HungryOrderExtraStatusEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HungryOrderExtraStatusEntity : NSObject

/// 订单取消原因类型
@property (nonatomic, assign) NSInteger invalid_type;

/// description
@property (nonatomic, copy) NSString *desc;

@end






















