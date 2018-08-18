//
//  RestaurantSingleEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantSingleEditViewController.h"
#import "LocalCommon.h"

@interface RestaurantSingleEditViewController () <UITextFieldDelegate>
{
    UIView *_bgView;
    
    UITextField *_txtField;
}

- (void)initWithBgView;

- (void)initWithTxtField;

@end

@implementation RestaurantSingleEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
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
}

- (void)clickedBack:(id)sender
{
    NSString *str = objectNull(_txtField.text);
    if (self.popResultBlock)
    {
        self.popResultBlock(str);
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
    UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:_placeholder attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    
    _txtField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 30)];
    _txtField.font = [UIFont systemFontOfSize:16];
    _txtField.delegate = self;
    _txtField.textColor = [UIColor colorWithHexString:@"#323232"];
    if (_isNumber)
    {
        NSString *str = [NSString stringWithFormat:@"%@", _content];
        if ([str isEqualToString:@"0"])
        {
            str = nil;
        }
        _txtField.text = str;
        _txtField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    else
    {
        _txtField.keyboardType = UIKeyboardTypeDefault;
        _txtField.text = _content;
    }
    _txtField.returnKeyType = UIReturnKeyDone;
    _txtField.borderStyle = UITextBorderStyleNone;
    _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _txtField.placeholder = _placeholder;
    _txtField.attributedPlaceholder = placeHolder;
    _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_bgView addSubview:_txtField];
    [_txtField becomeFirstResponder];
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
