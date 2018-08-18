/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCBindCardIdViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 15:42
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCBindCardIdViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"

@interface CTCBindCardIdViewController () <UITextFieldDelegate>
{
    UIScrollView *_contentView;
    
    UILabel *_descLabel;
    
    OpenRestaurantBottomView *_bottomView;
    
    /// 用户姓名
    UITextField *_txtNameField;
    
    /// 身份证号
    UITextField *_txtCardField;
}

- (void)initWithContentView;

- (void)initWithDescLabel;

- (void)initWithTxtNameField;

- (void)initWithTxtCardField;

- (void)initWithBottomView;

@end

@implementation CTCBindCardIdViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
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
    
    self.title = @"身份证绑定";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithDescLabel];
    
    [self initWithTxtNameField];
    
    [self initWithTxtCardField];
    
    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    [SVProgressHUD showErrorWithStatus:@"您尚未绑定身份"];
}


- (void)initWithContentView
{
    if (!_contentView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            [weakSelf.view endEditing:YES];
        }];
        [_contentView addGestureRecognizer:tap];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        NSInteger topSpace = [[UIScreen mainScreen] screenWidth] / 4.41176471;
        CGRect frame = CGRectMake(15, topSpace, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.text = @"* 绑定身份信息，请输入姓名和身份证号";
    }
}

- (void)initWithTxtNameField
{
    if (!_txtNameField)
    {
        UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
        NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        
        NSInteger topSpace = [[UIScreen mainScreen] screenWidth] / 1.704545;
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth]-width)/2., topSpace, width, 40);
        _txtNameField = [[UITextField alloc] initWithFrame:frame];
        _txtNameField.font = FONTSIZE_15;
        _txtNameField.delegate = self;
        _txtNameField.textColor = [UIColor colorWithHexString:@"#323232"];
        _txtNameField.keyboardType = UIKeyboardTypeDefault;
        _txtNameField.returnKeyType = UIReturnKeyNext;
        _txtNameField.borderStyle = UITextBorderStyleNone;
//        _txtNameField.placeholder = @"请输入姓名";
        _txtNameField.attributedPlaceholder = placeHolder;
        _txtNameField.textAlignment = NSTextAlignmentCenter;
        _txtNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtNameField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _txtNameField.layer.borderWidth = 1;
        _txtNameField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_contentView addSubview:_txtNameField];
    }
}

- (void)initWithTxtCardField
{
    if (!_txtCardField)
    {
        UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
        NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@"请输入18位的有效身份证号" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        CGRect frame = _txtNameField.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 20;
        _txtCardField = [[UITextField alloc] initWithFrame:frame];
        _txtCardField.font = FONTSIZE_15;
        _txtCardField.delegate = self;
        _txtCardField.textColor = [UIColor colorWithHexString:@"#323232"];
        _txtCardField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _txtCardField.returnKeyType = UIReturnKeyDone;
        _txtCardField.borderStyle = UITextBorderStyleNone;
//        _txtCardField.placeholder = @"请输入18位的有效身份证号";
        _txtCardField.attributedPlaceholder = placeHolder;
        _txtCardField.textAlignment = NSTextAlignmentCenter;
        _txtCardField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtCardField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _txtCardField.layer.borderWidth = 1;
        _txtCardField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_contentView addSubview:_txtCardField];
    }
}


- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _contentView.bottom - [app tabBarHeight], _contentView.width, [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:@"确定"];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchWithSubmit];
    };
}

// 点击确定
- (void)touchWithSubmit
{
//    debugMethod();
    // 姓名
    NSString *userName = objectNull(_txtNameField.text);
    
    // 身份证
    NSString *cardId = objectNull(_txtCardField.text);
    
    if ([objectNull(userName) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    
    if ([objectNull(cardId) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号"];
        return;
    }
    
    
    [HCSNetHttp requestWithUserSetIdentity:userName identifyCard:cardId completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [UserLoginStateObject saveWithCardId:cardId];
            [UserLoginStateObject saveWithUserName:userName];
            
            
            [MCYPushViewController showWithOpenRestaurantZeroVC:self data:nil completion:nil];
        }
        else if (result.errcode == 5)
        {// 已绑定了
            [MCYPushViewController showWithOpenRestaurantZeroVC:self data:nil completion:nil];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
}


#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (kiPhone5)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    }
    else if (kiPhone4)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-140, 0, 0, 0);
    }
    else if (kiPhone6)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_txtNameField isEqual:textField])
    {
        [_txtCardField becomeFirstResponder];
    }
    else if ([_txtCardField isEqual:textField])
    {
        [self.view endEditing:YES];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self touchWithSubmit];
    }
    return YES;
}

@end
















