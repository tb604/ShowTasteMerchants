//
//  MallListDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MallListDataEntity : NSObject

/**
 *  商圈id
 */
@property (nonatomic, assign) NSInteger id;

/**
 *  商圈名称
 */
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) CGFloat distance;

@end
