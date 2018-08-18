//
//  ShopPlaceOrderBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopPlaceOrderBackgroundView : UIView

@property (nonatomic, copy) void (^viewCommonBlock)(id data);

@property (nonatomic, copy) void (^choiceWithPrintIdBlock)(NSInteger mouthId);

- (void)updateWithData:(id)data printerList:(NSArray *)printerList;

@end
