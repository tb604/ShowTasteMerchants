//
//  DeliveryBusinessChoiceHoursView.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryBusinessChoiceHoursView : UIView

@property (nonatomic, copy) void (^choiceTimeBlock)(NSString *time);

- (void)updateCurrentTimeHour:(NSString *)hour_ minite:(NSString *)minite_ type:(int)type;

@end
