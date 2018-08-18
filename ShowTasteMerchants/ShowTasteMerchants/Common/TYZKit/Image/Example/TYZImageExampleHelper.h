//
//  TYZImageExampleHelper.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYZKit.h"

@interface TYZImageExampleHelper : NSObject
/// Tap to play/pause
+ (void)addTapControlToAnimatedImageView:(TYZAnimatedImageView *)view;

/// Slide to forward/rewind
+ (void)addPanControlToAnimatedImageView:(TYZAnimatedImageView *)view;

@end
