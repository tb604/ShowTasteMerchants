//
//  TYZTimeChoiceView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  时间选择视图(12:23)
 */
@interface TYZTimeChoiceView : UIView

/**
 *  time为nil表示取消
 */
@property (nonatomic, copy) void (^pickupTimeBlock)(NSString *time);

- (void)updateCurrentTimeHour:(NSString *)hour minite:(NSString *)minite;

@end
