//
//  OMPlatInfoViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "OMNearFoodTopView.h"

/**
 *  板块信息cell
 */
@interface OMPlatInfoViewCell : TYZBaseTableViewCell

// 更多
@property (nonatomic, copy) void (^touchWithMoreInfoBlock)();

+ (CGFloat)getPlatInfoViewCellHeight;

@end
