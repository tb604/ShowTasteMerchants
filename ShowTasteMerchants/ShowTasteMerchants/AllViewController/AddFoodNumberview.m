//
//  AddFoodNumberview.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddFoodNumberview.h"
#import "LocalCommon.h"
#import "ButtonAddFoodView.h"

@interface AddFoodNumberview ()
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
     *  选择规格
     */
    UIButton *_btnSpec;
}

- (void)initWithBtnSub;

- (void)initWithNumLabel;

- (void)initWithBtnAdd;

/**
 *  选择规格
 */
- (void)initWithBtnSpec;

@end

@implementation AddFoodNumberview

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnSub];
    
    [self initWithNumLabel];
    
    [self initWithBtnAdd];
    
    [self initWithBtnSpec];
}

- (void)initWithBtnSub
{
    //
    // order_btn_subtract_nor
    CGRect frame = CGRectMake(0, 0, 33, kAddFoodNumberviewHeight);
    _btnSub = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_subtract_nor" imgNameSel:@"order_btn_subtract_nor" targetSel:@selector(clickedWithButton:)];
    _btnSub.frame = frame;
    _btnSub.tag = 100;
    [self addSubview:_btnSub];
}

- (void)initWithNumLabel
{
    CGRect frame = CGRectMake(_btnSub.right, 0, self.width - _btnSub.width*2, self.height);
    _numLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _numLabel.text = @"0";
}

- (void)initWithBtnAdd
{
    // order_btn_addr_click
    // order_btn_addr_nor
    CGRect frame = _btnSub.frame;
    frame.origin.x = self.width - frame.size.width;
    _btnAdd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_addr_nor" imgNameSel:@"order_btn_addr_nor" targetSel:@selector(clickedWithButton:)];
    _btnAdd.frame = frame;
    _btnAdd.tag = 101;
    [self addSubview:_btnAdd];
}

/**
 *  选择规格
 */
- (void)initWithBtnSpec
{
    CGRect frame = CGRectMake(0, 0, self.width, self.height);
    _btnSpec =  [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_kexuanguige_nor" imgNameSel:@"order_btn_kexuanguige_nor" targetSel:@selector(clickedWithButton:)];
    _btnSpec.frame = frame;
    _btnSpec.tag = 102;
    [self addSubview:_btnSpec];
}

- (void)clickedWithButton:(id)sender
{
    NSInteger type = 0;
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100)
    {// 减法
        type = 1;
    }
    else if (btn.tag == 101)
    {// 加法
        type = 2;
    }
    else if (btn.tag == 102)
    {// 规格
        type = 3;
    }
    if (self.addFoodBlock)
    {
        self.addFoodBlock(type, btn);
    }

}

- (void)updateViewData:(id)entity
{
    
}

- (void)updateWithAddNum:(NSInteger)num
{
//    NSInteger snum = [_numLabel.text integerValue];
//    snum += num;
    _numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
}

/**
 *  隐藏规格按钮
 *
 *  @param hidden
 */
- (void)hiddenWithSpec:(BOOL)hidden
{
    _btnSpec.hidden = hidden;
    _btnSub.hidden = !hidden;
    _btnAdd.hidden = !hidden;
    _numLabel.hidden = !hidden;
//    [_btnSpec setTitle:specTitle forState:UIControlStateNormal];
}

@end
