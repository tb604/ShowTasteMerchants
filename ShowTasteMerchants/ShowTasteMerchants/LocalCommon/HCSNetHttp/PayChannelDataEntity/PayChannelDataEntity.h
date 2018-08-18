//
//  PayChannelDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 支付渠道实体类
@interface PayChannelDataEntity : NSObject

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *desc;

/// 0表示不启用；1表示启用
@property (nonatomic, assign) NSInteger inUse;

@property (nonatomic, assign) BOOL isCheck;

@end






















