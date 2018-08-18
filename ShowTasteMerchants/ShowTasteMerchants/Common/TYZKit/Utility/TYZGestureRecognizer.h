//
//  TYZGestureRecognizer.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 TYZGestureRecognizer *tap = [[TYZGestureRecognizer alloc] initWithTarget:self action:nil];
 tap.action = ^(TYZGestureRecognizer *gesture, TYZGestureRecognizerState state)
 {
 NSLog(@"dfd=%d", state);
 };
 [self.view addGestureRecognizer:tap];
 */

NS_ASSUME_NONNULL_BEGIN

/// State of the gesture
typedef NS_ENUM(NSUInteger, TYZGestureRecognizerState)
{
    TYZGestureRecognizerStateBegan, ///< gesture start
    TYZGestureRecognizerStateMoved, ///< gesture moved
    TYZGestureRecognizerStateEnded, ///< gesture end
    TYZGestureRecognizerStateCancelled, ///< gesture cancel
};

/**
 *  A simple UIGestureRecognizer subclass for receive touch events.
 */
@interface TYZGestureRecognizer : UIGestureRecognizer
@property (nonatomic, readonly) CGPoint startPoint; ///< start point
@property (nonatomic, readonly) CGPoint lastPoint; ///< last move point.
@property (nonatomic, readonly) CGPoint currentPoint; ///< current move point.

/// The action block invoked by every gesture event.
@property (nullable, nonatomic, copy) void (^action)(TYZGestureRecognizer *gesture, TYZGestureRecognizerState state);

/// Cancel the gesture for current touch.
- (void)cancel;
@end

NS_ASSUME_NONNULL_END















