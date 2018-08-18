//
//  TYZTransaction.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  TYZTransaction let you perform a selector once before current runloop sleep.(当前事务让你执行一次选择器之前runloop睡眠。)
 
 
 example Code:
 
 TYZTransaction *trans = [TYZTransaction transactionWithTarget:self selector:@selector(tranTar:)];
 [trans commit];
 
 - (void)tranTar:(id)sender
 {
 NSLog(@"%s", __func__);
 }
 
 */
@interface TYZTransaction : NSObject

/**
 *  Creates and returns a transaction with a specified target and selector.
 *
 *  @param target   A specified target, the target is retained until runloop end.
 *  @param selector A selector for target.
 *
 *  @return A new transaction, or nil if an error occurs.
 */
+ (nullable TYZTransaction *)transactionWithTarget:(id)target selector:(SEL)selector;

/**
 *  Commit the trancation to main runloop.
 *
 *  @discussion It will perform the selector on the target once before main runloop's current loop sleep. If the same transaction (same target and same selector) has already commit to runloop in this loop, this method do nothing.
 */
- (void)commit;


@end

NS_ASSUME_NONNULL_END

























