//
//  TYZTimer.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  TYZTimer is a thread-safe timer based on GCD. It has similar API with 'NSTimer'.
    TYZTimer object differ from NSTimer in a few ways:
 
 *  It use GCD to produce timer tick, and won't be affected by runLoop.(使用GCD生成计时器滴答,runLoop不会受到影响。)
 *  It make a weak reference to the target, so it can avoid retain cycles.(目标做一个弱引用,因此可以避免保留周期。)
 *  It always fire on background thread.(它总是后台线程开火。)
 */
@interface TYZTimer : NSObject

+ (TYZTimer *)timerWithTimeInterval:(NSTimeInterval)interval
                             target:(id)target
                           selector:(SEL)selector
                            repeats:(BOOL)repeats;


- (instancetype)initWithFireTime:(NSTimeInterval)start
                        interval:(NSTimeInterval)interval
                          target:(id)target
                        selector:(SEL)selector
                         repeats:(BOOL)repeats NS_DESIGNATED_INITIALIZER;

@property (atomic, assign, readonly) BOOL repeats;

@property (atomic, assign, readonly) NSTimeInterval timeInterval;

@property (atomic, assign, readonly, getter=isValid) BOOL valid;

/**
 *  无效
 */
- (void)invalidate;

- (void)fire;

@end

NS_ASSUME_NONNULL_END



























