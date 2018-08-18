//
//  ThridPartPayChoiceViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import "PayInfoDataEntity.h"


/**
 *  第三方支付方式选择视图控制器
 */
@interface ThridPartPayChoiceViewController : TYZBaseViewController

/**
 *  支付方式
 */
@property (nonatomic, strong) PayInfoDataEntity *payEntity;

@end
