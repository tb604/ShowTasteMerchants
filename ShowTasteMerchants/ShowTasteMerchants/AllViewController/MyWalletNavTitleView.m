//
//  MyWalletNavTitleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletNavTitleView.h"
#import "LocalCommon.h"

@interface MyWalletNavTitleView ()
{
    UIButton *_btnChoice;
}

- (void)initWithBtnChoice;

@end

@implementation MyWalletNavTitleView


- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnChoice];
    
}

- (void)initWithBtnChoice
{
    // wallet_btn_xiala
    if (!_btnChoice)
    {
        UIImage *image = [UIImage imageNamed:@"wallet_btn_xiala"];
        NSString *str = @"全部";
        CGFloat width = [str widthForFont:FONTBOLDSIZE(18)] + image.size.width + 20;
        CGRect frame = CGRectMake((self.width - width) / 2, 0, width, self.height);
        _btnChoice = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ffffff"] titleFont:FONTBOLDSIZE(18) targetSel:@selector(clickedWithChoice:)];
        _btnChoice.frame = frame;
        _btnChoice.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_btnChoice setImage:image forState:UIControlStateNormal];
        // UIEdgeInsets
        _btnChoice.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        _btnChoice.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -80);
//        _btnChoice.backgroundColor = [UIColor purpleColor];
        [self addSubview:_btnChoice];
    }
}

- (void)clickedWithChoice:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    [_btnChoice setTitle:entity forState:UIControlStateNormal];
}


@end













