//
//  ShopPlaceOrderHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlaceOrderHeaderView.h"
#import "LocalCommon.h"
#import "ShopPlaceSelectPrinterView.h"

@interface ShopPlaceOrderHeaderView ()
{
    UILabel *_titleLabel;
    
    /**
     *  补单
     */
    ShopPlaceSelectPrinterView *_btnRepair;
}

- (void)initWithTitleLabel;

/**
 * 补单
 */
- (void)initWithBtnRepair;

@end

@implementation ShopPlaceOrderHeaderView


- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    // 补单
    [self initWithBtnRepair];

    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kShopPlaceOrderHeaderViewHeight-20)/2, self.width - 160, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentLeft];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    
}



/**
 *  补单
 */
- (void)initWithBtnRepair
{
    if (!_btnRepair)
    {// menu_btn_choose
        UIImage *image = [UIImage imageNamed:@"menu_btn_choose"];
        
        NSString *str = @"打印机1";
        CGFloat width = [str widthForFont:FONTSIZE_13] + 10 + image.size.width;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kShopPlaceOrderHeaderViewHeight - 30) / 2, width, 30);
        _btnRepair = [[ShopPlaceSelectPrinterView alloc] initWithFrame:frame];
//        _btnRepair.backgroundColor = [UIColor lightGrayColor];
        _btnRepair.frame = frame;
//        _btnRepair.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [_btnRepair setImage:image forState:UIControlStateNormal];
        
//        _btnRepair.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
//        _btnRepair.layer.borderWidth = 1;
//        _btnRepair.layer.masksToBounds = YES;
//        _btnRepair.layer.cornerRadius = 3;
//        _btnRepair.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        _btnRepair.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -95);
        [self addSubview:_btnRepair];
    }
    __weak typeof(self)weakSelf = self;
    _btnRepair.viewCommonBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(data);
        }
    };
}

/*
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
 */

- (void)clickedWithRepair:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
//    if (self.viewCommonBlock)
//    {
//        self.viewCommonBlock(btn.titleLabel.text);
//    }
}

- (void)updateViewData:(id)entity printerName:(NSString *)printerName
{
    _titleLabel.text = entity;
    _btnRepair.hidden = YES;
    if (![entity isEqualToString:@"提示"])
    {
        _btnRepair.hidden = NO;
        CGRect frame = _btnRepair.frame;
        UIImage *image = [UIImage imageNamed:@"menu_btn_choose"];
        
        NSString *str = printerName;
        CGFloat width = [str widthForFont:FONTSIZE_13] + 5 + image.size.width;
        frame.size.width = width;
        _btnRepair.frame = frame;
        _btnRepair.right = [[UIScreen mainScreen] screenWidth] - 15;
        [_btnRepair updateViewData:str];
    }
}


@end
