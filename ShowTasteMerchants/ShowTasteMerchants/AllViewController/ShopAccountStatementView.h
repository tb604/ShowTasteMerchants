//
//  ShopAccountStatementView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

/**
 *  结算清单视图
 */
@interface ShopAccountStatementView : TYZBaseView

@property (nonatomic, copy) void (^modifyActuallyAmountBlock)(id data);

@end
