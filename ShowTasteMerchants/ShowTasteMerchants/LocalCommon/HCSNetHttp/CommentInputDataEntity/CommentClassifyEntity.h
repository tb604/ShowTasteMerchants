//
//  CommentClassifyEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommentClassifyEntity : NSObject

@property (nonatomic, copy) NSString *order_id;

@property (nonatomic, assign) NSInteger classify_id;

@property (nonatomic, copy) NSString *classify_name;

@property (nonatomic, strong) UIColor *color;

/**
 *  标签的宽度
 */
@property (nonatomic, assign) CGFloat classifyNameWidth;

@property (nonatomic, copy) NSString *operate_date;

@end
//"classify_id": 40001,
//"classify_name": "亲朋聚餐好去处"
