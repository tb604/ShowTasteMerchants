//
//  OrderButtonEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OrderButtonEntity : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageNameNor;

@property (nonatomic, copy) NSString *imageNameSel;

@property (nonatomic, strong) UIColor *titleColorNor;

@property (nonatomic, strong) UIColor *titleColorSel;

@property (nonatomic, assign) BOOL isCheck;

@end






















