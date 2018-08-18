//
//  ShopAccountStatementBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopAccountStatementBackgroundView : UIView

@property (nonatomic, copy) void (^touchAccountStatementBlock)(id data);

/**
 *  修改金额视图
 */
@property (nonatomic, copy) void (^modifyActuallyAmountBlock)(id data);

- (void)updateWithData:(id)data;

@end
