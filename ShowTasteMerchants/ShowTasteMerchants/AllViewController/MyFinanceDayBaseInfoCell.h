//
//  MyFinanceDayBaseInfoCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kMyFinanceDayBaseInfoCellHeight (155.0)

/**
 *  基本信息cell
 */
@interface MyFinanceDayBaseInfoCell : TYZBaseTableViewCell

/**
 *  选择日期
 */
@property (nonatomic, copy) void (^choiceWithDateBlock)();

/**
 *  回到今天的日期
 */
@property (nonatomic, copy) void (^todayWithDateBlock)();

/// 点击营业额
@property (nonatomic, copy) void (^touchTurnoverBlock)();

@end
