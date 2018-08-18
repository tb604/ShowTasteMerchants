//
//  ShopReservationOrderTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopReservationOrderTopView.h"
#import "LocalCommon.h"
#import "TYZComboBox.h"

@interface ShopReservationOrderTopView () <UITextFieldDelegate, ComboBoxDelegate>
{
    /**
     *  搜索
     */
    UIButton *_btnSearch;
    
    /**
     *  “到店日期”
     */
    UILabel *_arriveDateLabel;
    
    /**
     *  到店日期
     */
    UILabel *_arriveDateValueLabel;
    
    /**
     *  “订单类型”
     */
    UILabel *_orderTypeLabel;
    
    /**
     *  订单类型
     */
    TYZComboBox *_orderTypeComboBox;
    
    /**
     *  “食客姓名”
     */
    UILabel *_dinersNameLabel;
    
    UITextField *_dinersNameTxtField;
    
    CGFloat _txtWidth;
    
    CGFloat _spaceOne;
    
    CGFloat _spaceTwo;
    
}

/**
 *  订单类型
 */
@property (nonatomic, copy) NSString *orderType;

- (void)initWithBtnSearch;

- (void)initWithArriveDateLabel;

- (void)initWithArriveDateValueLabel;

- (void)initWithOrderTypeLabel;

- (void)initWithOrderTypeComboBox;

- (void)initWithDinersNameLabel;

- (void)initWithDinersNameTxtField;

- (void)tapGesture:(UITapGestureRecognizer *)tap;


@end


@implementation ShopReservationOrderTopView

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
    
    [self initWithArriveDateValueLabel];
    
    [self initWithOrderTypeLabel];
    
//    [self initWithOrderTypeComboBox];
    
    [self initWithDinersNameLabel];
    
    [self initWithDinersNameTxtField];
    
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

- (void)initWithArriveDateValueLabel
{
    if (!_arriveDateValueLabel)
    {
        CGRect frame = CGRectMake(_arriveDateLabel.right + _spaceOne, 5, _txtWidth, 30);
        _arriveDateValueLabel = [[UILabel alloc] initWithFrame:frame];
        if (kiPhone4 || kiPhone5)
        {
            _arriveDateValueLabel.font = FONTSIZE_12;
        }
        else
        {
            _arriveDateValueLabel.font = FONTSIZE_15;
        }
        _arriveDateValueLabel.textColor = [UIColor colorWithHexString:@"#323232"];
        _arriveDateValueLabel.textAlignment = NSTextAlignmentCenter;
        _arriveDateValueLabel.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _arriveDateValueLabel.layer.borderColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
        _arriveDateValueLabel.layer.borderWidth = 1;
        _arriveDateValueLabel.layer.masksToBounds = YES;
        _arriveDateValueLabel.layer.cornerRadius = 4.;
        _arriveDateValueLabel.userInteractionEnabled = YES;
        
        NSDate *date = [NSDate date];
        _arriveDateValueLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
        
        [self addSubview:_arriveDateValueLabel];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_arriveDateValueLabel addGestureRecognizer:tap];
}

- (void)initWithOrderTypeLabel
{
    if (!_orderTypeLabel)
    {
        NSString *str = @"订单类型";
        if (kiPhone4 || kiPhone5)
        {
            str = @"类型";
        }
        CGFloat width = [str widthForFont:FONTSIZE_12];
        CGRect frame = _arriveDateLabel.frame;
        frame.size.width = width;
        frame.origin.x = _arriveDateValueLabel.right + _spaceTwo;
        _orderTypeLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _orderTypeLabel.text = str;
    }
}

- (void)initWithOrderTypeComboBox
{
    /*if (!_orderTypeComboBox)
    {
        CGRect frame = _arriveDateValueLabel.frame;
        frame.origin.x = _orderTypeLabel.right + _spaceOne;
        
        _orderTypeComboBox = [[TYZComboBox alloc] initWithFrame:frame];
//        订单状态 0：全部订单 1：待确认 2：待预付 4：预订完成
        _orderTypeComboBox.listItems = @[@"全部", @"待确认", @"待预付", @"预订完成"];
        _orderTypeComboBox.tag = 100;
        _orderTypeComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
        _orderTypeComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _orderTypeComboBox.borderWidth = 1.0f;
        _orderTypeComboBox.cornerRadius = 4.0f;
        _orderTypeComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
        _orderTypeComboBox.delegate = self;
        _orderTypeComboBox.testString = @"全部";
        [[self superview] addSubview:_orderTypeComboBox];
    }
    self.orderType = @"全部";
    
    __weak typeof(self)weakSelf = self;
    _orderTypeComboBox.clickedCobBoxBlock = ^(TYZComboBox *comboBox, NSInteger type)
    {// type 1表示显示；2表示隐藏
        [weakSelf touchWithCobBox:type];
    };
    */
}

/**
 *
 *
 *  @param type 1表示显示；2表示隐藏
 */
- (void)touchWithCobBox:(NSInteger)type
{
    if (type == 1)
    {
        CGRect frame = _dinersNameTxtField.frame;
        frame.size.width = frame.size.width - _orderTypeComboBox.width;
        _dinersNameTxtField.frame = frame;
    }
    else if (type == 2)
    {
        CGRect frame = _dinersNameTxtField.frame;
        frame.size.width = frame.size.width + _orderTypeComboBox.width;
        _dinersNameTxtField.frame = frame;
    }
}

- (void)initWithDinersNameLabel
{
    if (!_dinersNameLabel)
    {
        NSString *str = @"食客姓名";
        CGRect frame = _arriveDateLabel.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 5+5+5;
        _dinersNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _dinersNameLabel.text = str;
    }

}

- (void)initWithDinersNameTxtField
{
    if (!_dinersNameTxtField)
    {
        CGRect frame = CGRectMake(_dinersNameLabel.right + _spaceOne, _arriveDateValueLabel.bottom + 5, _btnSearch.left - _dinersNameLabel.right  - _spaceTwo - _spaceOne, 30);
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

- (void)clickedSearch:(id)sender
{
    NSString *arriveDate = objectNull(_arriveDateValueLabel.text);
    NSString *name = objectNull(_dinersNameTxtField.text);
    if (_searchOrderBlock)
    {
        _searchOrderBlock(arriveDate, _orderType, name);
    }
}

- (NSString *)getWithDate
{
    return _arriveDateValueLabel.text;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    NSString *str = _arriveDateValueLabel.text;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(str);
    }
}

- (void)updateViewData:(id)entity
{
    if (!entity)
    {
        NSDate *date = [NSDate date];
        _arriveDateValueLabel.text = [date stringWithFormat:@"yyyy-MM-dd"];
    }
    else
    {
        _arriveDateValueLabel.text = entity;
    }
}

#pragma mark ComboBoxDelegate
//- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *str = comboBox.listItems[indexPath.row];
//    self.orderType = str;
//}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end















