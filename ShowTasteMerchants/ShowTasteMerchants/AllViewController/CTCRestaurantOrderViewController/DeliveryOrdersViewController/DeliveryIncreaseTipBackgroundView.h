//
//  DeliveryIncreaseTipBackgroundView.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  加小费视图
 */
@interface DeliveryIncreaseTipBackgroundView : UIView

@property (nonatomic, copy) void (^touchViewBlock)(id data);

@end
