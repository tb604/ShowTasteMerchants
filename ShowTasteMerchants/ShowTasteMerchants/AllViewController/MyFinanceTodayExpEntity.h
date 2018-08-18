//
//  MyFinanceTodayExpEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFinanceTodayExpListEntity.h"

/// 异常
@interface MyFinanceTodayExpEntity : NSObject

/// 异常的总数量
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) BOOL isCheck;


@property (nonatomic, strong) NSArray *records;

@end




























