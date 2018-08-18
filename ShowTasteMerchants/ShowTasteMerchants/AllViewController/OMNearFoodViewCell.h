//
//  OMNearFoodViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OMNearFoodTopView.h"
#import "OMNearFoodBottomView.h"

@interface OMNearFoodViewCell : TYZBaseTableViewCell

// 更多
@property (nonatomic, copy) void (^touchWithMoreInfoBlock)();

+ (CGFloat)getNearFoodViewCellHeight;

@end
