//
//  ShopTableNumberView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopTableNumberView.h"
#import "LocalCommon.h"

@interface ShopTableNumberView () <UITextFieldDelegate>
{
    /**
     *  人数
     */
    UITextField *_personNumTxtField;
    
    /**
     *  餐桌号
     */
    UITextField *_numTxtField;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CALayer *lineTwo;

@property (nonatomic, strong) CALayer *lineMiddle;

- (void)initWithLine;

- (void)initWithLineTwo;

- (void)initWithPersonNumTxtField;

- (void)initWithLineMiddle;

- (void)initWithNumTxtField;

- (void)initwithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation ShopTableNumberView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithLineTwo];
    
    [self initWithPersonNumTxtField];
    
//    [self initWithLineMiddle];
    
    [self initWithNumTxtField];
    
    [self initwithBtnCancel];
    
    [self initWithBtnSubmit];
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

// [HCSNetHttp requestWithShopSeatSetting:ent.shopId

- (void)initWithPersonNumTxtField
{
    if (!_personNumTxtField)
    {
        CGRect frame = CGRectMake(30, 38 + 30, self.width - 60, 30);
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入就餐人数" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        _personNumTxtField = [[UITextField alloc] initWithFrame:frame];
        _personNumTxtField.borderStyle = UITextBorderStyleNone;
        _personNumTxtField.font = FONTSIZE_15;
        _personNumTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _personNumTxtField.attributedPlaceholder = butedStr;
        _personNumTxtField.textAlignment = NSTextAlignmentCenter;
        _personNumTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _personNumTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _personNumTxtField.returnKeyType = UIReturnKeyDone;
        _personNumTxtField.delegate = self;
        _personNumTxtField.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [self addSubview:_personNumTxtField];
        
//        _personNumTxtField.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
//        _personNumTxtField.layer.borderWidth = 1;
    }
}

- (void)initWithLineMiddle
{
    CALayer *line = [CALayer drawLine:self frame:CGRectMake(_personNumTxtField.left, _personNumTxtField.bottom + 5, _personNumTxtField.width, 0.6) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    self.lineMiddle = line;
    _lineMiddle.hidden = YES;
}

- (void)initWithNumTxtField
{
    if (!_numTxtField)
    {
        CGRect frame = CGRectMake(30, _personNumTxtField.bottom + 10, self.width - 60, 30);
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入就餐桌号" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        _numTxtField = [[UITextField alloc] initWithFrame:frame];
        _numTxtField.borderStyle = UITextBorderStyleNone;
        _numTxtField.font = FONTSIZE_15;
        _numTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _numTxtField.attributedPlaceholder = butedStr;
        _numTxtField.textAlignment = NSTextAlignmentCenter;
        _numTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numTxtField.returnKeyType = UIReturnKeyDone;
        _numTxtField.delegate = self;
        _numTxtField.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [self addSubview:_numTxtField];
        
//        _numTxtField.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
//        _numTxtField.layer.borderWidth = 1;
        
    }
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

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 100)
    {
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(nil);
        }
    }
    else
    {
        NSString *personNum = objectNull(_personNumTxtField.text);
        NSString *strNum = objectNull(_numTxtField.text);
        if ([personNum isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入就餐人数！"];
            return;
        }
        if ([strNum isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入就餐桌号！"];
            return;
        }
        if (self.viewCommonBlock)
        {
            // “人数#桌号”
            ShopTableNumberSeatEntity *seatEnt = [ShopTableNumberSeatEntity new];
            seatEnt.personNum = [personNum integerValue];
            seatEnt.tableNo = strNum;
            self.viewCommonBlock(seatEnt);
//            self.viewCommonBlock([NSString stringWithFormat:@"%@#%@", personNum, strNum]);
        }
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end


















