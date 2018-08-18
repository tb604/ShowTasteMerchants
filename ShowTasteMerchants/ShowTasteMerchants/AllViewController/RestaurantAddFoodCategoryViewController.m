//
//  RestaurantAddFoodCategoryViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantAddFoodCategoryViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"
#import "ShopFoodCategoryDataEntity.h"

@interface RestaurantAddFoodCategoryViewController () <UITextFieldDelegate, UITextViewDelegate>
{
    
    /**
     *  “类名”
     */
    UILabel *_titleLabel;
    
    UITextField *_categoryTxtField;
    
    UILabel *_descLabel;
    
    UITextField *_descTxtField;
    
    
    OpenRestaurantBottomView *_bottomView;
}

@property (nonatomic, strong) CALayer *cateoryBottomLine;


- (void)initWithTitleLabel;

- (void)initWithCategoryTxtField;

- (void)initWithdescLabel;

- (void)initWithDescTxtField;

- (void)initWithCateoryBottomLine;


- (void)initWithBottomView;


@end

@implementation RestaurantAddFoodCategoryViewController

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    self.title = @"添加类别";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
    
    [self initWithCategoryTxtField];
    
    [self initWithCateoryBottomLine];
    
    [self initWithdescLabel];
    
    [self initWithDescTxtField];
    
    [self initWithDescBottomLine];
    
    [self initWithBottomView];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"类名";
        CGFloat width = [str widthForFont:FONTSIZE_13 height:20];
        CGRect frame = CGRectMake(15, 20, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = str;
    }
}

- (void)initWithCategoryTxtField
{
    CGRect frame = CGRectMake(_titleLabel.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 10 - 15, 30);
    _categoryTxtField = [[UITextField alloc] initWithFrame:frame];
    _categoryTxtField.font = FONTSIZE_16;
    _categoryTxtField.delegate = self;
    _categoryTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
    _categoryTxtField.keyboardType = UIKeyboardTypeDefault;
    _categoryTxtField.returnKeyType = UIReturnKeyNext;
    _categoryTxtField.borderStyle = UITextBorderStyleNone;
    _categoryTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _categoryTxtField.textAlignment = NSTextAlignmentCenter;
    _categoryTxtField.placeholder = @"请输入类别";
    if (!_categoryEntity.isAdd)
    {
        _categoryTxtField.text = _categoryEntity.name;
    }
    _categoryTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _categoryTxtField.centerY = _titleLabel.centerY;
    [self.view addSubview:_categoryTxtField];
    if (!_categoryEntity.isAdd)
    {
        _categoryTxtField.text = _categoryEntity.name;
    }
}

- (void)initWithCateoryBottomLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
    line.left = 15;
    line.bottom = _categoryTxtField.bottom + 5;
    line.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
    [self.view.layer addSublayer:line];
    self.cateoryBottomLine = line;
}

- (void)initWithdescLabel
{
    CGRect frame = _titleLabel.frame;
    frame.origin.y = _cateoryBottomLine.bottom + 10;
    _descLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _descLabel.text = @"备注";
}

- (void)initWithDescTxtField
{
    CGRect frame = _categoryTxtField.frame;
    frame.origin.y = _cateoryBottomLine.bottom + 5;
    _descTxtField = [[UITextField alloc] initWithFrame:frame];
    _descTxtField.font = FONTSIZE_16;
    _descTxtField.delegate = self;
    _descTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
    _descTxtField.keyboardType = UIKeyboardTypeDefault;
    _descTxtField.returnKeyType = UIReturnKeyDone;
    _descTxtField.borderStyle = UITextBorderStyleNone;
    _descTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _descTxtField.textAlignment = NSTextAlignmentCenter;
    _descTxtField.placeholder = @"请输入备注";
    _descTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _descTxtField.centerY = _descTxtField.centerY;
    if (!_categoryEntity.isAdd)
    {
        _descTxtField.text = _categoryEntity.remark;
    }
    [self.view addSubview:_descTxtField];
    if (!_categoryEntity.isAdd)
    {
        _descTxtField.text = _categoryEntity.remark;
    }
}

- (void)initWithDescBottomLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
    line.left = 15;
    line.bottom = _descLabel.bottom + 10;
    line.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
    [self.view.layer addSublayer:line];
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0,[[UIScreen mainScreen] screenHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT - [app navBarHeight], [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5600"];
        [_bottomView updateViewData:@"保存"];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf saveWithCategory];
    };
}

// 保存菜品类型
- (void)saveWithCategory
{
    NSString *category = objectNull(_categoryTxtField.text);
    if ([category isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入类别"];
        return;
    }
    
    _categoryEntity.name = category;
    _categoryEntity.remark = objectNull(_descTxtField.text);
    
    // 提交到服务端
    [SVProgressHUD showWithStatus:@"提交"];
    if (_categoryEntity.isAdd)
    {// 添加
        [HCSNetHttp requestWithFoodCategoryAdd:_categoryEntity completion:^(id result) {
            [self responseWithFoodCategoryAdd:result];
        }];
    }
    else
    {// 修改
        [HCSNetHttp requestWithFoodCategorySetCategory:_categoryEntity completion:^(id result) {
            [self responseWithFoodCategorySetCategory:result];
        }];
    }
}

/**
 *  添加返回结果
 *
 *  @param respond respond
 */
- (void)responseWithFoodCategoryAdd:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        ShopFoodCategoryDataEntity *retEnt = respond.data;
        retEnt.isAdd = _categoryEntity.isAdd;
        if (self.popResultBlock)
        {
            self.popResultBlock(retEnt);
        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.8];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  修改返回节
 *
 *  @param respond d
 */
- (void)responseWithFoodCategorySetCategory:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
        ShopFoodCategoryDataEntity *retEnt = [ShopFoodCategoryDataEntity new];
        retEnt.id = _categoryEntity.categoryId;
        retEnt.shop_id = _categoryEntity.shopid;
        retEnt.name = _categoryEntity.name;
        retEnt.type = _categoryEntity.type;
        retEnt.state = _categoryEntity.state;
        retEnt.remark = _categoryEntity.remark;
        retEnt.sort_index = _categoryEntity.sortIndex;
        retEnt.isAdd = _categoryEntity.isAdd;
        
        if (self.popResultBlock)
        {
            self.popResultBlock(retEnt);
        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.8];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_categoryTxtField])
    {
        [_descTxtField becomeFirstResponder];
    }
    else if ([textField isEqual:_descTxtField])
    {
        [self.view endEditing:YES];
        [self performSelector:@selector(saveWithCategory) withObject:nil afterDelay:1];
        return NO;
    }
    return YES;
}

#pragma mark UITextViewDelegate


@end
