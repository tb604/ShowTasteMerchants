/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantTakeOrderViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 15:54
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantTakeOrderViewController.h"
#import "LocalCommon.h"
#import "TYZComboBox.h"
#import "ShopSeatInfoEntity.h"
#import "OpenRestaurantBottomView.h"
#import "RestaurantReservationInputEntity.h"

@interface CTCRestaurantTakeOrderViewController () <ComboBoxDelegate, UITextFieldDelegate>
{
    UIScrollView *_contentView;
    
    UILabel *_descLabel;
    
    UIView *_bgboxView;
    
    /**
     *  空间.大厅、包间
     */
    TYZComboBox *_locationComboBox;
    
    /// 台号输入框
    UITextField *_tableNoTxtField;
    
    /// 人数输入框
    UITextField *_numberTxtField;
    
    OpenRestaurantBottomView *_bottomView;
}

@property (nonatomic, strong) RestaurantReservationInputEntity *inputEntity;

@property (nonatomic, strong) UIScrollView *contentView;

- (void)initWithContentView;

- (void)initWithTitleLabel;

- (void)initWithLocationComboBox;

- (void)initWithTableNoTxtField;

- (void)initWithNumberTxtField;

- (void)initWithBottomView;

@end

@implementation CTCRestaurantTakeOrderViewController

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

#pragma mark -
#pragma mark override

- (void)initWithVar
{
    [super initWithVar];
    
    if (!_inputEntity)
    {
        RestaurantReservationInputEntity *inputEntity = [RestaurantReservationInputEntity new];
        self.inputEntity = inputEntity;
    }
    
//    NSMutableArray *addList = [NSMutableArray new];
//    ShopSeatInfoEntity *ent = [ShopSeatInfoEntity new];
//    ent.name = @"包间";
//    [addList addObject:ent];
//    ent = [ShopSeatInfoEntity new];
//    ent.name = @"大厅";
//    [addList addObject:ent];
//    ent = [ShopSeatInfoEntity new];
//    ent.name = @"过道";
//    [addList addObject:ent];
//    self.seatLocList = addList;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"点菜";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithTitleLabel];
    
    [self initWithBottomView];
    
    [self initWithTableNoTxtField];
    
    [self initWithNumberTxtField];
    
    [self initWithLocationComboBox];
    
    __weak typeof(self)weakSelf = self;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _locationComboBox.top)];
    [_contentView addSubview:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [weakSelf.view endEditing:YES];
        weakSelf.contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
    [topView addGestureRecognizer:tap];
    
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        AppDelegate *app =[UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
//        __weak typeof(self)weakSelf = self;
    }
}

- (void)initWithTitleLabel
{
    if (!_descLabel)
    {
        NSString *str = @"* 点菜下单，需先填写台号和人数";
        float width = [str widthForFont:FONTBOLDSIZE_15];
        NSInteger topSpace = [[UIScreen mainScreen] screenWidth] / 4.41176471;
        if (kiPhone4)
        {
            topSpace = topSpace - 30;
        }
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., topSpace, width, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:_contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.text = str;
    }
}

- (void)initWithLocationComboBox
{
    if (!_locationComboBox)
    {
        ShopSeatInfoEntity *firstEnt = [_seatLocList objectOrNilAtIndex:0];
        if (firstEnt)
        {
            _inputEntity.shopLocation = firstEnt.id;
            _inputEntity.shopLocationNote = firstEnt.name;
        }
        
        NSMutableArray *list = [NSMutableArray new];
        for (ShopSeatInfoEntity *ent in _seatLocList)
        {
            [list addObject:ent.name];
        }
        
        CGFloat y = [[UIScreen mainScreen] screenWidth] / 1.97368421;
        if (kiPhone4)
        {
            y = y - 50;
        }
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., y, width, 40);
        
        _bgboxView = [[UIView alloc] initWithFrame:frame];
//        [_contentView addSubview:_bgboxView];
        
        
        _locationComboBox = [[TYZComboBox alloc] initWithFrame:frame];
        _locationComboBox.listItems = list;
        _locationComboBox.tag = 100;
        _locationComboBox.borderColor = [UIColor colorWithHexString:@"#cccccc"];
        _locationComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _locationComboBox.borderWidth = 1.0f;
//        _locationComboBox.cornerRadius = 4.0f;
        _locationComboBox.arrowImage = [UIImage imageWithContentsOfFileName:@"order_btn_sprend.png"];//[UIImage imageNamed:@"btn_xialasanjiao"];
        _locationComboBox.delegate = self;
        _locationComboBox.testString = (firstEnt? firstEnt.name : @"请选择空间");
        [_contentView addSubview:_locationComboBox];
    }
}

- (void)initWithTableNoTxtField
{
    if (!_tableNoTxtField)
    {
        UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
        NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@"请输入台号" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        
        CGFloat y = [[UIScreen mainScreen] screenWidth] / 1.97368421;
        if (kiPhone4)
        {
            y = y - 50;
        }
        NSInteger width = [[UIScreen mainScreen] screenWidth] / 1.25;
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - width)/2., y + 40 + 20, width, 40);
        _tableNoTxtField = [[UITextField alloc] initWithFrame:frame];
        _tableNoTxtField.font = FONTSIZE_15;
        _tableNoTxtField.delegate = self;
        _tableNoTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _tableNoTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tableNoTxtField.returnKeyType = UIReturnKeyNext;
        _tableNoTxtField.borderStyle = UITextBorderStyleNone;
//        _tableNoTxtField.placeholder = @"请输入台号";
        _tableNoTxtField.attributedPlaceholder = placeHolder;
        _tableNoTxtField.textAlignment = NSTextAlignmentCenter;
        _tableNoTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _tableNoTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tableNoTxtField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _tableNoTxtField.layer.borderWidth = 1;
        _tableNoTxtField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_contentView addSubview:_tableNoTxtField];
    }
}

- (void)initWithNumberTxtField
{
    if (!_numberTxtField)
    {
        UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
        NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:@"请输入人数" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        CGRect frame = _tableNoTxtField.frame;
        frame.origin.y = frame.origin.y + frame.size.height + 20;
        _numberTxtField = [[UITextField alloc] initWithFrame:frame];
        _numberTxtField.font = FONTSIZE_15;
        _numberTxtField.delegate = self;
        _numberTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
        _numberTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _numberTxtField.returnKeyType = UIReturnKeyDone;
        _numberTxtField.borderStyle = UITextBorderStyleNone;
//        _numberTxtField.placeholder = @"请输入人数";
        _numberTxtField.attributedPlaceholder = placeHolder;
        _numberTxtField.textAlignment = NSTextAlignmentCenter;
        _numberTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _numberTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberTxtField.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _numberTxtField.layer.borderWidth = 1;
        _numberTxtField.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_contentView addSubview:_numberTxtField];
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

- (void)touchWithSubmit
{
    if ([objectNull(_inputEntity.shopLocationNote) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请选择空间"];
        return;
    }
    
    // 台号
    NSString *tableNo = objectNull(_tableNoTxtField.text);
    
    // 人数
    NSInteger number = [_numberTxtField.text integerValue];
    
    if ([tableNo isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入台号"];
        return;
    }
    
    if (number == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入就餐人数"];
        return;
    }
    
//    RestaurantReservationInputEntity
    _inputEntity.tableNo = tableNo; // 桌号
    _inputEntity.number = number; // 人数
     _inputEntity.userId = [UserLoginStateObject getUserId];
     _inputEntity.shopId = _shopDetailEntity.details.shopId;
     _inputEntity.shopName = _shopDetailEntity.details.name;
     _inputEntity.shopMobile = _shopDetailEntity.details.mobile;
     _inputEntity.shopAddress = _shopDetailEntity.details.address;
     _inputEntity.addType = 1; // 表示点餐
     _inputEntity.type = 2; // 1预定；2即时
    
     // 点击进入及时，就餐视图控制器
     [MCYPushViewController showWithRecipeVC:self data:_inputEntity completion:nil];
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
            _inputEntity.shopLocation = ent.id;
            _inputEntity.shopLocationNote = ent.name;
            break;
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (kiPhone4)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
    }
    else if (kiPhone5)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
    }
    else if (kiPhone6)
    {
        _contentView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
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
        [self.view endEditing:YES];
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return YES;
}

@end


















