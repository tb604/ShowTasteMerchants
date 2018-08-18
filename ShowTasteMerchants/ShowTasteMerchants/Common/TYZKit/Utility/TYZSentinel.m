//
//  TYZSentinel.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZSentinel.h"
#import <libkern/OSAtomic.h>

@implementation TYZSentinel
{
    int32_t _value;
}

- (int32_t)value
{
    return _value;
}

- (int32_t)increase
{
    return OSAtomicIncrement32(&_value);
}

@end
























