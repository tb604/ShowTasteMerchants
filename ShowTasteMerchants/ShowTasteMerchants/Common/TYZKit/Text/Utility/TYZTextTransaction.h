//
//  TYZTextTransaction.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Creates and returns a transaction with a specified target and selector.
 */
@interface TYZTextTransaction : NSObject

/**
 *  Creates and returns a transaction with a specified target and selector.
 *
 *  @param target   A specified target, the target is retained until runloop end.
 *  @param selector A selector for target.
 *
 *  @return A new transaction, or nil if an error occurs.
 */
+ (TYZTextTransaction *)transactionWithTarget:(id)target selector:(SEL)selector;

/**
 *  Commit the transcation to main runloop.
 *  @discussion It wil perform the selector on the target once before main runloop's current loop sleep. If the same transcation (same target and same selector) has already commit to runloop in this loop, this method do nothing.
 */
- (void)commit;

@end

NS_ASSUME_NONNULL_END















