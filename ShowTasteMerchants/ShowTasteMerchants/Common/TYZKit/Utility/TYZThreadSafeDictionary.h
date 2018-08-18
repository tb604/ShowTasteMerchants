//
//  TYZThreadSafeDictionary.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A simple implementation of thread safe mutable dictionary.
 
 @discussion Generally, access performance is lower than NSMutableDictionary,
 but higher than using @synchronized, NSLock, or pthread_mutex_t.
 
 @discussion It's also compatible with the custom methods in `NSDictionary(TYZAdd)`
 and `NSMutableDictionary(TYZAdd)`
 
 @warning Fast enumerate(for...in) and enumerator is not thread safe,
 use enumerate using block instead. When enumerate or sort with block/callback,
 do *NOT* send message to the dictionary inside the block/callback.
 */
@interface TYZThreadSafeDictionary : NSMutableDictionary

@end
