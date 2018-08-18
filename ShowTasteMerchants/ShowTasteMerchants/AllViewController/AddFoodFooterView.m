//
//  AddFoodFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddFoodFooterView.h"
#import "LocalCommon.h"

@interface AddFoodFooterView ()
{
    UIButton *_btnAdd;
}

- (void)initWithBtnAdd;

@end

@implementation AddFoodFooterView


- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBtnAdd];
}

- (void)initWithBtnAdd
{
    CGRect frame = CGRectMake(15, (kAddFoodFooterViewHeight - 40) / 2.0, self.width - 30, 40);
    _btnAdd = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"添加图文介绍" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_13 targetSel:@selector(clickedAdd:)];
    _btnAdd.frame = frame;
    _btnAdd.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    _btnAdd.layer.borderWidth = 1;
    [self addSubview:_btnAdd];
}

- (void)clickedAdd:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end
