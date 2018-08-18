//
//  BirthdayBgView.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirthdayBgView : UIView
@property (nonatomic, copy) void (^TouchDateTimeBlock)(NSString *strDate, BOOL isSubmit);

- (void)updateWithBirthday:(NSString *)date isLogTime:(BOOL)isLogTime;

@end
