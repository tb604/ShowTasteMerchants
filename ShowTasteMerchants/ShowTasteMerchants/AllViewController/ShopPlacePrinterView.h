//
//  ShopPlacePrinterView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface ShopPlacePrinterView : TYZBaseView

@property (nonatomic, copy) void (^choicePrinterInfoBlock)(id data, NSInteger index);


@end
