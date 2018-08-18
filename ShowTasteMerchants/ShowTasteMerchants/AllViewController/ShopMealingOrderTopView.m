//
//  ShopMealingOrderTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopMealingOrderTopView.h"
#import "LocalCommon.h"

@interface ShopMealingOrderTopView () <UITextFieldDelegate>
{
    UIButton *_btnSearch;
    
    /**
     *  “输入桌号”
     */
    UILabel *_tableNumLabel;
    
    UITextField *_tableNumTxtField;
    
    /**
     *  “食客姓名”
     */
    UILabel *_dinersNameLabel;
    
    UITextField *_dinersNameTxtField;
    
    CGFloat _txtWidth;
    
    CGFloat _spaceOne;
    
    CGFloat _spaceTwo;
}

- (void)initWithBtnSearch;

- (void)initWithTableNumLabel;

- (void)initWithTableNumTxtField;

- (void)initWithDinersNameLabel;

- (void)initWithDinersNameTxtField;

@end

@implementation ShopMealingOrderTopView

- (void)initWithVar
{
    [super initWithVar];
    
    if (kiPhone4 || kiPhone5)
    {
        _spaceTwo = 8;
        _spaceOne = 3;
    }
    else
    {
        _spaceTwo = 15;
        _spaceOne = 5;
    }
    
    CGFloat width = [[UIScreen mainScreen] screenWidth] - 50 - _spaceTwo * 2 - _spaceTwo - _spaceOne * 2;
    NSString *str = @"输入桌号";
    CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
    _txtWidth = (width - fontWidth * 2) / 2;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBtnSearch];
    
    [self initWithTableNumLabel];
    
    [self initWithTableNumTxtField];
    
    [self initWithDinersNameLabel];
    
    [self initWithDinersNameTxtField];
    
}

- (void)initWithBtnSearch
{
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 50, 0, 50, self.height);
    _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSearch setImage:[UIImage imageNamed:@"order_icon_search"] forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(clickedSearch:) forControlEvents:UIControlEventTouchUpInside];
    _btnSearch.frame = frame;
    _btnSearch.backgroundColor = [UIColor colorWithHexString:@"#ff5701"];
    [self addSubview:_btnSearch];
}

- (void)initWithTableNumLabel
{
    if (!_tableNumLabel)
    {
        NSString *str = @"输入桌号";
        CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
        CGRect frame = CGRectMake(_spaceTwo, (kShopMealingOrderTopViewHeight - 20) / 2, fontWidth, 20);
        _tableNumLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _tableNumLabel.text = str;
    }
}

- (void)initWithTableNumTxtField
{
    if (!_tableNumTxtField)
    {
//        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"输入" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = CGRectMake(_tableNumLabel.right + _spaceOne, (kShopMealingOrderTopViewHeight - 30)/2, _txtWidth, 30);
        _tableNumTxtField = [[UITextField alloc] initWithFrame:frame];
        _tableNumTxtField.borderStyle = UITextBorderStyleNone;
        if (kiPhone4 || kiPhone5)
        {
            _tableNumTxtField.font = FONTSIZE_12;
        }
        else
        {
            _tableNumTxtField.font = FONTSIZE_15;
        }
        _tableNumTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
//        _tableNumTxtField.attributedPlaceholder = butedStr;
        _tableNumTxtField.textAlignment = NSTextAlignmentCenter;
//        _tableNumTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _iphoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _tableNumTxtField.returnKeyType = UIReturnKeyDone;
        _tableNumTxtField.delegate = self;
        _tableNumTxtField.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _tableNumTxtField.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _tableNumTxtField.layer.borderWidth = 1;
        _tableNumTxtField.layer.masksToBounds = YES;
        _tableNumTxtField.layer.cornerRadius = 4.;
        [self addSubview:_tableNumTxtField];
    }
}

- (void)initWithDinersNameLabel
{
    if (!_dinersNameLabel)
    {
        NSString *str = @"食客姓名";
//        CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
        CGRect frame = _tableNumLabel.frame;
        frame.origin.x = _tableNumTxtField.right + _spaceTwo;
        _dinersNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinersNameLabel.text = str;
    }
}

- (void)initWithDinersNameTxtField
{
    if (!_dinersNameTxtField)
    {
        //        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"输入" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = _tableNumTxtField.frame;
        frame.origin.x = _dinersNameLabel.right + _spaceOne;
        _dinersNameTxtField = [[UITextField alloc] initWithFrame:frame];
        _dinersNameTxtField.borderStyle = UITextBorderStyleNone;
        if (kiPhone4 || kiPhone5)
        {
            _dinersNameTxtField.font = FONTSIZE_12;
        }
        else
        {
            _dinersNameTxtField.font = FONTSIZE_15;
        }
        _dinersNameTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        //        _tableNumTxtField.attributedPlaceholder = butedStr;
        _dinersNameTxtField.textAlignment = NSTextAlignmentCenter;
//        _dinersNameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        _iphoneTxtField.keyboardType = UIKeyboardTypeNumberPad;
        _dinersNameTxtField.returnKeyType = UIReturnKeyDone;
        _dinersNameTxtField.delegate = self;
        _dinersNameTxtField.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _dinersNameTxtField.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _dinersNameTxtField.layer.borderWidth = 1;
        _dinersNameTxtField.layer.masksToBounds = YES;
        _dinersNameTxtField.layer.cornerRadius = 4.;
        [self addSubview:_dinersNameTxtField];
    }
}

- (void)clickedSearch:(id)sender
{
    if (_searchOrderBlock)
    {
        _searchOrderBlock(_tableNumTxtField.text, _dinersNameTxtField.text);
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
