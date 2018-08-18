//
//  UserEvaluationServiceViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kUserEvaluationServiceViewCellHeight (50 + 40.0 * 3)

@interface UserEvaluationServiceViewCell : TYZBaseTableViewCell

@property (nonatomic, copy) void (^scoreWithStarPercentBlock)(CGFloat percent, NSInteger tag);

@end
