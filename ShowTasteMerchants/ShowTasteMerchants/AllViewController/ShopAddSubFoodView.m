//
//  ShopAddSubFoodView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopAddSubFoodView.h"
#import "LocalCommon.h"
#import "ShopingCartEntity.h" // 购物车实体类

@interface ShopAddSubFoodView ()
{
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
    
    /**
     *  加按钮
     */
    UIButton *_btnAdd;
    
    /**
     *  数字
     */
    UILabel *_numLabel;
    
    /**
     *  减号
     */
    UIButton *_btnSub;
    
    /**
     *  菜品名称
     */
    UILabel *_foodNameLabel;
    
    /**
     *  描述
     */
    UILabel *_descLabel;
    
    /**
     *  100 第一次添加的菜品；101 点击有多次加菜加减菜品的主cell；102 点击有多次加减菜品的子cell
     */
    NSInteger _addSubType;
    
    /**
     *  1表示加菜；2表示减菜
     */
    NSInteger _operateFood;
    
}

/**
 *  购物车数据
 */
@property (nonatomic, strong) ShopingCartEntity *cartEntity;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CALayer *lineTwo;

- (void)initWithLine;

- (void)initWithLineTwo;

- (void)initwithBtnCancel;

- (void)initWithBtnSubmit;

- (void)initWithBtnAdd;

- (void)initWithNumLabel;

- (void)initWithBtnSub;

- (void)initWithFoodNameLabel;

- (void)initWithDescLabel;

@end

@implementation ShopAddSubFoodView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithLineTwo];
    
    [self initwithBtnCancel];
    
    [self initWithBtnSubmit];
    
    [self initWithBtnAdd];
    
    [self initWithNumLabel];
    
    [self initWithBtnSub];
    
    [self initWithFoodNameLabel];
    
    [self initWithDescLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = self.height - 45;
    line.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, 45);
    line.left = self.width / 2;
    line.top = _line.bottom;
    line.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"].CGColor;
    [self.layer addSublayer:line];
    self.lineTwo = line;
}

- (void)initwithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _line.bottom, self.width / 2, 45);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnCancel.tag = 100;
        _btnCancel.frame = frame;
        //        _btnCancel.backgroundColor = [UIColor purpleColor];
        [self addSubview:_btnCancel];
        debugLogFrame(frame);
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = _btnCancel.frame;
        frame.origin.x = _lineTwo.right;
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确定" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.tag = 101;
        _btnSubmit.frame = frame;
        [self addSubview:_btnSubmit];
    }
}

- (void)initWithBtnAdd
{
    if (!_btnAdd)
    {// order_btn_jia_sel
        UIImage *image = [UIImage imageNamed:@"order_btn_jia"];
        CGRect frame = CGRectMake(self.width - 15 - image.size.width, (self.height - 45 - image.size.height)/2, image.size.width, image.size.height);
        _btnAdd = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_jia" imgNameSel:@"order_btn_jia_sel" targetSel:@selector(clickedWithAddSub:)];
        _btnAdd.frame = frame;
        _btnAdd.tag = 101;
        [self addSubview:_btnAdd];
    }
}

- (void)initWithNumLabel
{
    if (!_numLabel)
    {
        CGRect frame = _btnAdd.frame;
        frame.origin.x = frame.origin.x - 10 - frame.size.width;
        _numLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
//        _numLabel.backgroundColor = [UIColor lightGrayColor];
        _numLabel.layer.borderColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        _numLabel.layer.borderWidth = 0.8;
    }
}

- (void)initWithBtnSub
{// order_btn_jian_sel
    if (!_btnSub)
    {
        CGRect frame = _numLabel.frame;
        frame.origin.x = frame.origin.x - 10 - frame.size.width;
        _btnSub = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_jian" imgNameSel:@"order_btn_jian_sel" targetSel:@selector(clickedWithAddSub:)];
        _btnSub.tag = 100;
        _btnSub.frame = frame;
        [self addSubview:_btnSub];
    }
}

- (void)initWithFoodNameLabel
{
    if (!_foodNameLabel)
    {
        CGRect frame = CGRectMake(15, _btnSub.top - 1, _btnSub.left - 15 - 10, 16);
        _foodNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//        _foodNameLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = _foodNameLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 2;
        frame.size.height = 16;
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _descLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)clickedWithAddSub:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger num = [_numLabel.text integerValue];
    if (btn.tag == 100)
    {// 减
        if (_addSubType == EN_ADD_SUB_FIRST_TYPE)
        {// 可加可减
            if (num != 0)
            {
                num -= 1;
            }
            if (num == 0)
            {
                _btnSub.selected = YES;
            }
        }
        else if (_addSubType == EN_ADD_SUB_SECOND_TYPE)
        {// 可加不可减
            num -= 1;
            if (_cartEntity.fixedNumber >= num)
            {
                num = _cartEntity.fixedNumber;
                _btnSub.selected = YES;
            }
        }
        else if (_addSubType == EN_ADD_SUB_THIRD_TYPE)
        {// 可减不可加
            if (num != 0)
            {
                num -= 1;
                _btnAdd.selected = NO;
            }
            if (num == 0)
            {
                _btnSub.selected = YES;
            }
        }
    }
    else if (btn.tag == 101)
    {// 加
        if (_addSubType == EN_ADD_SUB_FIRST_TYPE)
        {// 可加可减
            num += 1;
            _btnSub.selected = NO;
        }
        else if (_addSubType == EN_ADD_SUB_SECOND_TYPE)
        {// 可加不可减
            num += 1;
            _btnSub.selected = NO;
        }
        else if (_addSubType == EN_ADD_SUB_THIRD_TYPE)
        {// 可减不可加
            num += 1;
            if (_cartEntity.fixedNumber <= num)
            {
                num = _cartEntity.fixedNumber;
                _btnAdd.selected = YES;
            }
            else
            {
                _btnSub.selected = NO;
            }
        }
    }
    _numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
    _cartEntity.number = num;
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 100)
    {// 取消
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(nil);
        }
    }
    else
    {
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(_cartEntity);
        }
    }
}

- (void)updateViewData:(id)entity addSubType:(NSInteger)addSubType operateFood:(NSInteger)operateFood
{
    self.cartEntity = entity;
    _addSubType = addSubType;
    _operateFood = operateFood;
    
    _btnSub.selected = NO;
    _btnAdd.selected = NO;
    if (_addSubType == EN_ADD_SUB_SECOND_TYPE)
    {// 可加不可减
        _btnSub.selected = YES;
    }
    else if (_addSubType == EN_ADD_SUB_THIRD_TYPE)
    {// 可减不可加
        _btnAdd.selected = YES;
    }
    debugLog(@"addSubType=%d; operateFood=%d;", (int)_addSubType, (int)_operateFood);
    _numLabel.text = [NSString stringWithFormat:@"%d", (int)_cartEntity.number];
    
    _foodNameLabel.text = _cartEntity.name;
    
    NSMutableString *mutStr = [NSMutableString new];
    if (![objectNull(_cartEntity.mode) isEqualToString:@""])
    {
        [mutStr appendFormat:@"%@ ", _cartEntity.mode];
    }
    
    if (![objectNull(_cartEntity.taste) isEqualToString:@""])
    {
        [mutStr appendString:_cartEntity.taste];
    }
    _descLabel.text = mutStr;
}

@end



















