//
//  ShopOrderOfflinePayChannelBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopOrderOfflinePayChannelView.h"

@interface ShopOrderOfflinePayChannelBackgroundView : UIView

@property (nonatomic, copy) void (^touchWithButtonBlock)(id data);

- (void)updateWithPayChannelList:(NSArray *)channelList;

@end
