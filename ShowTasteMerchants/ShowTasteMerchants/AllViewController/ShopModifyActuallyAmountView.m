//
//  ShopModifyActuallyAmountView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopModifyActuallyAmountView.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"
#import "OrderDataEntity.h"
#import "CTCMealOrderDetailsEntity.h"

@interface ShopModifyActuallyAmountView () <UITextFieldDelegate, UITextViewDelegate>
{
    UILabel *_titleLabel;
    
    UIImageView *_iconImgView;
    
    /**
     *  应付金额
     */
    UILabel *_copeMoneyLabel;
    
    UILabel *_copeMoneyTitleLabel;
    
    /**
     *  实付金额
     */
    UITextField *_realMoneyTxtField;
    
    UILabel *_realMoneyTitleLabel;
    
    /**
     *  理由
     */
    TYZPlaceholderTextView *_noteTextView;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
}
@property (nonatomic, strong) OrderAmountModifyEntity *inputEntity;
@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderEntity;

@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *lineTwo;

@property (nonatomic, strong) CALayer *lineThree;

- (void)initWithTitleLable;

- (void)initWithIconImgView;

/**
 *  应付金额
 */
- (void)initWithCopeMoneyLabel;

- (void)initWithCopeMoneyTitleLabel;

/**
 *  实付金额
 */
- (void)initWithRealMoneyTxtField;

- (void)initWithRealMoneyTitleLabel;

- (void)initWithNoteTextView;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation ShopModifyActuallyAmountView

- (void)initWithVar
{
    [super initWithVar];
    
    _inputEntity = [OrderAmountModifyEntity new];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLable];
    
    [self initWithIconImgView];
    
    // 应付金额
    [self initWithCopeMoneyLabel];
    
    [self initWithCopeMoneyTitleLabel];
    
    // 实付金额
    [self initWithRealMoneyTxtField];
    
    [self initWithRealMoneyTitleLabel];
    
    
    self.lineOne = [CALayer drawLine:self frame:CGRectMake(15, 0, self.width - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    _lineOne.top = _realMoneyTxtField.bottom + 30;
    
    [self initWithNoteTextView];
    
    self.lineTwo = [CALayer drawLine:self frame:CGRectMake(0, 0, self.width, 0.6) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    _lineTwo.top = _noteTextView.bottom + 10;
    
    self.lineThree = [CALayer drawLine:self frame:CGRectMake(self.width / 2, _lineTwo.bottom, 0.6, self.height - _lineTwo.bottom) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
    
}

- (void)initWithTitleLable
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 10, self.width - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"修改实付金额";
    }
}

- (void)initWithIconImgView
{
    if (!_iconImgView)
    {
        UIImage *image = [UIImage imageNamed:@"order_modify_money_point"];
        CGRect frame = CGRectMake((self.width - image.size.width)/2, _titleLabel.bottom + 30 + 20, image.size.width, image.size.height);
        _iconImgView = [[UIImageView alloc] initWithFrame:frame];
        _iconImgView.image = image;
        [self addSubview:_iconImgView];
    }
}

/**
 *  应付金额
 */
- (void)initWithCopeMoneyLabel
{
    if (!_copeMoneyLabel)
    {
        CGRect frame = CGRectMake(10, 0, (self.width - _iconImgView.width)/2 - 10 - 15, 30);
        _copeMoneyLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(30) labelTag:0 alignment:NSTextAlignmentCenter];
        _copeMoneyLabel.text = @"30.3";
        _copeMoneyLabel.centerY = _iconImgView.centerY;
    }
}

- (void)initWithCopeMoneyTitleLabel
{
    if (!_copeMoneyTitleLabel)
    {
        CGRect frame = _copeMoneyLabel.frame;
        frame.size.height = 20;
        _copeMoneyTitleLabel =  [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentCenter];
        _copeMoneyTitleLabel.bottom = _copeMoneyLabel.top;
        _copeMoneyTitleLabel.text = @"应付金额";
    }
}

/**
 *  实付金额
 */
- (void)initWithRealMoneyTxtField
{
    if (!_realMoneyTxtField)
    {
        CGRect frame = CGRectMake(_iconImgView.right + 10, 0, (self.width - _iconImgView.width)/2 - 10 - 15, 30);
        _realMoneyTxtField = [[UITextField alloc] initWithFrame:frame];
        _realMoneyTxtField.font = FONTSIZE(30);
        _realMoneyTxtField.delegate = self;
        _realMoneyTxtField.textColor = [UIColor colorWithHexString:@"#ff5500"];
        _realMoneyTxtField.keyboardType = UIKeyboardTypeDecimalPad;
        _realMoneyTxtField.text = @"30.0";
        _realMoneyTxtField.returnKeyType = UIReturnKeyDone;
//        _realMoneyTxtField.borderStyle = UITextBorderStyleLine;
        _realMoneyTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _realMoneyTxtField.textAlignment = NSTextAlignmentCenter;
        _realMoneyTxtField.placeholder = @"实付金额";
        _realMoneyTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _realMoneyTxtField.centerY = _iconImgView.centerY;
        [self addSubview:_realMoneyTxtField];
    }
}

- (void)initWithRealMoneyTitleLabel
{
    if (!_realMoneyTitleLabel)
    {
        CGRect frame = _realMoneyTxtField.frame;
        frame.size.height = 20;
        _realMoneyTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentCenter];
        _realMoneyTitleLabel.bottom = _copeMoneyLabel.top;
        _realMoneyTitleLabel.text = @"实付金额";
        
    }
}

- (void)initWithNoteTextView
{
    if (!_noteTextView)
    {
        CGRect frame = CGRectMake(15, _lineOne.bottom + 10, self.width - 30, 50);
        _noteTextView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
        _noteTextView.delegate = self;
        _noteTextView.placeholder = @"添加备注";
        _noteTextView.font = FONTSIZE_15;
        _noteTextView.textColor = [UIColor colorWithHexString:@"#323232"];
        _noteTextView.returnKeyType = UIReturnKeyDone;
        _noteTextView.keyboardType = UIKeyboardAppearanceDefault;
        [self addSubview:_noteTextView];
        _noteTextView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    }
    
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _lineTwo.bottom, self.width / 2, _lineThree.height);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.tag = 100;
        [self addSubview:_btnCancel];
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = _btnCancel.frame;
        frame.origin.x = _lineThree.right;
        _btnSubmit =  [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确定" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.tag = 101;
        [self addSubview:_btnSubmit];
    }
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
    {// 确定
        _inputEntity.newAmount = [_realMoneyTxtField.text doubleValue];
        _inputEntity.note = [_noteTextView text];
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(_inputEntity);
        }
    }
}

- (void)updateViewData:(id)entity
{
    self.orderEntity = entity;
    
    _inputEntity.orderId = _orderEntity.order_id;
    _inputEntity.shopId = _orderEntity.shop_id;

    // 应付金额
    _copeMoneyLabel.text = [NSString stringWithFormat:@"%.2f", _orderEntity.yf_amount];
    
    // 实付金额
    _realMoneyTxtField.text = [NSString stringWithFormat:@"%.2f", _orderEntity.sf_amount];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end


















