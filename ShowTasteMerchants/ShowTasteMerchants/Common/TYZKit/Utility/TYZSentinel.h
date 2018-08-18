//
//  TYZSentinel.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 TYZSentinel is a thread safe incrementing counter.(TYZSentinel递增计数器是线程安全的。)
 It may be used in some multi-threaded situation.(它可用于一些多线程的情况。)
 */
@interface TYZSentinel : NSObject

/**
 *  Returns the current value of the counter.
 */
@property (atomic, assign, readonly) int32_t value;

/**
 *  Increase the value atomically.
 *
 *  @return The new value.
 */
- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END


























