//
//  TYZTabBar.m
//  TYZCustomTabBarController_1
//
//  Created by 唐斌 on 16/3/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZTabBar.h"
#import "TYZPublishButton.h"


#define ButtonNumber 5


@interface TYZTabBar ()

/**
 *  是否显示中间的突出按钮
 */
@property (nonatomic, assign) BOOL isShowMiddleBulgeBtn;


/**
 *  发布按钮
 */
@property (nonatomic, strong) TYZPublishButton *publishButton;

@end


@implementation TYZTabBar

- (instancetype)initWithShowMiddleBtn:(BOOL)showMiddleBtn
{
    _isShowMiddleBulgeBtn = showMiddleBtn;
    if (self = [super init])
    {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (_isShowMiddleBulgeBtn)
        {
            TYZPublishButton *button = [TYZPublishButton publishButton];
            [self addSubview:button];
            self.publishButton = button;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isShowMiddleBulgeBtn)
    {
        CGFloat barWidth = self.frame.size.width;
        CGFloat barHeight = self.frame.size.height;
        
        CGFloat buttonW = barWidth / ButtonNumber;
        CGFloat buttonH = barHeight - 2;
        CGFloat buttonY = 1;
        
        NSInteger buttonIndex = 0;
        
        self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.3);
        
        for (UIView *view in self.subviews)
        {
            
            NSString *viewClass = NSStringFromClass([view class]);
            if (![viewClass isEqualToString:@"UITabBarButton"]) continue;
            
            CGFloat buttonX = buttonIndex * buttonW;
            if (buttonIndex >= 2)
            { // 右边2个按钮
                buttonX += buttonW;
            }
            
            view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
            
            buttonIndex++;
        }
    }
}

@end



























