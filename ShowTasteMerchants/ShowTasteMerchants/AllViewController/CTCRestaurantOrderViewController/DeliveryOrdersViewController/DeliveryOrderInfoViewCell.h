//
//  DeliveryOrderInfoViewCell.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDeliveryOrderInfoViewCellHeight (8+16*3+4*2+8)

@interface DeliveryOrderInfoViewCell : TYZBaseTableViewCell

@property (nonatomic, copy) void (^touchChargeBlock)();


- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType;

@end
