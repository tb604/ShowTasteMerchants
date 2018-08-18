//
//  TYZReachability.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZReachability.h"
#import <objc/message.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

/*
 SCNetworkReachabilityFlags：保存返回的测试连接状态
 其中常用的状态有：
 kSCNetworkReachabilityFlagsReachable：能够连接网络
 kSCNetworkReachabilityFlagsConnectionRequired：能够连接网络，但是首先得建立连接过程
 kSCNetworkReachabilityFlagsIsWWAN：判断是否通过蜂窝网覆盖的连接，比如EDGE，GPRS或者目前的3G.主要是区别通过WiFi的连接。
 */

static TYZReachabilityStatus TYZReachabilityStatusFromFlags(SCNetworkReachabilityFlags flags, BOOL allowWWAN)
{
//    NSLog(@"flags=%d; allowWWAN=%d", flags, allowWWAN);
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return TYZReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) && (flags & kSCNetworkReachabilityFlagsTransientConnection))
    {
        return TYZReachabilityStatusNone;
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) && allowWWAN)
    {
        return TYZReachabilityStatusWWAN;
    }
    
    return TYZReachabilityStatusWiFi;
}

static void TYZReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
    TYZReachability *self = ((__bridge TYZReachability *)info);
    if (self.notifyBlock)
    {
        // 异步
        dispatch_async(dispatch_get_main_queue(), ^{
            self.notifyBlock(self);
        });
    }
}

@interface TYZReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef ref;


@property (nonatomic, assign) BOOL scheduled;

/**
 *  允许无线广域网
 */
@property (nonatomic, assign) BOOL allowWWAN;

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;
@end

@implementation TYZReachability

- (void)dealloc
{
//    NSLog(@"%s", __func__);
    self.notifyBlock = nil;
    self.scheduled = NO;
    if (_ref)
    {
        CFRelease(_ref), _ref = NULL;
    }
}

+ (dispatch_queue_t)sharedQueue
{
    /*
     1. dispatch_queue_t queue = dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL); //生成一个串行队列，队列中的block按照先进先出（FIFO）的顺序去执行，实际上为单线程执行。第一个参数是队列的名称，在调试程序时会非常有用，所有尽量不要重名了。
     
     2. dispatch_queue_t queue = dispatch_queue_create("com.dispatch.concurrent", DISPATCH_QUEUE_CONCURRENT); //生成一个并发执行队列，block被分发到多个线程去执行
     
     3. dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //获得程序进程缺省产生的并发队列，可设定优先级来选择高、中、低三个优先级队列。由于是系统默认生成的，所以无法调用dispatch_resume()和dispatch_suspend()来控制执行继续或中断。需要注意的是，三个队列不代表三个线程，可能会有更多的线程。并发队列可以根据实际情况来自动产生合理的线程数，也可理解为dispatch队列实现了一个线程池的管理，对于程序逻辑是透明的。
     
     官网文档解释说共有三个并发队列，但实际还有一个更低优先级的队列，设置优先级为DISPATCH_QUEUE_PRIORITY_BACKGROUND。Xcode调试时可以观察到正在使用的各个dispatch队列。
     
     4. dispatch_queue_t queue = dispatch_get_main_queue(); //获得主线程的dispatch队列，实际是一个串行队列。同样无法控制主线程dispatch队列的执行继续或中断。
     */
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 生成一个串行队列，队列中的block按照先进先出（FIFO）的顺序去执行，实际上为单线程执行。第一个参数是队列的名称，在调试程序时会非常有用，所有尽量不要重名了。
        queue = dispatch_queue_create("com.tangbin.tyzkit.reachability", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

- (instancetype)init
{
    struct sockaddr_in zero_addr;
    bzero(&zero_addr, sizeof(zero_addr));
    zero_addr.sin_len = sizeof(zero_addr);
    zero_addr.sin_family = AF_INET;
    // 创建测试连接的引用
    // 根据传入的地址测试连接，第一个参数可以为NULL或kCFAllocatorDefault，第二个参数为需要测试连接的IP地址，当为0.0.0时，则可以查询本机的网络连接状态。同时返回一个引用必须在用完后释放。
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zero_addr);
    return [self initWithRef:ref];
}

- (instancetype)initWithRef:(SCNetworkReachabilityRef)ref
{
    if (!ref)
    {
        return nil;
    }
    self = [super init];
    if (self)
    {
        _ref = ref;
        _allowWWAN = YES;
        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
        {
            _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        }
    }
    return self;
}

- (void)setScheduled:(BOOL)scheduled
{
//    NSLog(@"scheduled=%d", scheduled);
    if (_scheduled == scheduled)
    {
        return;
    }
    _scheduled = scheduled;
    if (scheduled)
    {
        SCNetworkReachabilityContext context = { 0, (__bridge void *)self, NULL, NULL, NULL };
        // SCNetworkReachabilitySetCallback函数为指定一个target(此处为reachabilityRef，即www.apple.com，在reachabilityWithhostName里设置的)
        // 当设备对于这个target连接状态发生改变时(比如断开连接，或者重新连接上)，则回调TYZReachabilityCallback函数。
        SCNetworkReachabilitySetCallback(self.ref, TYZReachabilityCallback, &context);
        SCNetworkReachabilitySetDispatchQueue(self.ref, [[self class] sharedQueue]);
//        SCNetworkReachabilityScheduleWithRunLoop(_ref, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
    else
    {
        SCNetworkReachabilitySetDispatchQueue(self.ref, NULL);
    }
}

- (SCNetworkReachabilityFlags)flags
{
    SCNetworkReachabilityFlags flags = 0;
    // 确定连接的状态，这个函数用来获得测试连接的状态，第一个参数为之前建立的测试连接的引用，第二个参数用来保存获得的状态，如果能获得状态则返回TRUE，否则返回FALSE
    SCNetworkReachabilityGetFlags(self.ref, &flags);
    return flags;
}

- (TYZReachabilityStatus)status
{
    return TYZReachabilityStatusFromFlags(self.flags, self.allowWWAN);
}

- (TYZReachabilityWWANStatus)wwanStatus
{
    if (!self.networkInfo) return TYZReachabilityWWANStatusNone;
    NSString *status = self.networkInfo.currentRadioAccessTechnology;
//    NSLog(@"status=%@", status);
    if (!status) return TYZReachabilityWWANStatusNone;
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{CTRadioAccessTechnologyGPRS : @(TYZReachabilityWWANStatus2G),  // 2.5G   171Kbps
                CTRadioAccessTechnologyEdge : @(TYZReachabilityWWANStatus2G),  // 2.75G  384Kbps
                CTRadioAccessTechnologyWCDMA : @(TYZReachabilityWWANStatus3G), // 3G     3.6Mbps/384Kbps
                CTRadioAccessTechnologyHSDPA : @(TYZReachabilityWWANStatus3G), // 3.5G   14.4Mbps/384Kbps
                CTRadioAccessTechnologyHSUPA : @(TYZReachabilityWWANStatus3G), // 3.75G  14.4Mbps/5.76Mbps
                CTRadioAccessTechnologyCDMA1x : @(TYZReachabilityWWANStatus3G), // 2.5G
                CTRadioAccessTechnologyCDMAEVDORev0 : @(TYZReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevA : @(TYZReachabilityWWANStatus3G),
                CTRadioAccessTechnologyCDMAEVDORevB : @(TYZReachabilityWWANStatus3G),
                CTRadioAccessTechnologyeHRPD : @(TYZReachabilityWWANStatus3G),
                CTRadioAccessTechnologyLTE : @(TYZReachabilityWWANStatus4G)}; // LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
    });
    NSNumber *num = dic[status];
    if (num)
        return num.unsignedIntegerValue;
    else
        return TYZReachabilityWWANStatusNone;
}

- (BOOL)isReachable
{
    return self.status != TYZReachabilityStatusNone;
}

+ (instancetype)reachability
{
    return [self new];
}

/**
 *  检测当前网络能够连接上internet
 *
 *  @return
 */

+ (instancetype)reachabilityForLocalWifi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
    TYZReachability *one = [self reachabilityWithAddress:(const struct sockaddr *)&localWifiAddress];
    one.allowWWAN = NO;
    return one;
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostname
{
//    NSLog(@"%s", __func__);
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    return [[self alloc] initWithRef:ref];
}

+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)hostAddress);
    return [[self alloc] initWithRef:ref];
}

- (void)setNotifyBlock:(void (^)(TYZReachability *reachability))notifyBlock
{
    _notifyBlock = [notifyBlock copy];
    self.scheduled = (self.notifyBlock != nil);
}


@end




























