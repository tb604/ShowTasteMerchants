//
//  DeliveryOrdersTopView.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface DeliveryOrdersTopView : TYZBaseView

@property (nonatomic, copy) void (^selectButtonBlock)(NSInteger orderType);

/**
 *  水平的蓝色的线条
 */
@property (nonatomic, strong) UIImageView *horizontalBlueLine;

- (id)initWithFrame:(CGRect)frame titleList:(NSArray *)titleList;

@end
