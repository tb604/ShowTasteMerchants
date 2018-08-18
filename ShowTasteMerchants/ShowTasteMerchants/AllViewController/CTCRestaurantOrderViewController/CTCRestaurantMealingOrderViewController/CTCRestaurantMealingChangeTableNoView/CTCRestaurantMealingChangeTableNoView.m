/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingChangeTableNoView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/24 11:41
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingChangeTableNoView.h"
#import "LocalCommon.h"
#import "TYZComboBox.h"
#import "ShopSeatInfoEntity.h"

@interface CTCRestaurantMealingChangeTableNoView () <UITextFieldDelegate, ComboBoxDelegate>
{
    UILabel *_titleLabel;
    
    /// 台号
    UITextField *_tableNoTxtField;
    
    /// 人数
    UITextField *_numberTxtField;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) ShopSeatInfoEntity *seatInfoEntity;

@property (nonatomic, strong) CALayer *leftLine;

@property (nonatomic, strong) CALayer *rightLine;

@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, strong) CALayer *verticalLine;

@property (nonatomic, strong) TYZComboBox *locationComboBox;
@property (nonatomic, strong) NSArray *seatLocList;

- (void)initWithTitleLabel;

- (void)initWithLeftLine;

- (void)initWithRightLine;

/**
 *  初始化台号
 */
- (void)initWithTableNoTxtField;

/**
 *  初始化人数
 */
- (void)initWithNumTxtField;

- (void)initWithBottomLine;

- (void)initWithVerticalLine;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation CTCRestaurantMealingChangeTableNoView

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
    
    [self initWithTitleLabel];
    
    [self initWithLeftLine];
    
    [self initWithRightLine];
    
    // 初始化台号
    [self initWithTableNoTxtField];
    
    // 初始化人数
    [self initWithNumTxtField];
    
    [self initWithBottomLine];
    
    [self initWithVerticalLine];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
    
    [self initWithLocationComboBox];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(0, 30, 100, 16);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.centerX = self.width / 2.;
        _titleLabel.text = @"换台号";
    }
}

- (void)initWithLeftLine
{
    if (!_leftLine)
    {
        CGRect frame = CGRectMake(25, 0, 75, 1);
        CALayer *line = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#323232"]];
        line.centerY = _titleLabel.centerY;
        self.leftLine = line;
    }
}

- (void)initWithRightLine
{
    if (!_rightLine)
    {
        CGRect frame = CGRectMake(25, 0, 75, 1);
        CALayer *line = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#323232"]];
        line.centerY = _titleLabel.centerY;
        line.right = self.width - 25;
        self.rightLine = line;
    }
}

/**
 *  初始化台号
 */
- (void)initWithTableNoTxtField
{
    if (!_tableNoTxtField)
    {
        CGRect frame = CGRectMake(25, 130, self.width - 50, 40);
        _tableNoTxtField = [[UITextField alloc] initWithFrame:frame];
        _tableNoTxtField.font = FONTSIZE_15;
        _tableNoTxtField.delegate = self;
        _tableNoTxtField.textColor = [UIColor colorWithHexString:@"#cccccc"];
        _tableNoTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tableNoTxtField.returnKeyType = UIReturnKeyNext;
        _tableNoTxtField.borderStyle = UITextBorderStyleNone;
        _tableNoTxtField.placeholder = @"请输入台号";
        _tableNoTxtField.textAlignment = NSTextAlignmentCenter;
        _tableNoTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _tableNoTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tableNoTxtField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _tableNoTxtField.layer.borderWidth = 1;
        _tableNoTxtField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:_tableNoTxtField];
    }
}

/**
 *  初始化人数
 */
- (void)initWithNumTxtField
{
    if (!_numberTxtField)
    {
        CGRect frame = _tableNoTxtField.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 20;
        _numberTxtField = [[UITextField alloc] initWithFrame:frame];
        _numberTxtField.font = FONTSIZE_15;
        _numberTxtField.delegate = self;
        _numberTxtField.textColor = [UIColor colorWithHexString:@"#cccccc"];
        _numberTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _numberTxtField.returnKeyType = UIReturnKeyDone;
        _numberTxtField.borderStyle = UITextBorderStyleNone;
        _numberTxtField.placeholder = @"请输入人数";
        _numberTxtField.textAlignment = NSTextAlignmentCenter;
        _numberTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _numberTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberTxtField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _numberTxtField.layer.borderWidth = 1;
        _numberTxtField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:_numberTxtField];
    }
}

- (void)initWithBottomLine
{
    if (!_bottomLine)
    {
        CGRect frame = CGRectMake(0, 0, self.width, 0.5);
        CALayer *line = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        line.bottom = self.height - 40;
        self.bottomLine = line;
    }
}

- (void)initWithVerticalLine
{
    if (!_verticalLine)
    {
        CGRect frame = CGRectMake(0, _bottomLine.bottom, 0.5, 40);
        CALayer *line = [CALayer drawLine:self frame:frame lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        line.centerX = self.width / 2;
        self.verticalLine = line;
    }
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _bottomLine.bottom, self.width / 2, 40);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.tag = 100;
        [self addSubview:_btnCancel];
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = _btnCancel.frame;
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.left = _verticalLine.right;
        _btnSubmit.tag = 101;
        [self addSubview:_btnSubmit];
    }
}

- (void)initWithLocationComboBox
{
    if (!_locationComboBox)
    {
        NSMutableArray *list = [NSMutableArray new];
        for (ShopSeatInfoEntity *ent in _seatLocList)
        {
            [list addObject:ent.name];
        }
        CGRect frame = CGRectMake(25, 0, _numberTxtField.width, 40);
        
        _locationComboBox = [[TYZComboBox alloc] initWithFrame:frame];
        _locationComboBox.listItems = list;
        _locationComboBox.tag = 100;
        _locationComboBox.borderColor = [UIColor colorWithHexString:@"#cccccc"];
        _locationComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _locationComboBox.borderWidth = 1.0f;
        //        _locationComboBox.cornerRadius = 4.0f;
        _locationComboBox.arrowImage = [UIImage imageWithContentsOfFileName:@"order_btn_sprend.png"];//[UIImage imageNamed:@"btn_xialasanjiao"];
        _locationComboBox.delegate = self;
        
        _locationComboBox.bottom = _tableNoTxtField.top - 20;
        [self addSubview:_locationComboBox];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100)
    {// 取消
        if (_touchChangeCancelBlock)
        {
            _touchChangeCancelBlock();
        }
    }
    else
    {// 确认
        NSString *tableNo = objectNull(_tableNoTxtField.text);
        
        NSInteger number = [_numberTxtField.text integerValue];
        
        if ([tableNo isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入桌号"];
            return;
        }
        
        if (number == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入人数"];
            return;
        }
        if (_touchChangeSubmitBlock)
        {
            _touchChangeSubmitBlock(_seatInfoEntity, tableNo, number);
        }
    }
}

#pragma mark -
#pragma mark ComboBoxDelegate
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *seat = comboBox.listItems[indexPath.row];
    //    debugLog(@"seat=%@", seat);
    for (ShopSeatInfoEntity *ent in _seatLocList)
    {
        if ([seat isEqualToString:ent.name])
        {
            self.seatInfoEntity = ent;
            break;
        }
    }
}


/**
 *  更新信息
 *
 *  @param seatList 大厅、、、
 *  @param tableNo 桌号
 *  @param number 人数
 *
 */
- (void)updateWithSeat:(NSArray *)seatList tableNo:(NSString *)tableNo number:(NSInteger)number seatLocId:(NSInteger)seatLocId
{
    self.seatLocList = seatList;
    NSMutableArray *list = [NSMutableArray new];
    for (ShopSeatInfoEntity *ent in _seatLocList)
    {
        if (ent.id == seatLocId)
        {
            self.seatInfoEntity = ent;
        }
        [list addObject:ent.name];
    }
    _locationComboBox.listItems = list;
    if (seatLocId != 0)
    {
        _locationComboBox.testString = _seatInfoEntity.name;
    }
    else
    {
        _locationComboBox.testString = @"请选择空间";
    }
    
    if (![objectNull(tableNo) isEqualToString:@""])
    {
        _tableNoTxtField.text = tableNo;
    }
    
    if (number != 0)
    {
        _numberTxtField.text = [NSString stringWithFormat:@"%d", (int)number];
    }
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if ([_numberTxtField isEqual:textField])
//    {
        if (_textFieldDidBeginEditBlock)
        {
            _textFieldDidBeginEditBlock();
        }
//    }
//    if (kiPhone4)
//    {
//        _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
//    }
//    else if (kiPhone5)
//    {
//        _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
//    }
//    else if (kiPhone6)
//    {
//        _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_numberTxtField isEqual:textField])
    {
        if (_textFieldDidEndEditBlock)
        {
            _textFieldDidEndEditBlock();
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_tableNoTxtField isEqual:textField])
    {
        [_numberTxtField becomeFirstResponder];
    }
    else
    {
        [self endEditing:YES];
//        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return YES;
}



@end

















