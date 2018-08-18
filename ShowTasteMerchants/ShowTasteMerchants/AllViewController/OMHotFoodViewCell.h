//
//  OMHotFoodView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
//#import "OMHotFoodTopView.h"
#import "OMHotFoodMiddleView.h"
#import "OMNearFoodTopView.h"


/**
 *  热卖美食
 */
@interface OMHotFoodViewCell : TYZBaseTableViewCell

// 更多
@property (nonatomic, copy) void (^touchWithMoreInfoBlock)();

+ (CGFloat)getHotFoodViewCellHeight;

@end
