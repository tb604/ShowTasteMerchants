//
//  TYZDispatchQueuePool.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZDispatchQueuePool.h"
#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>


#define MAX_QUEUE_COUNT 32

/**
 *  调度队列的优先级
 *
 *  @param qos <#qos description#>
 *
 *  @return <#return value description#>
 */
static inline dispatch_queue_priority_t NSQualityOfServiceToDispatchPriority(NSQualityOfService qos)
{
    switch (qos)
    {
        case NSQualityOfServiceUserInteractive: // 最高优先级，主要用于提供交互UI的操作，比如处理点击事件，绘制图像到屏幕上
            return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUserInitiated: // 次高优先级，主要用于执行需要立即返回的任务
            return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUtility: // 普通优先级，主要用于不需要立即返回的任务
            return DISPATCH_QUEUE_PRIORITY_LOW;
        case NSQualityOfServiceBackground: // 后台优先级，用于完全不紧急的任务
            return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        case NSQualityOfServiceDefault: // 默认优先级，当没有设置优先级的时候，线程默认优先级
            return DISPATCH_QUEUE_PRIORITY_DEFAULT;
        default:
            return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

/*
 dispatch_queue_t q = dispatch_get_global_queue(long identifier, unsigned long flags)
 
 参数类型为：
 long identifier：ios 8.0 告诉队列执行任务的“服务质量 quality of service”，系统提供的参数有：
 
 QOS_CLASS_USER_INTERACTIVE 0x21,              用户交互(希望尽快完成，用户对结果很期望，不要放太耗时操作)
 QOS_CLASS_USER_INITIATED 0x19,                用户期望(不要放太耗时操作)
 QOS_CLASS_DEFAULT 0x15,                        默认(不是给程序员使用的，用来重置对列使用的)
 QOS_CLASS_UTILITY 0x11,                        实用工具(耗时操作，可以使用这个选项)
 QOS_CLASS_BACKGROUND 0x09,                     后台
 QOS_CLASS_UNSPECIFIED 0x00,                    未指定
 iOS 7.0 之前 优先级
 DISPATCH_QUEUE_PRIORITY_HIGH 2                 高优先级
 DISPATCH_QUEUE_PRIORITY_DEFAULT 0              默认优先级
 DISPATCH_QUEUE_PRIORITY_LOW (-2)               低优先级
 DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN  后台优先级
 */
static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos)
{
    switch (qos)
    {
        case NSQualityOfServiceUserInteractive:
            return QOS_CLASS_USER_INTERACTIVE; // 用户交互(希望尽快完成，用户对结果很期望，不要放太耗时操作)
        case NSQualityOfServiceUserInitiated:
            return QOS_CLASS_USER_INITIATED; // 用户期望(不要放太耗时操作)
        case NSQualityOfServiceUtility:
            return QOS_CLASS_UTILITY; // 实用工具(耗时操作，可以使用这个选项)
        case NSQualityOfServiceBackground:
            return QOS_CLASS_BACKGROUND; // 后台
        case NSQualityOfServiceDefault:
            return QOS_CLASS_DEFAULT; // 默认(不是给程序员使用的，用来重置对列使用的)
        default:
            return QOS_CLASS_UNSPECIFIED; // 未指定
    }
}

// 调度上下文
typedef struct
{
    const char *name;
    void **queues;
    uint32_t queueCount;
    int32_t counter;
}TYZDispatchContext;

/**
 *  创建调度上下文
 *
 *  @param name
 *  @param queueCount 数量
 *  @param qos        优先级
 *
 *  @return return value description
 */
static TYZDispatchContext *TYZDispatchContextCreate(const char *name, uint32_t queueCount, NSQualityOfService qos)
{
    // calloc 在内存的动态存储区中分配n个长度为size的连续空间calloc(size_t n, size_t size)。calloc在动态分配完内存后，自动初始化该内存空间为零，而malloc不初始化，里边数据是随机的垃圾数据。
    TYZDispatchContext *context = calloc(1, sizeof(TYZDispatchContext));
    if (!context)
    {
        return NULL;
    }
    context->queues = calloc(queueCount, sizeof(void *));
    if (!context->queues)
    {
        free(context);
        context = NULL;
        return NULL;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {// ios8以后才有的功能
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i=0; i<queueCount; i++)
        {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
            dispatch_queue_t queue = dispatch_queue_create(name, attr); // 串行queue
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    else
    {
        // 可以看出来，__bridge_retained 是编译器替我们做了 retain 操作，而 __bridge_transfer 是替我们做了 release。
        long identifier = NSQualityOfServiceToDispatchPriority(qos);
        for (NSUInteger i=0; i<queueCount; i++)
        {
            dispatch_queue_t queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL);
            /*
             它会把需要执行的任务对象指定到不同的队列中去处理，这个任务对象可以是dispatch队列，也可以是dispatch源（以后博文会介绍）。而且这个过程可以是动态的，可以实现队列的动态调度管理等等。比如说有两个队列dispatchA和dispatchB，这时把dispatchA指派到dispatchB：
             dispatch_set_target_queue(dispatchA, dispatchB);
             */
            dispatch_set_target_queue(queue, dispatch_get_global_queue(identifier, 0));
            // __bridge_retained 类型被转换时，其对象的所有权也将被变换后变量所持有
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    context->queueCount = queueCount;
    if (name)
    {
        context->name = strdup(name);
    }
    
    return context;
}

static void TYZDispatchContextRelease(TYZDispatchContext *context)
{
    if (!context)
    {
        return;
    }
    if (context->queues)
    {
        for (NSUInteger i=0; i<context->queueCount; i++)
        {
            void *queuePointer = context->queues[i];
            // 当想把本来拥有对象所有权的变量，在类型转换后，让其释放原先所有权的时候，需要使用 __bridge_transfer 关键字
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char *name = dispatch_queue_get_label(queue);
            if (name)
            {
                strlen(name); // avoid compiler warning
            }
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    if (context->name)
    {
        free((void *)context->name);
    }
}

static dispatch_queue_t TYZDispatchContextGetQueue(TYZDispatchContext *context)
{
    int32_t counter = OSAtomicIncrement32(&context->counter);
//    if (counter < 0)
//    {
//        counter = -counter;
//    }
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}

static TYZDispatchContext *TYZDispatchContextGetForQOS(NSQualityOfService qos)
{
    static TYZDispatchContext *context[5] = {0};
    switch (qos)
    {
        case NSQualityOfServiceUserInteractive:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                // 处理器数量
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1: count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[0] = TYZDispatchContextCreate("com.tb604.tyzkit.user-interactive", count, qos);
            });
            return context[0];
        } break;
        case NSQualityOfServiceUserInitiated:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[1] = TYZDispatchContextCreate("com.tb604.tyzkit.user-initiated", count, qos);
            });
            return context[1];
        } break;
        case NSQualityOfServiceUtility:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[2] = TYZDispatchContextCreate("com.tb604.tyzkit.utility", count, qos);
            });
            return context[2];
        } break;
        case NSQualityOfServiceBackground:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[3] = TYZDispatchContextCreate("com.tb604.tyzkit.background", count, qos);
            });
            return context[3];
        } break;
        case NSQualityOfServiceDefault:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : count;
                context[4] = TYZDispatchContextCreate("com.tb604.tyzkit.default", count, qos);
            });
            return context[4];
        } break;
    }
}


@implementation TYZDispatchQueuePool
{
    @public
    TYZDispatchContext *_context;
}

- (void)dealloc
{
    if (_context)
    {
        TYZDispatchContextRelease(_context);
        _context = NULL;
    }
}

- (instancetype)initWithContext:(TYZDispatchContext *)context
{
    self = [super init];
    if (!context)
    {
        return nil;
    }
    self->_context = context;
    _name = context->name ? [NSString stringWithUTF8String:context->name] : nil;
    return self;
}

- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos
{
    if (queueCount == 0 || queueCount > MAX_QUEUE_COUNT)
    {
        return nil;
    }
    self = [super init];
    _context = TYZDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
    if (!_context)
    {
        return nil;
    }
    _name = name;
    return self;
}

- (dispatch_queue_t)queue
{
    return TYZDispatchContextGetQueue(_context);
}

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos
{
    switch (qos)
    {
        case NSQualityOfServiceUserInteractive:
        {
            static TYZDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[TYZDispatchQueuePool alloc] initWithContext:TYZDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUserInitiated:
        {
            static TYZDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[TYZDispatchQueuePool alloc] initWithContext:TYZDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceUtility:
        {
            static TYZDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[TYZDispatchQueuePool alloc] initWithContext:TYZDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceBackground:
        {
            static TYZDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[TYZDispatchQueuePool alloc] initWithContext:TYZDispatchContextGetForQOS(qos)];
            });
            return pool;
        } break;
        case NSQualityOfServiceDefault:
        default:
        {
            static TYZDispatchQueuePool *pool;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pool = [[TYZDispatchQueuePool alloc] initWithContext:TYZDispatchContextGetForQOS(NSQualityOfServiceDefault)];
            });
            return pool;
        } break;
    }
}

@end

dispatch_queue_t TYZDispatchQueueGetForQOS(NSQualityOfService qos)
{
    return TYZDispatchContextGetQueue(TYZDispatchContextGetForQOS(qos));
}


























