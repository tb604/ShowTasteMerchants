//
//  MyRestaurantRoomSpaceAddViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantRoomSpaceAddViewController.h"
#import "LocalCommon.h"
#import "OpenRestaurantBottomView.h"
#import "ShopSeatInfoEntity.h"
#import "UserLoginStateObject.h"

@interface MyRestaurantRoomSpaceAddViewController () <UITextFieldDelegate>
{
    /**
  *  “类名”
  */
    UILabel *_titleLabel;
    
    UITextField *_seatNameTxtField;
    
    UILabel *_descLabel;
    
    UITextField *_descTxtField;
    
    OpenRestaurantBottomView *_bottomView;
}

@property (nonatomic, strong) CALayer *cateoryBottomLine;


- (void)initWithTitleLabel;

- (void)initWithSeatNameTxtField;

- (void)initWithdescLabel;

- (void)initWithDescTxtField;

- (void)initWithCateoryBottomLine;


- (void)initWithBottomView;


@end

@implementation MyRestaurantRoomSpaceAddViewController


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"空间编辑";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithTitleLabel];
    
    [self initWithSeatNameTxtField];
    
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
        NSString *str = @"空间名称";
        CGFloat width = [str widthForFont:FONTSIZE_13 height:20];
        CGRect frame = CGRectMake(15, 20, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = str;
    }
}

- (void)initWithSeatNameTxtField
{
    CGRect frame = CGRectMake(_titleLabel.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 10 - 15, 30);
    _seatNameTxtField = [[UITextField alloc] initWithFrame:frame];
    _seatNameTxtField.font = FONTSIZE_16;
    _seatNameTxtField.delegate = self;
    _seatNameTxtField.textColor = [UIColor colorWithHexString:@"#323232"];
    _seatNameTxtField.keyboardType = UIKeyboardTypeDefault;
    _seatNameTxtField.returnKeyType = UIReturnKeyNext;
    _seatNameTxtField.borderStyle = UITextBorderStyleNone;
    _seatNameTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _seatNameTxtField.textAlignment = NSTextAlignmentCenter;
    _seatNameTxtField.placeholder = @"请输入空间名称";
    if (!_seatEntity.isAdd)
    {
        _seatNameTxtField.text = _seatEntity.name;
    }
    _seatNameTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _seatNameTxtField.centerY = _titleLabel.centerY;
    [self.view addSubview:_seatNameTxtField];
}

- (void)initWithCateoryBottomLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
    line.left = 15;
    line.bottom = _seatNameTxtField.bottom + 5;
    line.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
    [self.view.layer addSublayer:line];
    self.cateoryBottomLine = line;
}

- (void)initWithdescLabel
{
    CGRect frame = _titleLabel.frame;
    frame.origin.y = _cateoryBottomLine.bottom + 10;
    _descLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _descLabel.text = @"预订要求";
}

- (void)initWithDescTxtField
{
    CGRect frame = _seatNameTxtField.frame;
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
    _descTxtField.placeholder = @"请输入空间备注";
    _descTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _descTxtField.centerY = _descTxtField.centerY;
    if (!_seatEntity.isAdd)
    {
        _descTxtField.text = _seatEntity.remark;
    }
    [self.view addSubview:_descTxtField];
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
        [weakSelf saveWithSeatInfo];
    };
}

// 保存空间
- (void)saveWithSeatInfo
{
    
    NSString *seatName = objectNull(_seatNameTxtField.text);
    NSString *seatRemark = objectNull(_descTxtField.text);
    
    
    // requestWithShopSeatSettingAdd
    if ([seatName isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入空间名称"];
        return;
    }
    
    // 提交到服务端
    [SVProgressHUD showWithStatus:@"提交"];
    if (_seatEntity.isAdd)
    {// 添加
        [HCSNetHttp requestWithShopSeatSettingAdd:[UserLoginStateObject getCurrentShopId] name:seatName remark:seatRemark completion:^(id result) {
            [self responseWithShopSeatSettingAdd:result];
        }];
    }
    else
    {// 修改
        [HCSNetHttp requestWithShopSeatSettingSet:_seatEntity.id shopId:[UserLoginStateObject getCurrentShopId] name:seatName remark:seatRemark completion:^(id result) {
            [self responseWithShopSeatSettingSet:result];
        }];
    }
}

/**
 *  添加返回结果
 *
 *  @param respond res
 */
- (void)responseWithShopSeatSettingAdd:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        _seatEntity.id = [respond.data integerValue];
        _seatEntity.name = objectNull(_seatNameTxtField.text);
        _seatEntity.remark = objectNull(_descTxtField.text);
        if (self.popResultBlock)
        {
            self.popResultBlock(_seatEntity);
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
 *  @param respond res
 */
- (void)responseWithShopSeatSettingSet:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
        _seatEntity.name = objectNull(_seatNameTxtField.text);
        _seatEntity.remark = objectNull(_descTxtField.text);
        
        if (self.popResultBlock)
        {
            self.popResultBlock(_seatEntity);
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
    if ([textField isEqual:_seatNameTxtField])
    {
        [_descTxtField becomeFirstResponder];
    }
    else if ([textField isEqual:_descTxtField])
    {
        [self.view endEditing:YES];
        
        [self performSelector:@selector(saveWithSeatInfo) withObject:nil afterDelay:0.4];
        return NO;
    }
    return YES;
}

#pragma mark UITextViewDelegate


@end
