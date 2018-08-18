//
//  CommentImageDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentImageDataEntity : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *name;

@end

/*
 "id": 2,
 "type": 0,
 "state": 0,
 "tag": 0,
 "name": "http: //test-img.xiuwei.chinatopchef.com/xw-test/4/ac611658-bbf5-ece5-0539-c12f86525e32.jpg"
*/