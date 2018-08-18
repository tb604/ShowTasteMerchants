//
//  TYZGestureRecognizer.m
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation TYZGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateBegan;
    _startPoint = [(UITouch *)[touches anyObject] locationInView:self.view];
    _lastPoint = _currentPoint;
    _currentPoint = _startPoint;
    if (_action)
    {
        _action(self, TYZGestureRecognizerStateBegan);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = (UITouch *)[touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    self.state = UIGestureRecognizerStateChanged;
    _currentPoint = currentPoint;
    if (_action)
    {
        _action(self, TYZGestureRecognizerStateMoved);
    }
    _lastPoint = _currentPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateEnded;
    if (_action)
    {
        _action(self, TYZGestureRecognizerStateEnded);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateCancelled;
    if (_action)
    {
        _action(self, TYZGestureRecognizerStateCancelled);
    }
}

- (void)reset
{
    self.state = UIGestureRecognizerStatePossible;
}

- (void)cancel
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged)
    {
        self.state = UIGestureRecognizerStateCancelled;
        if (_action)
        {
            _action(self, TYZGestureRecognizerStateCancelled);
        }
    }
}

@end


























