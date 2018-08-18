//
//  MyFinanceNavTitleView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"


typedef NS_ENUM(NSInteger, EN_FINANCE_BTN_TAG)
{
    EN_FINANCE_BTN_DAY_TAG = 100, ///< 日
    EN_FINANCE_BTN_WEEK_TAG, ///< 周
    EN_FINANCE_BTN_MONTH_TAG, ///< 月
};

@interface MyFinanceNavTitleView : TYZBaseView

@property (nonatomic, assign) NSInteger selectedIndex;

@end
