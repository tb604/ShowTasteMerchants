//
//  TYZChoiceDateView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface TYZChoiceDateView : TYZBaseView

/**
 *  type 1表示确认
 */
@property (nonatomic, copy) void (^TouchDateBlock)(NSString *date, NSInteger type);

@end
