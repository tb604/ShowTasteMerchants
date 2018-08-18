//
//  AlbsImageInfoEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbsImageInfoEntity : NSObject


@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *albumId;

@property (nonatomic, copy) NSString *name;

/**
 *  (id)
 */
@property (nonatomic, assign) NSInteger albsImgId;

/**
 *  (description)
 */
@property (nonatomic, copy) NSString *albsDesc;

/**
 *  (url)
 */
@property (nonatomic, copy) NSString *albsUrl;

@property (nonatomic, assign) NSInteger number;



@end
