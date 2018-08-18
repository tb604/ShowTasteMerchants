//
//  NSNumber+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Provide a method to parse `NSString` for `NSNumber`.
 */
@interface NSNumber (TYZAdd)
/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...
 
 @param string  The string described an number.
 
 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

/**
 *  数字太大，转化，当数字超过9999时，转换为1.0f万
 *
 *  @return
 */
- (NSString *)bigNumberFormat;

/** 将字节转换为KB/MB/GB */
- (NSString *)bytesToAvaiUnit;

/**
 *  把米转换为千米
 */
- (NSString *)meterToKilometer;

/**
 *  将字节转化MB
 */
- (NSString *)bytesToAvaiUnitMB;

/**
 *  将字节转换为KB/MB/GB
 *
 *  @return 
 */
- (NSString *)kbToAvaiUnit;

/** 返回 分:秒 */
- (NSString *)TimeformatFromSeconds;

/** 返回 时:分:秒 */
- (NSString *)TimeHourformatFromSeconds;


@end

NS_ASSUME_NONNULL_END


























