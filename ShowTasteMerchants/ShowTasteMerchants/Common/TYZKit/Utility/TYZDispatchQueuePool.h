//
//  TYZDispatchQueuePool.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TYZDispatchQueuePool_h
#define TYZDispatchQueuePool_h

NS_ASSUME_NONNULL_BEGIN

/**
 A dispatch queue pool holds multiple serial queues.
 Use this class to control queue's thread count (instead of concurrent queue).(拥有多个串行队列调度队列池。使用这个类来控制队列的线程数量(而不是并发队列)。)
 */
@interface TYZDispatchQueuePool : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE; // 设置init系统函数不可用
+ (instancetype)new UNAVAILABLE_ATTRIBUTE; // 设置new系统函数不可用

/*
 NSQualityOfService主要有5个枚举值，优先级别从高到低排布：

    NSQualityOfServiceUserInteractive：最高优先级，主要用于提供交互UI的操作，比如处理点击事件，绘制图像到屏幕上
    NSQualityOfServiceUserInitiated：次高优先级，主要用于执行需要立即返回的任务
    NSQualityOfServiceDefault：默认优先级，当没有设置优先级的时候，线程默认优先级
    NSQualityOfServiceUtility：普通优先级，主要用于不需要立即返回的任务
    NSQualityOfServiceBackground：后台优先级，用于完全不紧急的任务
 */
/**
 *  Creates and returns a dispatch queue pool.(创建并返回一个调度队列池。)
 *
 *  @param name       The name of the pool.
 *  @param queueCount Maxmium queue count, should in range (1, 32).
 *  @param qos        queue quality of service (QOS).(队列的服务质量)
 *
 *  @return A new pool, or nil if an error occurs.
 */
- (instancetype)initWithName:(nullable NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos;

/**
 *  pool's name.
 */
@property (nullable, nonatomic, assign, readonly) NSString *name;

/**
 *  Get a serial queue from pool.(得到一个串行队列从池中。)
 *
 *  @return
 */
- (dispatch_queue_t)queue;

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos;

@end

/// Get a serial queue from global queue pool with a specified qos.
extern dispatch_queue_t TYZDispatchQueueGetForQOS(NSQualityOfService qos);

NS_ASSUME_NONNULL_END

#endif


























