//
//  PayInfoDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  支付信息
 */
@interface PayInfoDataEntity : NSObject

/**
 *  支付类型。1支付宝；2微信
 */
@property (nonatomic, assign) NSInteger type;

/**
 *  支付名称
 */
@property (nonatomic, copy) NSString *payName;

@property (nonatomic, copy) NSString *payImageName;

/**
 *  支付账号
 */
@property (nonatomic, copy) NSString *account;

@property (nonatomic, assign) BOOL onSwitch;

@end




















