//
//  DeliveryOrderInfoChargeView.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface DeliveryOrderInfoChargeView : TYZBaseView

@property (nonatomic, copy) void (^touchChargeBlock)();

- (void)updateWithCharge:(BOOL)charge;

@end
