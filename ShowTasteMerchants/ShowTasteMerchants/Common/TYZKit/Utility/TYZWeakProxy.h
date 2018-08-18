//
//  TYZWeakProxy.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A proxy used to hold a weak object.(一个代理用于持有一个弱对象)
 It can be used to avoid retain cycles, such as the target in NSTimer or CADisplayLink.(它能够避免保留循环)
 
 
 
 sample code:
 
 @implementation MyView 
 {
    NSTimer *_timer;
 }
 
 - (void)initTimer 
 {
 // 在使用NSTimer的时候，会有一个保留循环，除非使用[_timer invalidate];才能释放资源。如果使用TYZWeakProxy 就可以不用[_timer invalidate]也能释放资源。因为target采用的是weak弱引用。
    TYZWeakProxy *proxy = [TYZWeakProxy proxyWithTarget:self];
    _timer = [NSTimer timerWithTimeInterval:0.1 target:proxy selector:@selector(tick:) userInfo:nil repeats:YES];
 }
 
 - (void)tick:(NSTimer *)timer
 {
    NSLog(@"timer=%f", timer.timeInterval);
 }
 @end
 
 */
@interface TYZWeakProxy : NSProxy

/**
 *  The proxy target.
 */
@property (nullable, nonatomic, weak, readonly) id target;

/**
 *  Creates a new weak proxy for target.
 *
 *  @param target Target object.
 *
 *  @return A new proxy object.
 */
- (instancetype)initWithTarget:(id)target;

/**
 *  Creates a new weak proxy for target.
 *
 *  @param target Target object.
 *
 *  @return A new proxy object.
 */
+ (instancetype)proxyWithTarget:(id)target;



@end

NS_ASSUME_NONNULL_END



























