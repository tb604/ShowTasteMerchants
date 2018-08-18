//
//  ShopTableNumberBackgroundView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  输入餐桌号视图
 */
@interface ShopTableNumberBackgroundView : UIView

@property (nonatomic, copy) void (^touchTableNumberBlock)(id data);

- (id)initWithFrame:(CGRect)frame seatList:(NSArray *)seatList;

//- (void)updateWithData:(id)data;

@end
