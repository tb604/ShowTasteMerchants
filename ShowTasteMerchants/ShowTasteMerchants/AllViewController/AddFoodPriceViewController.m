//
//  AddFoodPriceViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddFoodPriceViewController.h"
#import "LocalCommon.h"
#import "ShopFoodUnitDataEntity.h"
#import "TYZComboBox.h"

@interface AddFoodPriceViewController ()
<UITextFieldDelegate, ComboBoxDelegate>
{
    UIView *_bgView;
    
    UITextField *_txtField;
    
    /**
     *  “元”
     */
    UILabel *_yuanLabel;
    
    /**
     *  单位
     */
    TYZComboBox *_unitComboBox;
}

@property (nonatomic, strong) NSMutableArray *comBoList;

- (void)initWithBgView;

- (void)initWithTxtField;

- (void)initWithYuanLabel;

- (void)initWithUnitComboBox;

@end

@implementation AddFoodPriceViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _comBoList = [[NSMutableArray alloc] initWithCapacity:0];
    for (ShopFoodUnitDataEntity *ent in _uintList)
    {
        [_comBoList addObject:ent.unit];
    }
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBgView];
    
    [self initWithTxtField];
    
    [self initWithYuanLabel];
    
    [self initWithUnitComboBox];
}

- (void)clickedBack:(id)sender
{
    NSString *str = objectNull(_txtField.text);
    NSString *unit = objectNull(self.uint);
    if ([unit isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请选择单位"];
        return;
    }
    NSDictionary *param = @{@"price":str, @"unit":unit};
    if (self.popResultBlock)
    {
        self.popResultBlock(param);
    }
    [super clickedBack:sender];
}

- (void)initWithBgView
{
    CGRect frame = CGRectMake(0, 20, [[UIScreen mainScreen] screenWidth], 40);
    _bgView = [[UIView alloc] initWithFrame:frame];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
}

- (void)initWithTxtField
{
    _txtField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth]/2 - 30, 30)];
    _txtField.font = [UIFont systemFontOfSize:16];
    _txtField.delegate = self;
    _txtField.textColor = [UIColor colorWithHexString:@"#999999"];
    NSString *str = [NSString stringWithFormat:@"%@", _content];
    if ([str isEqualToString:@"0"])
    {
        str = nil;
    }
    _txtField.text = str;
    _txtField.keyboardType = UIKeyboardTypeDecimalPad;
    _txtField.returnKeyType = UIReturnKeyDone;
    _txtField.borderStyle = UITextBorderStyleNone;
    _txtField.textAlignment = NSTextAlignmentCenter;
    _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtField.placeholder = _placeholder;
    _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_txtField];
    [_txtField becomeFirstResponder];
}

- (void)initWithYuanLabel
{
    NSString *str = @"元/";
    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(_txtField.right + 2, 0, width, 20);
    _yuanLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _yuanLabel.centerY = _txtField.centerY;
    _yuanLabel.text = str;
}

- (void)initWithUnitComboBox
{
//    debugLog(@"count=%d", (int)_comBoList.count);
    CGFloat width = _bgView.width - _yuanLabel.right - 5 - 15;
    _unitComboBox = [[TYZComboBox alloc] initWithFrame:CGRectMake(_yuanLabel.right + 5, _bgView.top + (_bgView.height-30)/2.0, width, 30)];
    _unitComboBox.listItems = _comBoList;
    _unitComboBox.maxRows = 8;
    _unitComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
    _unitComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _unitComboBox.borderWidth = 1.0f;
    _unitComboBox.cornerRadius = 4.0f;
    _unitComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
    _unitComboBox.delegate = self;
//    _unitComboBox.centerY = _txtField.centerY;
    if ([objectNull(self.uint) isEqualToString:@""])
    {
        _unitComboBox.testString = @"请选择";
    }
    else
    {
        _unitComboBox.testString = self.uint;
    }
    [self.view addSubview:_unitComboBox];
}

#pragma mark ComboBoxDelegate
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = comboBox.listItems[indexPath.row];
    debugLog(@"str=%@", str);
    self.uint = str;
}


#pragma mark start UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [self clickedBack:nil];
    }
    return YES;
}


@end
