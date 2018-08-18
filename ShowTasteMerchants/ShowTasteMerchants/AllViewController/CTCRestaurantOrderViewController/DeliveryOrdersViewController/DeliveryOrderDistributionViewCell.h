//
//  DeliveryOrderDistributionViewCell.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDeliveryOrderDistributionViewCellHeight (70.0)

/**
 *  取货中、配送成本
 */
@interface DeliveryOrderDistributionViewCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity orderType:(NSInteger)orderType;

@end
