//
//  CellCommonDataEntity.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CellCommonDataEntity : NSObject

//@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger tag;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  副标题
 */
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, strong) NSAttributedString *subTitleAttri;
@property (nonatomic, assign) CGFloat subTitleHeight;

//@property (nonatomic, copy) NSString *pl

/**
 *  图片名称
 */
@property (nonatomic, copy) NSString *thumalImgName;

@property (nonatomic, strong) UIImage *headImage;

@property (nonatomic, copy) NSString *placeholder;

/**
 *  头像地址
 */
@property (nonatomic, copy) NSString *headImgUrl;

/**
 *  是否读过的状态；0表示没有；1表示有读过
 *  发现-游记，红点标记(在驴友使用这个标记)
 */
@property (nonatomic, assign) NSInteger readState;


@property (nonatomic, assign) BOOL isCheck;

@property (nonatomic, copy) NSString *checkImgName;

@property (nonatomic, copy) NSString *uncheckImgName;

@end



















