//
//  ShopAddSubFoodView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"


typedef NS_ENUM(NSInteger, EN_ADD_SUB_TYPE)
{
    EN_ADD_SUB_FIRST_TYPE = 100, ///< 第一次添加的菜品
    EN_ADD_SUB_SECOND_TYPE,  ///< 点击有多次加菜加减菜品的主cell
    EN_ADD_SUB_THIRD_TYPE, ///< 点击有多次加减菜品的子cell
};

typedef NS_ENUM(NSInteger, EN_OPERATE_FOOD_TYPE)
{
    EN_OPERATE_FOOD_ADD_TYPE = 1, ///< 加菜
    EN_OPERATE_FOOD_SUB_TYPE,   ///< 减菜
};


@interface ShopAddSubFoodView : TYZBaseView

- (void)updateViewData:(id)entity addSubType:(NSInteger)addSubType operateFood:(NSInteger)operateFood;

@end
