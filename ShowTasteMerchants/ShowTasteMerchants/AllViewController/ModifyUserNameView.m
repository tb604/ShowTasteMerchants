//
//  ModifyUserNameView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyUserNameView.h"
#import "LocalCommon.h"


@interface ModifyUserNameView () <UITextFieldDelegate>
{
    /**
     *  姓氏
     */
    UILabel *_familyNameLabel;
    
    /**
     *  姓氏输入框
     */
    UITextField *_familyNameTxtField;
    
    /**
     *  名
     */
    UILabel *_lastNameLabel;
    
    /**
     *  名输入框
     */
    UITextField *_lastNameTxtField;
}

- (void)initWithFamilyNameLabel;

- (void)initWithFamilyNameTxtField;

- (void)initWithLastNameLabel;

- (void)initWithLastNameTxtField;


@end

@implementation ModifyUserNameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithFamilyNameLabel];
    
    [self initWithFamilyNameTxtField];
    
    [self initWithLastNameLabel];
    
    [self initWithLastNameTxtField];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width - 60, 0.8);
    line.left = 30;
    line.centerY = kModifyUserNameViewHeight / 2;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithFamilyNameLabel
{
    if (!_familyNameLabel)
    {
        NSString *str = @"姓氏";
        CGFloat width = [str widthForFont:FONTSIZE_12]+ 10;
        CGRect frame = CGRectMake(30, 10, width, 20);
        _familyNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _familyNameLabel.text = @"姓氏";
    }
}

- (void)initWithFamilyNameTxtField
{
    if (!_familyNameTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入姓氏" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_familyNameLabel.right + 10, 5, self.width - _familyNameLabel.right - 10 - 30, 30);
        _familyNameTxtField = [[UITextField alloc] initWithFrame:frame];
        _familyNameTxtField.borderStyle = UITextBorderStyleNone;
        _familyNameTxtField.font = FONTSIZE_15;
        _familyNameTxtField.attributedPlaceholder = butedStr;
        _familyNameTxtField.textAlignment = NSTextAlignmentLeft;
        _familyNameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _familyNameTxtField.keyboardType = UIKeyboardTypeDefault;
        _familyNameTxtField.returnKeyType = UIReturnKeyNext;
        _familyNameTxtField.delegate = self;
        [self addSubview:_familyNameTxtField];
    }
}

- (void)initWithLastNameLabel
{
    if (!_lastNameLabel)
    {
        CGRect frame = _familyNameLabel.frame;
        _lastNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _lastNameLabel.text = @"名字";
        _lastNameLabel.bottom = kModifyUserNameViewHeight - 10;
    }
}

- (void)initWithLastNameTxtField
{
    if (!_lastNameTxtField)
    {
        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入名字" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_familyNameLabel.right + 10, 5, self.width - _familyNameLabel.right - 10 - 30, 30);
        _lastNameTxtField = [[UITextField alloc] initWithFrame:frame];
        _lastNameTxtField.borderStyle = UITextBorderStyleNone;
        _lastNameTxtField.font = FONTSIZE_15;
        _lastNameTxtField.attributedPlaceholder = butedStr;
        _lastNameTxtField.textAlignment = NSTextAlignmentLeft;
        _lastNameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _lastNameTxtField.keyboardType = UIKeyboardTypeDefault;
        _lastNameTxtField.returnKeyType = UIReturnKeyDone;
        _lastNameTxtField.delegate = self;
        _lastNameTxtField.centerY = _lastNameLabel.centerY;
        [self addSubview:_lastNameTxtField];
    }
}

- (void)updateViewData:(id)entity
{
//     @{@"familyName":_userInfoEntity.family_name, @"lastName":_userInfoEntity.name}
    NSDictionary *dict = entity;
    _familyNameTxtField.text = dict[@"familyName"];
    _lastNameTxtField.text = dict[@"lastName"];
}

- (NSString *)getFamilyName
{
    return _familyNameTxtField.text;
}

- (NSString *)getLastName
{
    return _lastNameTxtField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_familyNameTxtField])
    {
        [_lastNameTxtField becomeFirstResponder];
    }
    else
    {
        [self endEditing:YES];
        if (self.viewCommonBlock)
        {
            self.viewCommonBlock(nil);
        }
    }
    return YES;
}

@end



















