//
//  AddShopingCartButton.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddShopingCartButton.h"
#import "LocalCommon.h"


@interface AddShopingCartButton ()
{
    /**
     *  减法
     */
    UIButton *_btnSub;
    
    /**
     *  数量
     */
    UILabel *_numLabel;
    
    /**
     *  加法
     */
    UIButton *_btnAdd;
    
    /**
     *  加入购物车
     */
    UIButton *_btnAddCart;
}

- (void)initWithBtnSub;

- (void)initWithNumLabel;

- (void)initWithBtnAdd;

/**
 *  加入购物车
 */
- (void)initWithBtnAddCart;
@end

@implementation AddShopingCartButton


- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnSub];
    
    [self initWithNumLabel];
    
    [self initWithBtnAdd];
    
    // 加入购物车
    [self initWithBtnAddCart];
}

- (void)initWithBtnSub
{
    if (!_btnSub)
    {
        CGRect frame = CGRectMake(0, 0, kAddShopingCartButtonHeight, kAddShopingCartButtonHeight);
        _btnSub = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"-" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE(20) targetSel:@selector(clickedWithButton:)];
        _btnSub.frame = frame;
        _btnSub.tag = 100;
        _btnSub.layer.masksToBounds = YES;
        _btnSub.layer.cornerRadius = 2;
        _btnSub.layer.borderColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        _btnSub.layer.borderWidth = 1;
        [self addSubview:_btnSub];
    }
}

- (void)initWithNumLabel
{
    if (!_numLabel)
    {
        CGRect frame = CGRectMake(_btnSub.right, 0, kAddShopingCartButtonHeight, kAddShopingCartButtonHeight);
        _numLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(14) labelTag:0 alignment:NSTextAlignmentCenter];
        _numLabel.text = @"1";
    }
}

- (void)initWithBtnAdd
{
    if (!_btnAdd)
    {
        CGRect frame = CGRectMake(self.width - kAddShopingCartButtonHeight, 0, kAddShopingCartButtonHeight, kAddShopingCartButtonHeight);
        _btnAdd = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"+" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE(20) targetSel:@selector(clickedWithButton:)];
        _btnAdd.frame = frame;
        _btnAdd.tag = 101;
        _btnAdd.layer.masksToBounds = YES;
        _btnAdd.layer.cornerRadius = 2;
        _btnAdd.layer.borderColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        _btnAdd.layer.borderWidth = 1;
        [self addSubview:_btnAdd];
    }
}

/**
 *  加入购物车
 */
- (void)initWithBtnAddCart
{
    if (!_btnAddCart)
    {
        CGRect frame = self.bounds;
        debugLogFrame(frame);
        _btnAddCart = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"加入购物车" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
        _btnAddCart.tag = 102;
        _btnAddCart.frame = frame;
        _btnAddCart.layer.cornerRadius = 2;
        _btnAddCart.layer.masksToBounds = YES;
        _btnAddCart.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self addSubview:_btnAddCart];
    }
}

- (void)clickedWithButton:(id)sender
{
    if (_addFoodBlock)
    {
        _addFoodBlock(sender);
    }
}

- (void)updateWithAddNum:(NSInteger)num
{
    _numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
}

/**
 *  隐藏规格按钮
 *
 *  @param hidden
 */
- (void)hiddenWithSpec:(BOOL)hidden specTitle:(NSString *)specTitle
{
    _btnSub.hidden = !hidden;
    _numLabel.hidden = !hidden;
    _btnAdd.hidden = !hidden;
    _btnAddCart.hidden = hidden;
    [_btnAddCart setTitle:specTitle forState:UIControlStateNormal];
}

@end
