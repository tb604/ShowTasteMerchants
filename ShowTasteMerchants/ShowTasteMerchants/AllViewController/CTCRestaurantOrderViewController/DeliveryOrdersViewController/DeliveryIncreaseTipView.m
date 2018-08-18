//
//  DeliveryIncreaseTipView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryIncreaseTipView.h"
#import "LocalCommon.h"

@interface DeliveryIncreaseTipView () <UITextFieldDelegate>
{
    UILabel *_titleLabel;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
    
    /// 增加小费
    UITextField *_txtTipField;
    
    UILabel *_unitLabel;
}
/// 横线
@property (nonatomic, strong) CALayer *horiLine;

/// 竖线
@property (nonatomic, strong) CALayer *verLine;

- (void)initWithTitleLabel;

- (void)initWithHoriLine;

- (void)initWithVerLine;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

- (void)initWithTxtTipField;

- (void)initWithUnitLabel;

@end

@implementation DeliveryIncreaseTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithHoriLine
{
    if (!_horiLine)
    {
        CGRect frame = CGRectMake(0, self.height - 45, self.width, 0.5);
        _horiLine = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
    }
}

- (void)initWithVerLine
{
    if (!_verLine)
    {
        CGRect frame = CGRectMake(0, _horiLine.bottom, 0.5, 45);
        _verLine = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        _verLine.centerX = self.width / 2.;
    }
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.;
    
    [self initWithHoriLine];
    
    [self initWithVerLine];
    
    [self initWithTitleLabel];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
    
    [self initWithTxtTipField];
    
    [self initWithUnitLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, 18, self.width - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"添加小费";
    }
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _horiLine.bottom, self.width / 2, 45);
        
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
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
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.left = _verLine.right;
        _btnSubmit.tag = 101;
        [self addSubview:_btnSubmit];
    }
}

- (void)initWithTxtTipField
{
    if (!_txtTipField)
    {
        CGRect frame = CGRectMake(30, 0, 220, 40);
        _txtTipField = [[UITextField alloc] initWithFrame:frame];
        _txtTipField.font = FONTSIZE(15);
        _txtTipField.delegate = self;
        _txtTipField.textColor = [UIColor colorWithHexString:@"#ff5500"];
        _txtTipField.keyboardType = UIKeyboardTypeDecimalPad;
//        _realMoneyTxtField.text = @"30.0";
        _txtTipField.returnKeyType = UIReturnKeyDone;
        _txtTipField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtTipField.textAlignment = NSTextAlignmentCenter;
        _txtTipField.placeholder = @"小费金额";
        _txtTipField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtTipField.bottom = _horiLine.top - 35;
        _txtTipField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        _txtTipField.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _txtTipField.layer.borderWidth = 1;
        [self addSubview:_txtTipField];
    }
}

- (void)initWithUnitLabel
{
    if (!_unitLabel)
    {
        CGRect frame = CGRectMake(0, 0, 25, 20);
        _unitLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _unitLabel.text = @"元";
        _unitLabel.centerY = _txtTipField.centerY;
        _unitLabel.centerX = (self.width - _txtTipField.right) / 2. + _txtTipField.right;
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        if (btn.tag == 100)
        {
            self.viewCommonBlock(nil);
        }
        else
        {
            float amount = [_txtTipField.text floatValue];
            if (amount == 0.0)
            {
                [SVProgressHUD showInfoWithStatus:@"请输入金额"];
                return;
            }
            self.viewCommonBlock(@(amount));
        }
    }
}

@end











