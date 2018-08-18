//
//  ShopFinishOrderTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopFinishOrderTopView.h"
#import "LocalCommon.h"

@interface ShopFinishOrderTopView () <UITextFieldDelegate>
{
    /**
     *  搜索
     */
    UIButton *_btnSearch;
    
    /**
     *  “到店日期”
     */
    UILabel *_arriveDateLabel;
    
    UILabel *_arriveDateTxtField;
    
    /**
     *  “食客姓名”
     */
    UILabel *_dinersNameLabel;
    
    UITextField *_dinersNameTxtField;
    
    /**
     *  “订单编号”
     */
    UILabel *_orderNoLabel;
    
    UITextField *_orderNoTxtField;
    
    CGFloat _txtWidth;
    
    CGFloat _spaceOne;
    
    CGFloat _spaceTwo;

    
}

- (void)initWithBtnSearch;

- (void)initWithArriveDateLabel;

- (void)initWithArriveDateTxtField;

- (void)initWithDinersNameLabel;

- (void)initWithDinersNameTxtField;

- (void)initWithOrderNoLabel;

- (void)initWithOrderNoTxtField;

- (void)tapGesture:(UITapGestureRecognizer *)tap;


@end

@implementation ShopFinishOrderTopView

- (void)initWithVar
{
    [super initWithVar];
    
    CGFloat btnWidth = 60;
    
    if (kiPhone4 || kiPhone5)
    {
        _spaceTwo = 6;
        _spaceOne = 3;
        btnWidth = 50;
    }
    else
    {
        _spaceTwo = 15;
        _spaceOne = 5;
    }
    
    CGFloat width = [[UIScreen mainScreen] screenWidth] - btnWidth - _spaceTwo * 2 - _spaceTwo - _spaceOne * 2;
    NSString *str = @"输入桌号";
    CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
    _txtWidth = (width - fontWidth * 2) / 2;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithBtnSearch];
    
    [self initWithArriveDateLabel];
    
    [self initWithArriveDateTxtField];
    
    [self initWithDinersNameLabel];
    
    [self initWithDinersNameTxtField];
    
    [self initWithOrderNoLabel];
    
    [self initWithOrderNoTxtField];
    
}

- (void)initWithBtnSearch
{
    CGFloat width = 60;
    if (kiPhone4 || kiPhone5)
    {
        width = 50;
    }
    CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width, 0, width, self.height);
    _btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSearch setImage:[UIImage imageNamed:@"order_icon_search"] forState:UIControlStateNormal];
    [_btnSearch addTarget:self action:@selector(clickedSearch:) forControlEvents:UIControlEventTouchUpInside];
    _btnSearch.frame = frame;
    _btnSearch.backgroundColor = [UIColor colorWithHexString:@"#ff5701"];
    [self addSubview:_btnSearch];
}


- (void)initWithArriveDateLabel
{
    if (!_arriveDateLabel)
    {
        NSString *str = @"到店日期";
        CGFloat fontWidth = [str widthForFont:FONTSIZE(12)];
        CGRect frame = CGRectMake(_spaceTwo, 10, fontWidth, 20);
        _arriveDateLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _arriveDateLabel.text = str;
    }
}

- (void)initWithArriveDateTxtField
{
    if (!_arriveDateTxtField)
    {
        CGRect frame = CGRectMake(_arriveDateLabel.right + _spaceOne, 5, _txtWidth, 30);
        _arriveDateTxtField = [[UILabel alloc] initWithFrame:frame];
//        _arriveDateTxtField.borderStyle = UITextBorderStyleNone;
        if (kiPhone4 || kiPhone5)
        {
            _arriveDateTxtField.font = FONTSIZE_12;
        }
        else
        {
            _arriveDateTxtField.font = FONTSIZE_15;
        }
        _arriveDateTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        //        _tableNumTxtField.attributedPlaceholder = butedStr;
        _arriveDateTxtField.textAlignment = NSTextAlignmentCenter;
        _arriveDateTxtField.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _arriveDateTxtField.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _arriveDateTxtField.layer.borderWidth = 1;
        _arriveDateTxtField.layer.masksToBounds = YES;
        _arriveDateTxtField.layer.cornerRadius = 4.;
//        _arriveDateTxtField.enabled = NO;
        _arriveDateTxtField.userInteractionEnabled = YES;
        
        NSDate *date = [NSDate date];
        _arriveDateTxtField.text = [date stringWithFormat:@"yyyy-MM-dd"];
        
        [self addSubview:_arriveDateTxtField];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_arriveDateTxtField addGestureRecognizer:tap];
}

- (void)initWithDinersNameLabel
{
    if (!_dinersNameLabel)
    {
        NSString *str = @"食客姓名";
        CGRect frame = _arriveDateLabel.frame;
        frame.origin.x = _arriveDateTxtField.right + _spaceTwo;
        _dinersNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinersNameLabel.text = str;
    }
}

- (void)initWithDinersNameTxtField
{
    if (!_dinersNameTxtField)
    {
        //        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"输入" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
        CGRect frame = _arriveDateTxtField.frame;
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
        _dinersNameTxtField.textAlignment = NSTextAlignmentCenter;
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

- (void)initWithOrderNoLabel
{
    if (!_orderNoLabel)
    {
        NSString *str = @"订单编号";
        CGRect frame = _arriveDateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 5+5+5;
        _orderNoLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _orderNoLabel.text = str;
//        _orderNoLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)initWithOrderNoTxtField
{
    if (!_orderNoTxtField)
    {
        CGRect frame = CGRectMake(_orderNoLabel.right + _spaceOne, _dinersNameTxtField.bottom + 5, _btnSearch.left - _orderNoLabel.right  - _spaceTwo - _spaceOne, 30);
        _orderNoTxtField = [[UITextField alloc] initWithFrame:frame];
        _orderNoTxtField.borderStyle = UITextBorderStyleNone;
        if (kiPhone4 || kiPhone5)
        {
            _orderNoTxtField.font = FONTSIZE_12;
        }
        else
        {
            _orderNoTxtField.font = FONTSIZE_15;
        }
        _orderNoTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _orderNoTxtField.textAlignment = NSTextAlignmentCenter;
        _orderNoTxtField.returnKeyType = UIReturnKeyDone;
        _orderNoTxtField.delegate = self;
        _orderNoTxtField.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _orderNoTxtField.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _orderNoTxtField.layer.borderWidth = 1;
        _orderNoTxtField.layer.masksToBounds = YES;
        _orderNoTxtField.layer.cornerRadius = 4.;
        [self addSubview:_orderNoTxtField];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    NSString *str = _arriveDateTxtField.text;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(str);
    }
}

- (NSString *)getWithDate
{
    return _arriveDateTxtField.text;
}

- (void)updateViewData:(id)entity
{
    _arriveDateTxtField.text = entity;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)clickedSearch:(id)sender
{
    debugMethod();
    NSString *arriveDate = objectNull(_arriveDateTxtField.text);
    NSString *name = objectNull(_dinersNameTxtField.text);
    NSString *orderNo = objectNull(_orderNoTxtField.text);
    
    if (_searchOrderBlock)
    {
        _searchOrderBlock(arriveDate, name, orderNo);
    }
    
}


@end
