//
//  NSNumber+TYZAdd.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "NSNumber+TYZAdd.h"
#import "NSString+TYZAdd.h"
#import "TYZKitMacro.h"

TYZSYNTH_DUMMY_CLASS(NSNumber_TYZAdd)

@implementation NSNumber (TYZAdd)

+ (NSNumber *)numberWithString:(NSString *)string
{
    NSString *str = [[string stringByTrim] lowercaseString];
    if (!str || !str.length)
    {
        return nil;
    }
    
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{@"true" :   @(YES),
                @"yes" :    @(YES),
                @"false" :  @(NO),
                @"no" :     @(NO),
                @"nil" :    [NSNull null],
                @"null" :   [NSNull null],
                @"<null>" : [NSNull null]};
    });
    id num = dic[str];
    if (num)
    {
        if (num == [NSNull null]) return nil;
        return num;
    }
    
    // hex number
    int sign = 0;
    if ([str hasPrefix:@"0x"]) sign = 1;
    else if ([str hasPrefix:@"-0x"]) sign = -1;
    if (sign != 0)
    {
        NSScanner *scan = [NSScanner scannerWithString:str];
        unsigned num = -1;
        BOOL suc = [scan scanHexInt:&num];
        if (suc)
            return [NSNumber numberWithLong:((long)num * sign)];
        else
            return nil;
    }
    // normal number
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter numberFromString:string];
}

/**
 *  数字太大，转化
 *
 *  @return
 */
- (NSString *)bigNumberFormat
{
    long long bignum = [self longLongValue];
    if (bignum < 9999)
    {
        return [NSString stringWithFormat:@"%lld", bignum];
    }
    else if (bignum >= 10000 && bignum < 99999999)
    {
        return [NSString stringWithFormat:@"%.1f万", (double)bignum / 10000];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1f亿", (double)bignum / (10000*10000)];
    }
}

/** 将字节转换为MB */
- (NSString *)bytesToAvaiUnit
{
    long long bytes = [self longLongValue];
    if(bytes < 1024)     // B
    {
        return [NSString stringWithFormat:@"%lldB", bytes];
    }
    else if(bytes >= 1024 && bytes < 1024 * 1024) // KB
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
    }
    else if(bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

/**
 *  把米转换为千米
 */
- (NSString *)meterToKilometer
{
    double meter = [self doubleValue];
    NSString *strMeter = nil;
    if (meter < 1000)
    {
        strMeter = [NSString stringWithFormat:@"%.0fm", meter];
    }
    else if (meter >= 1000 && meter < 10000)
    {
        strMeter = [NSString stringWithFormat:@"%.2fkm", meter / 1000];
    }
    else
    {
        strMeter = [NSString stringWithFormat:@"%.0fkm", meter / 1000];
    }
    return strMeter;
}

/**
 *  将字节转化MB
 */
- (NSString *)bytesToAvaiUnitMB
{
    long long bytes = [self longLongValue];
    return [NSString stringWithFormat:@"%.2fM", (double)bytes / (1024 * 1024)];
}

- (NSString *)kbToAvaiUnit
{
    long long sizekb = [self longLongValue];
    if (sizekb < 1024)
    {
        return [NSString stringWithFormat:@"%.1fKB", (double)sizekb];
    }
    else if(sizekb >= 1024 * 1024 && sizekb < 1024 * 1024 * 1024)   // MB
    {
        return [NSString stringWithFormat:@"%.2fMB", (double)sizekb / (1024 * 1024)];
    }
    else    // GB
    {
        return [NSString stringWithFormat:@"%.3fGB", (double)sizekb / (1024 * 1024 * 1024)];
    }
}

/** 返回 分:秒 */
- (NSString *)TimeformatFromSeconds
{
    long seconds = [self longValue];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

/** 返回 时:分:秒 */
- (NSString *)TimeHourformatFromSeconds
{
    long seconds = [self longValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute,str_second];
    return format_time;
}


@end




























