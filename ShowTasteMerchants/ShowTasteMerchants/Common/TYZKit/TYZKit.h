//
//  TYZKit.h
//  来源于<https://github.com/ibireme/YYKit> 感谢
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#ifndef TYZKit_h
#define TYZKit_h

// 为 NSObject+YYAddForARC.m 和 NSThread+YYAdd.m 添加编译参数 -fno-objc-arc。

// 注意: carthage framework 并没有包含 webp 组件。如果你需要支持 webp，可以用 CocoaPods 安装，或者手动安装。

#import "TYZKitMacro.h"
// Utility
#import "TYZReachability.h"
#import "TYZGestureRecognizer.h"
#import "TYZWeakProxy.h"
#import "TYZFileHash.h"
#import "TYZTimer.h"
#import "TYZTransaction.h"
#import "TYZAsyncLayer.h"
#import "TYZSentinel.h"
#import "TYZDispatchQueuePool.h"
#import "TYZThreadSafeArray.h"
#import "TYZThreadSafeDictionary.h"

// Base
#import "NSArray+TYZAdd.h"
#import "NSDictionary+TYZAdd.h"
#import "NSData+TYZAdd.h"
#import "NSObject+TYZAdd.h"
#import "NSObject+TYZAddForKVO.h"
#import "NSString+TYZAdd.h"
#import "NSNumber+TYZAdd.h"
#import "NSDate+TYZAdd.h"
#import "NSNotificationCenter+TYZAdd.h"
#import "NSKeyedUnarchiver+TYZAdd.h"
#import "NSTimer+TYZAdd.h"
#import "NSFileManager+TYZAdd.h"
#import "NSBundle+TYZAdd.h"
#import "NSThread+TYZAdd.h" // This file must be compiled without ARC. Specify the -fno-objc-arc flag to this file.
#import "ALAssetsLibrary+TYZAdd.h"

// UIKit
#import "UIDevice+TYZAdd.h"
#import "UIScreen+TYZAdd.h"
#import "UIApplication+TYZAdd.h"
#import "UIColor+TYZAdd.h"
#import "UIView+TYZAdd.h"
#import "UIBarButtonItem+TYZAdd.h"
#import "UIGestureRecognizer+TYZAdd.h"
#import "UIScrollView+TYZAdd.h"
#import "UITableView+TYZAdd.h"
#import "UITextField+TYZAdd.h"
#import "UIFont+TYZAdd.h"
#import "UIBezierPath+TYZAdd.h"
#import "UIControl+TYZAdd.h"
#import "UIImage+TYZAdd.h"
#import "TYZAlertAction.h"
#import "UIImageView+TYZAdd.h"

// Quartz
#import "CALayer+TYZAdd.h"
#import "TYZCGUtilityes.h"

// Cache
#import "TYZCache.h"
#import "TYZMemoryCache.h"
#import "TYZDiskCache.h"
#import "TYZKVStorage.h"


// Model
#import "TYZClassInfo.h"
#import "NSObject+TYZModel.h"


// Image
#import "TYZImage.h"
#import "TYZAnimatedImageView.h"
#import "TYZImageCoder.h"
#import "TYZFrameImage.h"
#import "TYZSpriteSheetImage.h"

// Text
#import "TYZTextUtilities.h"
#import "UIView+TYZText.h"
#import "TYZTextTransaction.h"

#endif /* TYZKit_h */
