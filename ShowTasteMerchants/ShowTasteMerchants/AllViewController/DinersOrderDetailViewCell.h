//
//  DinersOrderDetailViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

@interface DinersOrderDetailViewCell : TYZBaseTableViewCell

/**
 *  高度
 *
 *  @param type 1预订订单 2即时订单
 *
 *  @return <#return value description#>
 */
+ (CGFloat)getWithCellHeight:(NSInteger)type;

@end
