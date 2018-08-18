//
//  MyRestaurantManagerEditViewBg.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerEditViewBg.h"
#import "LocalCommon.h"
#import "MyRestaurantManagerEditView.h"
#import "TYZComboBox.h"
#import "ShopPositionDataEntity.h"
#import "UserLoginStateObject.h"
#import "ShopManageDataEntity.h"

@interface MyRestaurantManagerEditViewBg () <ComboBoxDelegate>
{
    MyRestaurantManagerEditView *_managerView;
    
    /**
     *  岗位选择
     */
    TYZComboBox *_postNameComboBox;
    
    /**
     *  权限选择
     */
    TYZComboBox *_permissionComboBox;
}

@property (nonatomic, strong) ShopManageDataEntity *staffEntity;

@property (nonatomic, strong) ShopManageInputEntity *inputEnt;

@property (nonatomic, strong) MyRestaurantManagerEditView *managerView;

@property (nonatomic, strong) TYZComboBox *permissionComboBox;

- (void)initWithSubView;

- (void)initWithManagerView;

/**
 *  初始化岗位选择
 */
- (void)initWithPostNameComboBox;

/**
 *  初始化权限选择
 */
- (void)initWithPermissionComboBox;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation MyRestaurantManagerEditViewBg

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    
    _inputEnt = [ShopManageInputEntity new];
    
//    [self initWithManagerView];
//    
//    [self initWithPermissionComboBox];
    
    CGRect frame = CGRectMake(0, _managerView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _managerView.bottom);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:tap];
}

- (void)initWithManagerView
{
    if (!_managerView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(30, [app navBarHeight] + STATUSBAR_HEIGHT + 30 +5, [[UIScreen mainScreen] screenWidth] - 60, 263 - 24);
        _managerView = [[MyRestaurantManagerEditView alloc] initWithFrame:frame];
        _managerView.layer.masksToBounds = YES;
        _managerView.layer.cornerRadius = 4.0;
        [self addSubview:_managerView];
    }
    
    __weak typeof(self)weakSelf = self;
    _managerView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.editViewBlock)
        {
            NSInteger tag = [data integerValue];
            if (tag == 100)
            {// 取消
                weakSelf.editViewBlock(nil);
            }
            else
            {// 确认
                weakSelf.inputEnt.opUserId = [UserLoginStateObject getUserId];
                weakSelf.inputEnt.shopId = [UserLoginStateObject getCurrentShopId];
                weakSelf.inputEnt.mobile = weakSelf.managerView.mobileView.valueTxtField.text;
                weakSelf.editViewBlock(weakSelf.inputEnt);
            }
        }
    };
}

/**
 *  初始化岗位选择
 */
- (void)initWithPostNameComboBox
{
    NSMutableArray *list = [NSMutableArray new];
    for (ShopPositionDataEntity *ent in _postionAuthEntity.title)
    {
        if (![ent.name isEqualToString:@"创建者"])
        {
            [list addObject:ent.name];
        }
    }
    
    if (!_postNameComboBox)
    {
        CGFloat y = _managerView.top + 40 * 1;
        NSString *str = @"工位";
        CGFloat fontWidth = [str widthForFont:FONTSIZE_12];
        CGFloat width = self.width - fontWidth - 15*2 - 60 - 60;
        _postNameComboBox = [[TYZComboBox alloc] initWithFrame:CGRectMake(30 + 15 + fontWidth + 30, y + 10, width, 34)];
        _postNameComboBox.listItems = list;
        _postNameComboBox.tag = 100;
        _postNameComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
        _postNameComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _postNameComboBox.borderWidth = 1.0f;
        _postNameComboBox.cornerRadius = 4.0f;
        _postNameComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
        _postNameComboBox.delegate = self;
        _postNameComboBox.centerX = self.width / 2;
        if (_staffEntity)
        {
            _inputEnt.title = _staffEntity.user_title_id;
            _postNameComboBox.testString = _staffEntity.user_title;
        }
        else
        {
            _postNameComboBox.testString = @"请选择";
        }
        [self addSubview:_postNameComboBox];
    }
    __weak typeof(self)weakSelf = self;
    _postNameComboBox.clickedCobBoxBlock = ^(TYZComboBox *comboBox, NSInteger type)
    {// type 1表示显示；2表示隐藏
        if (type == 1)
        {// 显示
            weakSelf.permissionComboBox.hidden = YES;
        }
        else
        {// 隐藏
            weakSelf.permissionComboBox.hidden = NO;
        }
    };
}

- (void)initWithPermissionComboBox
{
    NSMutableArray *list = [NSMutableArray new];
    for (ShopPositionDataEntity *ent in _postionAuthEntity.auth)
    {
        
        [list addObject:ent.name];
    }
    if (!_permissionComboBox)
    {
        CGFloat y = _managerView.top + 40 * 3 + 16;
        NSString *str = @"权限";
        CGFloat fontWidth = [str widthForFont:FONTSIZE_12];
        CGFloat width = self.width - fontWidth - 15*2 - 60 - 60;
        _permissionComboBox = [[TYZComboBox alloc] initWithFrame:CGRectMake(30 + 15 + fontWidth + 30, y + 10, width, 34)];
        _permissionComboBox.listItems = list;
        _permissionComboBox.tag = 101;
        _permissionComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
        _permissionComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _permissionComboBox.borderWidth = 1.0f;
        _permissionComboBox.cornerRadius = 4.0f;
        _permissionComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
        _permissionComboBox.delegate = self;
        _permissionComboBox.centerX = self.width / 2;
        if (_staffEntity)
        {
            _permissionComboBox.testString = _staffEntity.user_auth;
            _inputEnt.auth = _staffEntity.user_auth_id;
        }
        else
        {
            _permissionComboBox.testString = @"请选择";
        }
        [self addSubview:_permissionComboBox];
    }
}

#pragma mark ComboBoxDelegate
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (comboBox.tag == 100)
    {// 职位
        NSString *str = comboBox.listItems[indexPath.row];
        for (ShopPositionDataEntity *ent in _postionAuthEntity.title)
        {
            if ([ent.name isEqualToString:str])
            {
                _inputEnt.title = ent.id;
                break;
            }
        }
    }
    else if (comboBox.tag == 101)
    {// 权限
        NSString *str = comboBox.listItems[indexPath.row];
        for (ShopPositionDataEntity *ent in _postionAuthEntity.auth)
        {
            if ([ent.name isEqualToString:str])
            {
                _inputEnt.auth = ent.id;
                break;
            }
        }
    }
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
    
//    if (self.editViewBlock)
//    {
//        self.editViewBlock(nil);
//    }
}

- (void)updateWithData:(id)data title:(NSString *)title
{
    self.staffEntity = data;
    [self initWithManagerView];
    [_managerView updateWithData:data title:title];
    
    // 初始化岗位选择
    [self initWithPostNameComboBox];
    
    [self initWithPermissionComboBox];
}


@end
