//
//  TYZTimer.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZTimer.h"
#import <pthread.h>

// __VA_ARGS_ 就是直接将括号里的...转化为实际的字符串

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);


@implementation TYZTimer
{
    BOOL _valid;
    NSTimeInterval _timeInterval;
    BOOL _repeats;
    __weak id _target;
    SEL _selector;
    dispatch_source_t _source;
    dispatch_semaphore_t _lock;
}

+ (TYZTimer *)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats
{
    return [[self alloc] initWithFireTime:interval interval:interval target:target selector:selector repeats:repeats];
}

- (instancetype)init
{
//    NSLog(@"init");
    @throw [NSException exceptionWithName:@"TYZTimer init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithFireTime:0 interval:0 target:nil selector:NULL repeats:NO];
}

- (instancetype)initWithFireTime:(NSTimeInterval)start interval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats
{
    self = [super init];
    
    /*
     dispatch_source_type_t有以下类型：
     监控进程：DISPATCH_SOURCE_TYPE_PROC,
     定时器：DISPATCH_SOURCE_TYPE_TIMER,
     从描述符中读取数据：DISPATCH_SOURCE_TYPE_READ,
     向描述符中写入字符：DISPATCH_SOURCE_TYPE_WRITE,
     监控文件系统对象:DISPATCH_SOURCE_TYPE_VNODE,.....
     */
    
    _repeats = repeats;
    _timeInterval = interval;
    _valid = YES;
    _target = target;
    _selector = selector;
    
    __weak typeof(self) _self = self;
    // 创建信号量，可以设置信号量的资源数。0表示没有资源，调用dispatch_semaphore_wait会立即等待。
    _lock = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);// dispatch_get_main_queue()
    // 创建一个调度源
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 定时器源，设置定时器信息
    /*
     第1个参数: 需要给哪个定时器设置
     第2个参数: 定时器开始的时间/DISPATCH_TIME_NOW立即执行
     第3个参数: 定时器开始之后的间隔时间
     第4个参数: 定时器间隔执行的精准度, 传入0代表最精准(尽量的让定时器精准), 传入一个大于0的值, 代表多少秒的范围是可以接受的
     第四个参数存在的意义: 主要是为了提高程序的性能
     注意点: Dispatch的定时器接收的时间是纳秒
     */
    dispatch_source_set_timer(_source, dispatch_time(DISPATCH_TIME_NOW, (start * NSEC_PER_SEC)), (interval *NSEC_PER_SEC), 0);
    
    // 定义一个事件处理器(设置回调)
    // 3.指定定时器的回调方法
    /*
     第1个参数: 需要给哪个定时器设置
     第2个参数: 需要回调的block
     */
    dispatch_source_set_event_handler(_source, ^{[_self fire];});
    // 开始处理事件(dispatch_source默认是Suspended状态，通过dispatch_resume函数开始它)
    dispatch_resume(_source);
    
    return self;
}

- (void)invalidate
{
    // dispatch_semaphore_signal发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1。
    // 等待信号
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (_valid)
    {
        dispatch_source_cancel(_source);
        _source = NULL;
        _target = nil;
        _valid = NO;
    }
    // 发送一个信号
    dispatch_semaphore_signal(_lock);
}

- (void)fire
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 等待信号，可以设置超时参数。该函数返回0表示得到通知，非0表示超时。
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id target = _target;
    if (!_repeats || !target)
    {
        // 通知信号，如果等待线程被唤醒则返回非0，否则返回0。
        dispatch_semaphore_signal(_lock);
        [self invalidate];
    }
    else
    {
        dispatch_semaphore_signal(_lock);
        [target performSelector:_selector withObject:self];
    }
#pragma clang diagnostic pop
}

- (BOOL)repeats
{
    LOCK(BOOL repeat = _repeats) return repeat;
}

- (NSTimeInterval)timeInterval
{
    LOCK(NSTimeInterval t = _timeInterval) return t;
}

- (BOOL)isValid
{
    LOCK(BOOL valid = _valid) return valid;
}

- (void)dealloc
{
//    NSLog(@"%s", __func__);
    [self invalidate];
}

@end






























