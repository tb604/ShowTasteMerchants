//
//  UserPaySuccessOrderFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserPaySuccessOrderFooterView.h"
#import "LocalCommon.h"

@interface UserPaySuccessOrderFooterView ()
{
    /**
     *  评论按钮
     */
    UIButton *_btnComment;
}

- (void)initWithBtnComment;

@end

@implementation UserPaySuccessOrderFooterView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnComment];
}

- (void)initWithBtnComment
{
    CGRect frame = CGRectMake(15, 20, [[UIScreen mainScreen] screenWidth] - 30, 45);
    _btnComment = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"去评价" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_18 targetSel:@selector(clickedWithComment:)];
    _btnComment.frame = frame;
    _btnComment.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    _btnComment.layer.masksToBounds = YES;
    _btnComment.layer.cornerRadius = 4;
    [self addSubview:_btnComment];
}

- (void)clickedWithComment:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end
















