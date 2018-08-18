//
//  NSThread+TYZAdd.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/3/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (TYZAdd)
/**
 Add an autorelease pool to current runloop for current thread.
 
 @discussion If you create your own thread (NSThread/pthread), and you use
 runloop to manage your task, you may use this method to add an autorelease pool
 to the runloop. Its behavior is the same as the main thread's autorelease pool.
 */
+ (void)addAutoreleasePoolToCurrentRunloop;

@end
