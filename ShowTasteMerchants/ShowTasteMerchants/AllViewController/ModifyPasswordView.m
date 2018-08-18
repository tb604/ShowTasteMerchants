//
//  ModifyPasswordView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyPasswordView.h"
#import "LocalCommon.h"


@interface ModifyPasswordView () <UITextFieldDelegate>
{
    
    UILabel *_oldPswLabel;
    
    UITextField *_oldPswTxtField;
    
    UILabel *_newPswLabel;
    
    UITextField *_newPswTxtField;
    
    UILabel *_subPswLabel;
    
    UITextField *_subPswTxtField;
    
    UIButton *_btnSubmitSave;
    
    CGFloat _fontWidth;
}
@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *lineTwo;

@property (nonatomic, strong) CALayer *lineThree;


- (void)initWithLineOne;

- (void)initWithLineTwo;

- (void)initWithLineThree;

- (void)initWithOldPswLabel;

- (void)initWithOldPswTxtField;

- (void)initWithNewPswLabel;

- (void)initWithNewPswTxtField;

- (void)initWithSubPswLabel;

- (void)initWithSubPswTxtField;

- (void)initWithBtnSubmitSave;

@end

@implementation ModifyPasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    NSString *str = @"确认密码";
    _fontWidth = [str widthForFont:FONTSIZE_12];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor purpleColor];
    
    
    [self initWithLineOne];
    
    [self initWithLineTwo];
    
    [self initWithLineThree];
    
    [self initWithOldPswLabel];
    
    [self initWithOldPswTxtField];
    
    [self initWithNewPswLabel];
    
    [self initWithNewPswTxtField];
    
    [self initWithSubPswLabel];
    
    [self initWithSubPswTxtField];
    
    [self initWithBtnSubmitSave];
}


- (void)initWithLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 00;
    line.top =40;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
    self.lineOne = line;
}

- (void)initWithLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.top =80;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
    self.lineTwo = line;

}

- (void)initWithLineThree
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.top =120;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
    self.lineThree = line;
}

- (void)initWithOldPswLabel
{
    CGRect frame = CGRectMake(0, 10, _fontWidth, 20);
    _oldPswLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    _oldPswLabel.text = @"旧密码";
}

- (void)initWithOldPswTxtField
{
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入旧密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
    CGRect frame = CGRectMake(_oldPswLabel.right + 10, 0, self.width - _oldPswLabel.right - 10, 30);
    _oldPswTxtField = [[UITextField alloc] initWithFrame:frame];
    _oldPswLabel.font = FONTSIZE_15;
    _oldPswTxtField.borderStyle = UITextBorderStyleNone;
    _oldPswTxtField.attributedPlaceholder = butedStr;
    _oldPswTxtField.textAlignment = NSTextAlignmentLeft;
    _oldPswTxtField.secureTextEntry = YES;
    _oldPswTxtField.delegate = self;
    _oldPswTxtField.returnKeyType = UIReturnKeyNext;
    _oldPswTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldPswTxtField.centerY = _oldPswLabel.centerY;
    [self addSubview:_oldPswTxtField];
}

- (void)initWithNewPswLabel
{
    CGRect frame = CGRectMake(0, _lineOne.bottom+10, _fontWidth, 20);
    _newPswLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    _newPswLabel.text = @"新密码";

}

- (void)initWithNewPswTxtField
{
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
    CGRect frame = CGRectMake(_newPswLabel.right + 10, 0, self.width - _newPswLabel.right - 10, 30);
    _newPswTxtField = [[UITextField alloc] initWithFrame:frame];
    _newPswTxtField.font = FONTSIZE_15;
    _newPswTxtField.borderStyle = UITextBorderStyleNone;
    _newPswTxtField.attributedPlaceholder = butedStr;
    _newPswTxtField.textAlignment = NSTextAlignmentLeft;
    _newPswTxtField.secureTextEntry = YES;
    _newPswTxtField.delegate = self;
    _newPswTxtField.returnKeyType = UIReturnKeyNext;
    _newPswTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newPswTxtField.centerY = _newPswLabel.centerY;
    [self addSubview:_newPswTxtField];
}

- (void)initWithSubPswLabel
{
    CGRect frame = CGRectMake(0, _lineTwo.bottom+10, _fontWidth, 20);
    _subPswLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    _subPswLabel.text = @"确认密码";
}

- (void)initWithSubPswTxtField
{
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请重复一遍新密码" attributes:@{NSFontAttributeName: FONTSIZE_15, NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
    CGRect frame = CGRectMake(_subPswLabel.right + 10, 0, self.width - _subPswLabel.right - 10, 30);
    _subPswTxtField = [[UITextField alloc] initWithFrame:frame];
    _subPswTxtField.font = FONTSIZE_15;
    _subPswTxtField.borderStyle = UITextBorderStyleNone;
    _subPswTxtField.attributedPlaceholder = butedStr;
    _subPswTxtField.textAlignment = NSTextAlignmentLeft;
    _subPswTxtField.secureTextEntry = YES;
    _subPswTxtField.delegate = self;
    _subPswTxtField.returnKeyType = UIReturnKeyDone;
    _subPswTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _subPswTxtField.centerY = _subPswLabel.centerY;
    [self addSubview:_subPswTxtField];
}

- (void)initWithBtnSubmitSave
{
    if (!_btnSubmitSave)
    {
        CGRect frame = CGRectMake(0, 0, self.width, 40);
        _btnSubmitSave = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"提交&保存" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_14 targetSel:@selector(clickedButton:)];
        _btnSubmitSave.frame = frame;
        _btnSubmitSave.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self addSubview:_btnSubmitSave];
        _btnSubmitSave.bottom = self.height;
    }
}

- (NSString *)getOldPsw
{
    return _oldPswTxtField.text;
}

- (NSString *)getNewPsw
{
    return _newPswTxtField.text;
}

- (NSString *)getSubPsw
{
    return _subPswTxtField.text;
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_oldPswTxtField])
    {
        [_newPswTxtField becomeFirstResponder];
    }
    else if ([textField isEqual:_newPswTxtField])
    {
        [_subPswTxtField becomeFirstResponder];
    }
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self clickedButton:nil];
    }
    return YES;
}

@end
