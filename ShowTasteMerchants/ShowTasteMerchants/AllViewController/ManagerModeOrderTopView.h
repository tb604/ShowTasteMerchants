//
//  ManagerModeOrderTopView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kManagerModeOrderTopViewHeight (65.0)

@interface ManagerModeOrderTopView : TYZBaseView


@property (nonatomic, assign) NSInteger selectIndex;



@property (nonatomic, copy) void(^clickedButtonBlock)(int index);

- (BOOL)selectedIndex:(NSInteger)index;

@end
