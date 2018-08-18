//
//  TYZChoiceDateBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZChoiceDateBackgroundView : UIView

/**
 *  type 1表示确认；2表示取消
 */
@property (nonatomic, copy) void (^TouchDateBlock)(NSString *date, NSInteger type);

- (void)updateWithDate:(NSString *)date;

@end
