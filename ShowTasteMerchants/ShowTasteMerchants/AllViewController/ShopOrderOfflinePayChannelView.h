//
//  ShopOrderOfflinePayChannelView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

/// 选择线下支付渠道的视图
@interface ShopOrderOfflinePayChannelView : TYZBaseView

@property (nonatomic, copy) void (^touchWithButtonBlock)(id data);

@end
