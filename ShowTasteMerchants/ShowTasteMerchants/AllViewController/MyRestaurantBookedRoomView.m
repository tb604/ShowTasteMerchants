//
//  MyRestaurantBookedRoomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedRoomView.h"
#import "LocalCommon.h"

@interface MyRestaurantBookedRoomView ()
{
    UILabel *_locationLabel;
}

- (void)initWithLocationLabel;

@end

@implementation MyRestaurantBookedRoomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLocationLabel];
}

- (void)initWithLocationLabel
{
    CGRectMake(10, 0, self.width - 20, self.height);
//    _locationLabel = [TYZCreateCommonObject createWithLabel:<#(id)#> labelFrame:<#(CGRect)#> textColor:<#(UIColor *)#> fontSize:<#(UIFont *)#> labelTag:<#(NSInteger)#> alignment:<#(NSTextAlignment)#>]
}

- (void)updateViewData:(id)entity
{
    
}


@end
