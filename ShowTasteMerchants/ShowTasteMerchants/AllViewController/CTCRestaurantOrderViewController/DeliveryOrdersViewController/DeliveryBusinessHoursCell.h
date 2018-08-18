//
//  DeliveryBusinessHoursCell.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDeliveryBusinessHoursCellHeight (45.0)

@interface DeliveryBusinessHoursCell : TYZBaseTableViewCell
//// type 1表示开始时间；2表示结束时间
@property (nonatomic, copy) void (^uploadTimeBlock)(id data, int type);

@end
