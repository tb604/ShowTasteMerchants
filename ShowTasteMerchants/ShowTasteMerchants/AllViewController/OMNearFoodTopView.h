//
//  OMNearFoodTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kOMNearFoodTopViewHeight (50.0)

@interface OMNearFoodTopView : TYZBaseView

// 更多
@property (nonatomic, copy) void (^touchWithMoreInfoBlock)();

@end
