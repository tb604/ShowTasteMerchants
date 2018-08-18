//
//  ShopPlaceOrderHeaderView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

#define kShopPlaceOrderHeaderViewHeight (50.0)

@interface ShopPlaceOrderHeaderView : TYZBaseView

/**
 *  <#Description#>
 *
 *  @param entity      <#entity description#>
 *  @param printerName 档口名称
 */
- (void)updateViewData:(id)entity printerName:(NSString *)printerName;

@end
