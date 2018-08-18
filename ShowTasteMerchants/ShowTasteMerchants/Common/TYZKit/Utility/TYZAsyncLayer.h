//
//  TYZAsyncLayer.h
//  YYStudyDemo
//
//  Created by 唐斌 on 16/2/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/QuartzCore.h>

@class TYZAsyncLayerDisplayTask;


NS_ASSUME_NONNULL_BEGIN

/**
 *  The TYZAsyncLayer class is a subclass of CALayer used for render contents asynchronously.
 
 * @discussion When the layer need update it's contents, it will ask the delegate for a async display task to render the contents in a background queue.
 */
@interface TYZAsyncLayer : CALayer // 异步层

/**
 *  Whether the render code is executed in background. Ddefault is YES.(渲染代码是否在后台执行。默认是YES。)
 */
@property (atomic, assign) BOOL displayAsynchronously;

@end

/**
 *  The TYZAsyncLayer's delegate protocol. The delegate of the TYZAsyncLayer(typically a UIView) must implements the method in this protocol.
 */
@protocol TYZAsyncLayerDelegate <NSObject>

@required
/**
 *  This method is called to return a new display task when the layer's contents need update.(调用此方法时返回一个新的显示任务层的内容需要更新。)
 *
 *  @return
 */
- (TYZAsyncLayerDisplayTask *)newAsyncDisplayTask;

@end

/**
 *  A display task used by TYZAsyncLayer to render the contents in background queue.(显示任务TYZAsyncLayer用来渲染背景队列的内容。)
 */
@interface TYZAsyncLayerDisplayTask : NSObject

/**
 *  This block will be called before the asynchronous drawing begins. It will be called on the main thread.
 *  @param layer The layer.
 */
@property (nullable, nonatomic, copy) void (^willDisplay)(CALayer *layer);

/**
 This block is called to draw the layer's contents.
 
 @discussion This block may be called on main thread or background thread,
 so is should be thread-safe.
 
 @param context      A new bitmap content created by layer.
 @param size         The content size (typically same as layer's bound size).
 @param isCancelled  If this block returns `YES`, the method should cancel the
 drawing process and return as quickly as possible.
 */

@property (nullable, nonatomic, copy) void (^display)(CGContextRef context, CGSize size, BOOL(^isCancelled)(void));

/**
 This block will be called after the asynchronous drawing finished.
 It will be called on the main thread.
 
 @param layer  The layer.
 @param finished  If the draw process is cancelled, it's `NO`, otherwise it's `YES`;
 */

@property (nullable, nonatomic, copy) void (^didDisplay)(CALayer *layer, BOOL finished);

@end
NS_ASSUME_NONNULL_END





























