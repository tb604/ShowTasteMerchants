//
//  DeliveryOrderUserBaseInfoCell.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDeliveryOrderUserBaseInfoCellHeight (30 + 56)

/**
 * 订单的基本用户信息视图(订单号、姓名、电话、地址)
 */
@interface DeliveryOrderUserBaseInfoCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType;

@end
