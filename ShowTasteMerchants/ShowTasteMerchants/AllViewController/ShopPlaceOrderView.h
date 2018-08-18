//
//  ShopPlaceOrderView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

/**
 *  下单视图
 */
@interface ShopPlaceOrderView : TYZBaseView

@property (nonatomic, copy) void (^choicePrintBlock)(NSString *printName);

- (void)updateViewData:(id)entity printerList:(NSArray *)printerList;

- (void)updateWithPrinterIndex:(NSInteger)index;

@end
