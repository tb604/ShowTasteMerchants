//
//  TYZPlaceholderTextView.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZPlaceholderTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;

//@property (nonatomic, strong) NSAttributedString *attributePlaceHolder;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, strong) UIFont *placeholderFont;
@end
