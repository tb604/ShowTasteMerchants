//
//  DeliveryOrderOperatorViewCell.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"


#define kDeliveryOrderOperatorViewCellHeight (50.)

/**
 *  订单操作视图
 */
@interface DeliveryOrderOperatorViewCell : TYZBaseTableViewCell


- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType;

@end
