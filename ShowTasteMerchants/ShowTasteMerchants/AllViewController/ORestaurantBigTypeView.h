//
//  ORestaurantBigTypeView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kORestaurantBigTypeViewHeight (20 + 15 + 10 + 2 + 30 + 15)

@interface ORestaurantBigTypeView : TYZBaseView

/**
 *  选中数组的数据
 */
@property (nonatomic, strong) NSMutableArray *selectedList;

@end
