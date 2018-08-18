//
//  AddFoodNumberNewView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddFoodNumberNewView.h"
#import "LocalCommon.h"

@interface AddFoodNumberNewView ()
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
     *  “可选规格”、“添加”
     */
    UIButton *_btnSpec;
    
    /**
     *  可选规格的数量
     */
    UILabel *_specNumLabel;
    // order_btn_subtract_click
    
    // order_btn_addr_click
}

- (void)initWithBtnSub;

- (void)initWithNumLabel;

- (void)initWithBtnAdd;

- (void)initWithBtnSpec;


@end

@implementation AddFoodNumberNewView

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    [self initWithBtnSub];
    
    [self initWithNumLabel];
    
    [self initWithBtnAdd];
    
    [self initWithBtnSpec];
}

- (void)initWithBtnSub
{
    // order_btn_subtract_nor
    CGRect frame = CGRectMake(0, 0, kAddFoodNumberNewViewHeight, kAddFoodNumberNewViewHeight);
    _btnSub = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"-" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE(30) targetSel:@selector(clickedWithButton:)];
    _btnSub.frame = frame;
    _btnSub.tag = 100;
    _btnSub.hidden = YES;
    [self addSubview:_btnSub];
}

- (void)initWithNumLabel
{
    CGRect frame = CGRectMake(_btnSub.right + 5, 0, self.width - _btnSub.width*2 - 10, self.height);
    _numLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _numLabel.hidden = YES;
    _numLabel.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
}

- (void)initWithBtnAdd
{
    // order_btn_addr_nor
    CGRect frame = _btnSub.frame;
    frame.origin.x = self.width - frame.size.width;
    _btnAdd = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"+" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE(30) targetSel:@selector(clickedWithButton:)];
    _btnAdd.frame = frame;
    _btnAdd.tag = 101;
    _btnAdd.hidden = YES;
    [self addSubview:_btnAdd];
}

- (void)initWithBtnSpec
{
    CGRect frame = CGRectMake(0, 0, self.width, self.height);
    _btnSpec = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"可选规格" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE(13) targetSel:@selector(clickedWithButton:)];
    _btnSpec.tag = 102;
    _btnSpec.frame = frame;
    _btnSpec.hidden = YES;
    [self addSubview:_btnSpec];
    
    
    frame = CGRectMake(0, 0, 12, 12);
    _specNumLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE_9 labelTag:0 alignment:NSTextAlignmentCenter];
    _specNumLabel.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    _specNumLabel.layer.cornerRadius = frame.size.width / 2;
    _specNumLabel.layer.masksToBounds = YES;
    _specNumLabel.left = _btnSpec.centerX + 26;
    _specNumLabel.top = _btnSpec.top + 5;
//    _specNumLabel.text = @"5";
    _specNumLabel.hidden = YES;
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
        if ([btn.titleLabel.text isEqualToString:@"添加"])
        {
            type = 4;
        }
    }
    if (self.addFoodBlock)
    {
        self.addFoodBlock(type, btn);
    }
    
}

- (void)updateWithAddNum:(NSInteger)num isRule:(BOOL)isRule
{
    _numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
//    NSString *title = _btnSpec.titleLabel.text;
//    debugLog(@"title=%@; num=%d", title, (int)num);
    if (isRule && !_btnSpec.hidden)
    {
        _specNumLabel.hidden = YES;
        if (num != 0)
        {
            _specNumLabel.text = [NSString stringWithFormat:@"%d", (int)num];
            _specNumLabel.hidden = NO;
        }
    }
}

- (void)hiddenWithSpec:(BOOL)hidden specTitle:(NSString *)specTitle
{
    _btnAdd.hidden = !hidden;
    _btnSub.hidden = !hidden;
    _numLabel.hidden = !hidden;
    _btnSpec.hidden = hidden; // “添加”、“可选规格”
    _specNumLabel.hidden = YES;
    if (!hidden)
    {
        debugLog(@"specTitle=%@", specTitle);
        [_btnSpec setTitle:specTitle forState:UIControlStateNormal];
    }
}

- (void)updateWithSpecColor:(UIColor *)color
{
    [_btnSpec setTitleColor:color forState:UIControlStateNormal];
}


@end












