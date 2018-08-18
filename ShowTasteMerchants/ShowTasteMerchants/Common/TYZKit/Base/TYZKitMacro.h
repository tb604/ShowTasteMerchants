//
//  TYZKitMacro.h
//  TYZStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/time.h>
#import <pthread.h>

#ifndef TYZKitMacro_h
#define TYZKitMacro_h

#ifdef __cplusplus
#define TYZ_EXTERN_C_BEGIN  extern "C" {
#define TYZ_EXTERN_C_END  }
#else
#define TYZ_EXTERN_C_BEGIN
#define TYZ_EXTERN_C_END
#endif


TYZ_EXTERN_C_BEGIN

#ifndef TYZ_CLAMP // return the clamped value
// 如果x在low和high之间，则取x；如果x小于low，则去low；如果x大于high，则取high
#define TYZ_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef TYZ_SWAP // swap two value(交换两个值)
#define TYZ_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


#define TYZAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define TYZCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define TYZAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define TYZCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define TYZAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define TYZCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
(添加这个宏在每个类别实现之前,所以我们不需要使用-all_load或-force_load加载对象从静态库文件只包含类别和没有类。)
 More info: http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html .
 *******************************************************************************
 Example:
 TYZSYNTH_DUMMY_CLASS(NSString_TYZAdd)
 */
#ifndef TYZSYNTH_DUMMY_CLASS
#define TYZSYNTH_DUMMY_CLASS(_name_) \
@interface TYZSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation TYZSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif


/**
 synthesize a dynamic object property in @implementation scope.(合成一个动态对象属性在@ implementation范围。)
 It allows us to add custom properties to existing classes in categories.(它允许我们自定义属性添加到现有类的类别。)
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 TYZSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef TYZSYNTH_DYNAMIC_PROPERTY_OBJECT
#define TYZSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


/**
 synthesize a dynamic c type property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) CGPoint myPoint;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 TYZSYNTH_DYNAMIC_PROPERTY_CTYPE(myPoint, setMyPoint, CGPoint)
 @end
 */
#ifndef TYZSYNTH_DYNAMIC_PROPERTY_CTYPE
#define TYZSYNTH_DYNAMIC_PROPERTY_CTYPE(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
NSValue *value = [NSValue value:&object withObjCType:@encode(_type_)]; \
objc_setAssociatedObject(self, _cmd, value, OBJC_ASSOCIATION_RETAIN); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
_type_ cValue = { 0 }; \
NSValue *value = objc_getAssociatedObject(self, @selector(_setter_:)); \
[value getValue:&cValue]; \
return cValue; \
}
#endif

/**
 synthesize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
static inline NSRange TYZNSRangeFromCFRange(CFRange range)
{
    return NSMakeRange(range.location, range.length);
}

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
static inline CFRange TYZCFRangeFromNSRange(NSRange range)
{
    return CFRangeMake(range.location, range.length);
}

/**
 Same as CFAutorelease(), compatible for iOS6
 @param arg CFObject @return same as input
 */
static inline CFTypeRef TYZCFAutorelease(CFTypeRef CF_RELEASES_ARGUMENT arg)
{
    if (((long)CFAutorelease + 1) != 1)
    {
        return CFAutorelease(arg);
    }
    else
    {
        id __autoreleasing obj = CFBridgingRelease(arg);
        return (__bridge CFTypeRef)obj;
    }
}

/**
 Profile time cost.
 @param ^block     code to benchmark
 @param ^complete  code time cost (millisecond)毫秒
 
 Usage:
 TYZBenchmark(^{
 // code(执行这部分代码，)
 }, ^(double ms) {
 // 执行上面那部分代码，需要的时间
 NSLog("time cost: %.2f ms",ms);
 });
 
 */
static inline void TYZBenchmark(void (^block)(void), void (^complete)(double ms))
{
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    // t0.tv_sec秒；t0.tv_usec微妙
    struct timeval t0, t1;
    // 得到时间，它的精度可以达到微妙
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 Get compile timestamp.(编译时间戳。)
 @return A new date object set to the compile date and time.(一个新的日期对象设置为编译日期和时间。)
 */
static inline NSDate *TYZCompileTime()
{
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd TYZTYZ HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 Returns a dispatch_time delay from now.
 */
static inline dispatch_time_t dispatch_time_delay(NSTimeInterval second)
{
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
static inline dispatch_time_t dispatch_walltime_delay(NSTimeInterval second)
{
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 */
static inline dispatch_time_t dispatch_walltime_date(NSDate *date)
{
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

/**
 Whether in main queue/thread.
 */
static inline bool dispatch_is_main_queue()
{
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.(提交一个块主要为异步执行队列,并立即返回。)
 */
static inline void dispatch_async_on_main_queue(void (^block)())
{
    if (pthread_main_np())
    {// 如果在主线程中
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.(同步)
 */
static inline void dispatch_sync_on_main_queue(void (^block)())
{
    if (pthread_main_np())
    {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 Initialize a pthread mutex.(初始化一个pthread互斥锁。)
 */
static inline void pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive)
{
#define TYZMUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive)
    {
        TYZMUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    }
    else
    {
        pthread_mutexattr_t attr;
        TYZMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr)); // 初始化互斥锁属性对象
        // PTHREAD_MUTEX_RECURSIVE 如果一个线程对这种类型的互斥锁重复上锁，不会引起死锁，一个线程对这类互斥锁的多次重复上锁必须由这个线程来重复相同数量的解锁，这样才能解开这个互斥锁，别的线程才能得到这个互斥锁。如果试图解锁一个由别的线程锁定的互斥锁将会返回一个错误代码。如果一个线程试图解锁已经被解锁的互斥锁也将会返回一个错误代码。这种类型的互斥锁只能是进程私有的（作用域属性为PTHREAD_PROCESS_PRIVATE）。
        TYZMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE)); // 设置互斥锁的类型属性
        TYZMUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr)); // 创建成功返回0
        TYZMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr)); // 销毁互斥锁属性对象
    }
#undef TYZMUTEX_ASSERT_ON_ERROR
}


/**
 *  视图的宽度和高度
 *
 *  @param view 视图
 *  @param size 大小
 */
static inline void addConstraintSize(UIView *view, CGSize size)
{
    [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.width]];
    [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.height]];
}

/**
 *  设置视图的高度
 *
 *  @param view   视图
 *  @param height 高度
 *
 *  @return void
 */
static inline void addConstraintHeight(UIView *view, float height)
{
    [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height]];
}

/**
 *  设置视图的宽度
 *
 *  @param view  视图
 *  @param width 宽度
 *
 *  @return void
 */
static inline void addConstraintWdith(UIView *view, float width)
{
    [view.superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width]];
}


static inline void addConstraint(UIView *view, NSString *format, NSDictionary *metrics, NSDictionary *bindings)
{
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:bindings]];
}

// Custom Colors for my own use
#if TARGET_OS_IPHONE
#define CLEARCOLOR [UIColor clearColor]
/** 颜色，RGB数值，从0～255.0 */
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/** 颜色RGB数值 从0~1.0 */
#define RGBACOLORF(r,g,b,a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

// 16进制
#define RGBACOLORHEX(rgbValue, alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]
#elif TARGET_OS_MAC
/** 颜色，RGB数值，从0～255.0 */
#define RGBACOLOR(r,g,b,a) [NSColor colorWithDeviceRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/** 颜色RGB数值 从0~1.0 */
#define RGBACOLORF(r,g,b,a) [NSColor colorWithDeviceRed:(r) green:(g) blue:(b) alpha:(a)]
#endif

#ifndef CC_SAFE_RELEASE_NULL
/** 释放对象资源,并且负值为nil */
#define CC_SAFE_RELEASE_NULL(p)        do { if(p) { [(p) release]; (p) = nil; } } while(0)
#endif

#ifndef CC_SAFE_RELEASE
/** 释放对象资源 */
#define CC_SAFE_RELEASE(p)             do { if(p) { [(p) release]; } } while(0)
#endif

#ifndef CC_SAFE_NULL
/** 把对象负值为nil */
#define CC_SAFE_NULL(p)                do { if(p) { (p) = nil; } } while(0)
#endif

#ifndef CC_AUTORELEASE
/** 自动释放资源 */
#define CC_AUTORELEASE(p)              [(p) autorelease]
#endif

#ifndef CC_RETAIN
/** retain */
#define CC_RETAIN(p)                   [(p) retain]
#endif

#ifndef CC_COPY
#define CC_COPY(p)                      [(p) copy]
#endif

#ifndef NAVBAR_HEIGHT
#define NAVBAR_HEIGHT (44.0)
#endif

#ifndef TABBAR_HEIGHT
#define TABBAR_HEIGHT (49.0)
#endif

#ifndef STATUSBAR_HEIGHT
///< 状态条高度s
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#endif




#pragma mark - 打印日志
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s--line:%d", __func__, __LINE__)
#define debugLogFrame(frame) NSLog(@"frame[X=%.2f, Y=%.2f, W=%.2f, H=%.2f]", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)
#define debugLogSize(size) NSLog(@"size[W=%.2f, H=%.2f]", size.width, size.height)
#define debugLogPoint(point) NSLog(@"point[X=%.2f, Y=%.2f]", point.x, point.y)
#else
#define debugLog(...)
#define debugMethod()
#define debugLogFrame(frame)
#define debugLogSize(size)
#define debugLogPoint(point)
#endif


#pragma mark - 把CGRect、CGPoint、CGSize转换为字符串
#if TARGET_OS_IPHONE  // ios
#define RECTSTRING(_aRect_)         NSStringFromCGRect(_aRect_)
#define POINTSTRING(_aPoint_)       NSStringFromCGPoint(_aPoint_)
#define SIZESTRING(_aSize_)         NSStringFromCGSize(_aSize_)
#elif TARGET_OS_MAC
#define RECTSTRING(_aRect_)         NSStringFromRect(_aRect_)
#define POINTSTRING(_aPoint_)       NSStringFromPoint(_aPoint_)
#define SIZESTRING(_aSize_)         NSStringFromSize(_aSize_)
#endif


// ---auto Layout 一些宏--

// 设置为使用auto Layout
#define PREPCONSTRAINTS(VIEW) \
[VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

/**
 *  设置可以layout布局
 *
 *  @param view 视图
 *
 *  @return void
 */
static inline void setTranslatesAutoresizingMaskIntoConstraints(UIView *view)
{
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
}


#define CONSTRAINT_ATTRIBUTE(aVIEW, bVIEW, layoutAttribute, CONSTANT) \
[NSLayoutConstraint constraintWithItem:aVIEW attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:bVIEW attribute:layoutAttribute multiplier:1.0 constant:CONSTANT]



#pragma mark - Centering

// aVIEW视图在bVIEW视图的水平中心点
#define CONSTRAINT_CENTERING_TWO_H(aVIEW, bVIEW) [NSLayoutConstraint constraintWithItem: aVIEW attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: bVIEW attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: 0.0f]
/**
 *  aVIEW视图在bVIEW视图的水平中心点
 *
 *  @param aVIEW aVIEW
 *  @param bVIEW bVIEW
 *
 *  @return void
 */
static inline void constraint_centering_two_h(UIView *aVIEW, UIView *bVIEW)
{
    [NSLayoutConstraint constraintWithItem: aVIEW attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: bVIEW attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: 0.0f];
}

// aVIEW视图在bVIEW视图的垂直中心点
#define CONSTRAINT_CENTERING_TWO_V(aVIEW, bVIEW) [NSLayoutConstraint constraintWithItem: aVIEW attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: bVIEW attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f]

/**
 *  aVIEW视图在bVIEW视图的垂直中心点
 *
 *  @param aVIEW aVIEW
 *  @param bVIEW bVIEW
 *
 *  @return void
 */
static inline void constraint_centering_two_v(UIView *aVIEW, UIView *bVIEW)
{
    [NSLayoutConstraint constraintWithItem: aVIEW attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: bVIEW attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f];
}

// 表示在父视图的水平中心
#define CONSTRAINT_CENTERING_H(VIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeCenterX multiplier: 1.0f constant: 0.0f]

// 表示在父视图的的垂直中心
#define CONSTRAINT_CENTERING_V(VIEW) [NSLayoutConstraint constraintWithItem: VIEW attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: [VIEW superview] attribute: NSLayoutAttributeCenterY multiplier: 1.0f constant: 0.0f]

// 在父视图的中心点
#define CONSTRAINTS_CENTERING(VIEW) \
@[CONSTRAINT_CENTERING_H(VIEW), CONSTRAINT_CENTERING_V(VIEW)]



// 字的大小
#ifndef FONTSIZE
#define FONTSIZE(font) [UIFont systemFontOfSize:font]
#define FONTSIZE_9 FONTSIZE(9)
#define FONTSIZE_10 FONTSIZE(10)
#define FONTSIZE_11 FONTSIZE(11)
#define FONTSIZE_12 FONTSIZE(12)
#define FONTSIZE_13 FONTSIZE(13)
#define FONTSIZE_14 FONTSIZE(14)
#define FONTSIZE_15 FONTSIZE(15)
#define FONTSIZE_16 FONTSIZE(16)
#define FONTSIZE_17 FONTSIZE(17)
#define FONTSIZE_18 FONTSIZE(18)
#define FONTSIZE_19 FONTSIZE(19)
#define FONTSIZE_20 FONTSIZE(20)

#endif
#ifndef FONTBOLDSIZE
#define FONTBOLDSIZE(font) [UIFont boldSystemFontOfSize:font]
#define FONTBOLDSIZE_9 FONTBOLDSIZE(9)
#define FONTBOLDSIZE_10 FONTBOLDSIZE(10)
#define FONTBOLDSIZE_11 FONTBOLDSIZE(11)
#define FONTBOLDSIZE_12 FONTBOLDSIZE(12)
#define FONTBOLDSIZE_13 FONTBOLDSIZE(13)
#define FONTBOLDSIZE_14 FONTBOLDSIZE(14)
#define FONTBOLDSIZE_15 FONTBOLDSIZE(15)
#define FONTBOLDSIZE_16 FONTBOLDSIZE(16)
#define FONTBOLDSIZE_17 FONTBOLDSIZE(17)
#define FONTBOLDSIZE_18 FONTBOLDSIZE(18)
#define FONTBOLDSIZE_19 FONTBOLDSIZE(19)
#define FONTBOLDSIZE_20 FONTBOLDSIZE(20)
#endif


/**
 *  判断对象是否为空，如果为空就为“”
 *
 *  @param obj
 *
 *  @return
 */
static inline id objectNull(id obj)
{
    return (obj==nil?@"":obj);
}


// GCD
/*
 example code:
 void (^block)() = ^()
 {
 NSLog(@"dfd");
 };
 GCD_ASYNC_BACK(block);
 */
#define GCD_ASYNC_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_SYNC_BACK(block) dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_ASYNC_MAIN(block) dispatch_async(dispatch_get_main_queue(), block)
#define GCD_SYNC_MAIN(block) dispatch_sync(dispatch_get_main_queue(), block)


/** 当前版本号 */
#define kLocalCurVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]


TYZ_EXTERN_C_END


#endif /* TYZKitMacro_h */



























