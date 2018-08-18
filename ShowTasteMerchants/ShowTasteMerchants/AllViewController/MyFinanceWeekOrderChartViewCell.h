//
//  MyFinanceWeekOrderChartViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kMyFinanceWeekOrderChartViewCellHeight (260.0)

@interface MyFinanceWeekOrderChartViewCell : TYZBaseTableViewCell

- (void)updateCellData:(id)cellEntity title:(NSString *)title;

@end
