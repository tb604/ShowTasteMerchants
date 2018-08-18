//
//  TYZBaseViewController.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TYZRespondDataEntity;

@interface TYZBaseViewController : UIViewController

/**
 *  执行完后，可能有一些值需要返回
 */
@property (nonatomic, copy) void (^popResultBlock)(id data);

/**
 *  初始化变量
 */
- (void)initWithVar;

/**
 *  初始化navbar视图
 */
- (void)initWithNavBar;

/**
 *  初始化子视图
 */
- (void)initWithSubView;

/**
 *  初始化返回按钮
 */
- (void)initWithBackButton;

/**
 *  解析数据
 *
 *  @param respond 从服务端返回来的
 */
- (void)dataParse:(TYZRespondDataEntity *)respond;

/**
 *  从服务端请求数据
 */
- (void)fromServerRequestData;

/**
 *  返回按钮函数
 *
 *  @param sender 传进来的参数
 */
- (void)clickedBack:(id)sender;

- (void)updateWithBackImage:(NSString *)imageName;

@end
