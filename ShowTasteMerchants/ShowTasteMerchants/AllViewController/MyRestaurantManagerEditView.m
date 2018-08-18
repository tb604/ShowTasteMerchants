//
//  MyRestaurantManagerEditView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerEditView.h"
#import "LocalCommon.h"
#import "MyRestaurantManagerEditSingleView.h"
#import "TYZComboBox.h"
#import "ShopManageInputEntity.h"

@interface MyRestaurantManagerEditView () <UITextFieldDelegate>
{
    
    UILabel *_titleLabel;
    
    /**
     *  姓名视图
     */
//    MyRestaurantManagerEditSingleView *_nameView;
    
    /**
     *  工位视图
     */
    MyRestaurantManagerEditSingleView *_stationView;
    
    /**
     *  手机视图
     */
    MyRestaurantManagerEditSingleView *_mobileView;
    
    /**
     *  “权限”
     */
    UILabel *_permissionTitleLabel;
    
//    TYZComboBox *_permissionComboBox;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *lineTwo;

@property (nonatomic, strong) CALayer *lineThree;

@property (nonatomic, strong) CALayer *lineFour;

@property (nonatomic, strong) CALayer *lineFive;

@property (nonatomic, strong) CALayer *lineVertical;

- (void)initWithLineOne;

- (void)initWithLineTwo;

- (void)initWithLineThree;

- (void)initWithLineFour;

- (void)initWithLineFive;

- (void)initWithLineVertical;

- (void)initWithTitleLabel;

//- (void)initWithNameView;

- (void)initWithStationView;

- (void)initWithMobileView;

/**
 *  权限
 */
- (void)initWithPermissionTitleLabel;

//- (void)initWithPermissionComboBox;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;


@end

@implementation MyRestaurantManagerEditView

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
    
    
    [self initWithLineOne];
    
    [self initWithLineTwo];
    
    [self initWithLineThree];
    
    [self initWithLineFour];
    
    [self initWithLineFive];
    
    [self initWithLineVertical];
    
    [self initWithTitleLabel];
    
//    [self initWithNameView];
    
    [self initWithStationView];
    
    [self initWithMobileView];
    
    // 权限
    [self initWithPermissionTitleLabel];
    
//    [self initWithPermissionComboBox];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
    
}

- (void)initWithLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = 40.0;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.lineOne = line;
}

- (void)initWithLineTwo
{
//    CALayer *line = [CALayer layer];
//    line.size = CGSizeMake(self.width, 0.8);
//    line.left = 0;
//    line.bottom = 40.0*2;
//    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
//    [self.layer addSublayer:line];
//    self.lineTwo = line;
}

- (void)initWithLineThree
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = 40.0*2 + 16;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.lineThree = line;
}

- (void)initWithLineFour
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = 40.0*3 + 16;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.lineFour = line;
}

- (void)initWithLineFive
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = 40.0*4+16*2;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.lineFive = line;
}

- (void)initWithLineVertical
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, self.height - _lineFive.bottom);
    line.left = self.width / 2;
    line.top = _lineFive.bottom;//40.0*4+18;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
    self.lineVertical = line;
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 10, 100, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.text = @"添加";
}

/*- (void)initWithNameView
{
    CGRect frame = CGRectMake(0, _lineOne.bottom, self.width, 40);
    _nameView = [[MyRestaurantManagerEditSingleView alloc] initWithFrame:frame];
//    _nameView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_nameView];
    _nameView.valueTxtField.delegate = self;
    _nameView.valueTxtField.keyboardType = UIKeyboardTypeDefault;
    [_nameView updateWithTitle:@"姓名" value:nil placeholder:@"请输入姓名" returnKeyType:UIReturnKeyDone];
}*/

- (void)initWithStationView
{
    CGRect frame = CGRectMake(0, _lineOne.bottom + 8, self.width, 40);
    _stationView = [[MyRestaurantManagerEditSingleView alloc] initWithFrame:frame];
//    _stationView.backgroundColor = [UIColor purpleColor];
    _stationView.valueTxtField.delegate = self;
    _stationView.valueTxtField.keyboardType = UIKeyboardTypeDefault;
    [self addSubview:_stationView];
    [_stationView updateWithTitle:@"工位" value:nil placeholder:@"请输入工位" returnKeyType:UIReturnKeyNext];
}

- (void)initWithMobileView
{
    CGRect frame = CGRectMake(0, _lineThree.bottom, self.width, 40);
    _mobileView = [[MyRestaurantManagerEditSingleView alloc] initWithFrame:frame];
//    _mobileView.backgroundColor = [UIColor redColor];
    [self addSubview:_mobileView];
    _mobileView.valueTxtField.delegate = self;
    _mobileView.valueTxtField.keyboardType = UIKeyboardTypeDecimalPad;
    [_mobileView updateWithTitle:@"手机" value:nil placeholder:@"请输入手机" returnKeyType:UIReturnKeyDone];
}

/**
 *  权限
 */
- (void)initWithPermissionTitleLabel
{
    NSString *str = @"权限";
    CGFloat width = [str widthForFont:FONTSIZE_12];
    CGRect frame = CGRectMake(15, _lineFour.bottom+18, width, 20);
    _permissionTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    _permissionTitleLabel.text = str;
}

/*- (void)initWithPermissionComboBox
{
    CGFloat y = self.frame.origin.y + kMyRestaurantManagerEditSingleViewHeight * 4;
    CGFloat width = self.width - _permissionTitleLabel.right - 15 - 60;
    _permissionComboBox = [[TYZComboBox alloc] initWithFrame:CGRectMake(0, y + 5, width, 36)];
    _permissionComboBox.listItems = @[@"高级", @"中级", @"初级"];
    _permissionComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
    _permissionComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _permissionComboBox.borderWidth = 1.0f;
    _permissionComboBox.cornerRadius = 4.0f;
    _permissionComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
//    _permissionComboBox.delegate = self;
    _permissionComboBox.centerX = self.width / 2;
//    [self superview]
    [[self superview] addSubview:_permissionComboBox];
}*/

- (void)initWithBtnCancel
{
    CGRect frame = CGRectMake(1, _lineFive.bottom + 1, self.width / 2 - 3, _lineVertical.height - 2);
    _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
    _btnCancel.frame = frame;
    _btnCancel.tag = 100;
    [self addSubview:_btnCancel];
}

- (void)initWithBtnSubmit
{
    CGRect frame = _btnCancel.frame;
    frame.origin.x = _lineVertical.right + 1;
    _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认" titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_16 targetSel:@selector(clickedButton:)];
    _btnSubmit.frame = frame;
    _btnSubmit.tag = 101;
    [self addSubview:_btnSubmit];
}

- (void)clickedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(@(button.tag));
    }
}

- (void)updateWithData:(id)data title:(NSString *)title
{
    self.staffEntity = data;
    _titleLabel.text = title;
    
    if (data)
    {
//        _nameView.valueTxtField.text = _staffEntity.user_name;
        _mobileView.valueTxtField.text = _staffEntity.user_mobile;
    }
}



#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if ([textField isEqual:_nameView.valueTxtField])
//    {
//        [_stationView.valueTxtField becomeFirstResponder];
//    }
//    else if ([textField isEqual:_stationView.valueTxtField])
//    {
//        [_mobileView.valueTxtField becomeFirstResponder];
//    }
//    else if ([textField isEqual:_mobileView.valueTxtField])
//    {
//        [_mobileView.valueTxtField resignFirstResponder];
//    }
    return YES;
}



@end






















