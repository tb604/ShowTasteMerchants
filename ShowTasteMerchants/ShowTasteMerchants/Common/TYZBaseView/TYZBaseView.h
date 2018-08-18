//
//  TYZBaseView.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZBaseView : UIView

@property (nonatomic, copy) void (^viewCommonBlock)(id data);

- (void)initWithVar;

- (void)initWithSubView;


- (void)updateViewData:(id)entity;

@end
