//
//  DinersCreateOrderFooterView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kDinersCreateOrderFooterViewHeight (65.)

@interface DinersCreateOrderFooterView : TYZBaseView


- (void)updateViewData:(id)entity totalNum:(NSInteger)totalNum totalPrice:(CGFloat)totalPrice;

@end
