//
//  ModifyCommonViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/30.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ModifyCommonViewController.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"

@interface ModifyCommonViewController () <UITextFieldDelegate>
{
//    UIView *_backgroundView;
    
    UITextField *_txtField;
    
//    TYZPlaceholderTextView *_multTxtView;
}

@property (nonatomic, strong) CALayer *line;

//- (void)initWithBackgroundView;

- (void)initWithTxtField;

//- (void)initWithMultTxtView;

@end

@implementation ModifyCommonViewController

- (void)dealloc
{
    _txtField.delegate = nil;
//    _multTxtView.delegate = nil;
}

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
    
//    [self initWithBackgroundView];
    
    [self initWithLine];
    
    if (_isSingleRow)
    {
        [self initWithTxtField];
    }
    else
    {
//        [self initWithMultTxtView];
    }
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 60, 0.8);
    line.left = 30;
    line.bottom = 115.0;
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    [self.view.layer addSublayer:line];
    self.line = line;
}


- (void)clickedBack:(id)sender
{
    NSString *str = nil;
    if (_isSingleRow)
    {
        str = _txtField.text;
    }
    else
    {
//        str = _multTxtView.text;
    }
    if (self.popResultBlock)
    {
        self.popResultBlock(str);
    }
    [super clickedBack:sender];
}

- (void)initWithBackgroundView
{
//    CGRect frame = CGRectZero;
//    if (_isSingleRow)
//    {
//        frame = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], 46.0f);
//    }
//    else
//    {
//        frame = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], 140.0f);
//    }
//    _backgroundView = [[UIView alloc] initWithFrame:frame];
//    _backgroundView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:_backgroundView];
    
}

- (void)initWithTxtField
{
    _txtField = [[UITextField alloc] initWithFrame:CGRectMake(_line.left, _line.top - 30, [[UIScreen mainScreen] screenWidth] - _line.left*2, 30)];
    _txtField.font = [UIFont systemFontOfSize:16];
    _txtField.delegate = self;
    _txtField.textColor = [UIColor colorWithHexString:@"#999999"];
    if (_isNumber)
    {
        NSString *str = [NSString stringWithFormat:@"%@", _data];
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
        _txtField.text = _data;
    }
    _txtField.returnKeyType = UIReturnKeyDone;
    _txtField.borderStyle = UITextBorderStyleNone;
    _txtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _txtField.placeholder = _placeholder;
    _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_txtField];
    [_txtField becomeFirstResponder];
}

- (void)initWithMultTxtView
{
    /*CGRect frame = CGRectMake(15.0f, 6.0f, [[UIScreen mainScreen] screenWidth] - (15.0f * 2), 140.0f - 6 * 2);
    _multTxtView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _multTxtView.delegate = self;
    _multTxtView.placeholder = _placeholder;
    _multTxtView.font = [UIFont systemFontOfSize:16];
    _multTxtView.text = _data;
    _multTxtView.textColor = [UIColor colorWithHexString:@"#999999"];
    _multTxtView.returnKeyType = UIReturnKeyDone;
    _multTxtView.keyboardType = UIKeyboardAppearanceDefault;
    [_backgroundView addSubview:_multTxtView];
    [_multTxtView becomeFirstResponder];
     */
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

#pragma mark end UITextFieldDelegate

#pragma mark start UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self clickedBack:nil];
        return NO;
    }
    return YES;
}
#pragma mark end UITextViewDelegate


@end




















