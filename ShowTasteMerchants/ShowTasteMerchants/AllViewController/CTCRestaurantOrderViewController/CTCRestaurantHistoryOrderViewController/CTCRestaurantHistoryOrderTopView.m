/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantHistoryOrderTopView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/23 21:00
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantHistoryOrderTopView.h"
#import "LocalCommon.h"

@interface CTCRestaurantHistoryOrderTopView () <UITextFieldDelegate>
{
    /// 选择日期
    UIButton *_btnChoiceDate;
    
    /// 桌号
    UITextField *_tableNoTxtField;
    
}

- (void)initWithBtnChoiceDate;

- (void)initWithTableNoTxtField;

@end

@implementation CTCRestaurantHistoryOrderTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self initWithBtnChoiceDate];
    
    [self initWithTableNoTxtField];
    
}

- (void)initWithBtnChoiceDate
{
    if (!_btnChoiceDate)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"history-order_btn_date.png"];
        CGRect frame = CGRectMake(0, (kCTCRestaurantHistoryOrderTopViewHeight-image.size.height)/2., image.size.width, image.size.height);
        _btnChoiceDate = [TYZCreateCommonObject createWithButton:self imgNameNor:@"history-order_btn_date" imgNameSel:@"history-order_btn_date" targetSel:@selector(clickedChoiceDate:)];
        _btnChoiceDate.frame = frame;
        _btnChoiceDate.right = [[UIScreen mainScreen] screenWidth] - 10;
        [self addSubview:_btnChoiceDate];
    }
}

- (void)initWithTableNoTxtField
{
    if (!_tableNoTxtField)
    {
        CGRect frame = CGRectMake(_btnChoiceDate.width + 10 + 10 + 30, (kCTCRestaurantHistoryOrderTopViewHeight-30)/2., [[UIScreen mainScreen] screenWidth] - (_btnChoiceDate.width + 10 + 10 + 30)*2, 30);
        _tableNoTxtField = [[UITextField alloc] initWithFrame:frame];
        _tableNoTxtField.font = FONTSIZE_15;
        _tableNoTxtField.delegate = self;
        _tableNoTxtField.textColor = [UIColor colorWithHexString:@"#cccccc"];
        _tableNoTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tableNoTxtField.returnKeyType = UIReturnKeySearch;
        _tableNoTxtField.borderStyle = UITextBorderStyleNone;
        _tableNoTxtField.placeholder = @"请输入台号";
        _tableNoTxtField.textAlignment = NSTextAlignmentCenter;
        _tableNoTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _tableNoTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _tableNoTxtField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
//        _tableNoTxtField.layer.borderWidth = 1;
//        _tableNoTxtField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:_tableNoTxtField];
    }
}

- (void)clickedChoiceDate:(id)sender
{
    if (_choiceDateBlock)
    {
        _choiceDateBlock();
    }
}

- (void)searchContent:(NSString *)str
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(str);
    }
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *str = objectNull(_tableNoTxtField.text);
    if ([str isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入搜索内容"];
        return YES;
    }
    
    [_tableNoTxtField resignFirstResponder];
    
    [self performSelector:@selector(searchContent:) withObject:str afterDelay:0.2];
    
    return YES;
}


@end













