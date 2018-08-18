//
//  ModifyCommonViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"

@interface ModifyCommonViewController : TYZBaseViewController

/**
 *  输入的内容是否是数字
 */
@property (nonatomic, assign) BOOL isNumber;

/**
 *  是否单行
 */
@property (nonatomic, assign) BOOL isSingleRow;

/**
 *  一起的值
 */
@property (nonatomic, strong) id data;

/**
 *  提示
 */
@property (nonatomic, copy) NSString *placeholder;


@end







