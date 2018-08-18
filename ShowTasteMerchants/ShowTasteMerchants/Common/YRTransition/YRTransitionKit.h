//
//  YRTransitionKit.h
//  YRTransitionDemo
//
//  Created by 王晓宇 on 15/2/4.
//  Copyright (c) 2015年 YueRuo. All rights reserved.
//


/*
 
 RootViewController *rootViewController=[[RootViewController alloc]initWithNibName:nil bundle:nil];
 UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:rootViewController];
 navigationController.view.backgroundColor=[UIColor brownColor];
 
 #warning 需要显式调用这一句，才能使自定义动画中iOS7以后的Push、CoverIn和从CoverReveal动画正常使用
 [navigationController enableTransition];

 
 RootViewController *otherViewController=[[RootViewController alloc]initWithNibName:nil bundle:nil];
 [otherViewController.view setBackgroundColor:[UIColor colorWithRed:0.3 green:0.8 blue:0.4 alpha:1]];
 [otherViewController.navigationItem setTitle:@"Second"];
 otherViewController.needBack=true;
 
 YRTransitionType type=(YRTransitionType)(indexPath.row+1);
 
 //navi
 if (!self.needBack)
 {//push
 [self.navigationController pushViewController:otherViewController withYRTransition:[YRTransition transitionWithType:type direction:YRTransitionDirection_FromRight duration:1.35]];
 
 }
 else
 {//pop
 [self.navigationController popViewControllerWithYRTransition:[YRTransition transitionWithType:type direction:YRTransitionDirection_FromLeft duration:1.2]];
 }

 
 */

/*!
 *	@brief	请导入这个文件，别导错了
 */
#ifndef YRTransitionDemo_YRTransitionKit_h

#define YRTransitionDemo_YRTransitionKit_h

#import "UINavigationController+YRTransition.h"
#import "UIViewController+YRTransition.h"

#endif
