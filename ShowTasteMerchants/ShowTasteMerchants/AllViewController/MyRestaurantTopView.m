//
//  MyRestaurantTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantTopView.h"
#import "LocalCommon.h"


@interface MyRestaurantTopView ()

@property (nonatomic, assign) CGFloat singleWidth;

/**
 *  一条横线
 */
@property (nonatomic, strong) UIImageView *lineImgView;

@property (nonatomic, strong) NSArray *btnTitleList;

@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  selected状态下按钮文字的颜色
 */
@property (nonatomic, strong) UIColor *selectedLabelColor;

/**
 *  normal状态下按钮文字的颜色
 */
@property (nonatomic, strong) UIColor *unselectedLabelColor;

/**
 *  编辑按钮
 */
@property (nonatomic, strong) UIButton *btnEdit;


/**
 *  初始化一条横线
 */
- (void)initWithLineImgView;

/**
 *  初始化水平的蓝色的线条
 */
- (void)initWithHorizontalBlueLine;

- (void)initWithAllButtonView;

- (void)initWithBtnEdit;

- (void)clickedRecommendType:(id)sender;

- (BOOL)selectedIndex:(NSInteger)index;

@end

@implementation MyRestaurantTopView

- (id)initWithFrame:(CGRect)frame btnTitles:(NSArray *)btnTitles
{
    _btnTitleList = btnTitles;
    self = [super initWithFrame:frame];
    if (!self)
    {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame btnTitles:nil];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _buttonLists = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.singleWidth = ([[UIScreen mainScreen] screenWidth] - 15 - 40 - 10) / self.btnTitleList.count;//55.0;//[[UIScreen mainScreen] screenWidth]/self.btnTitleList.count;
    
    self.selectedIndex = 0;
    self.selectedLabelColor = [UIColor colorWithHexString:@"#ff5500"];
    self.unselectedLabelColor = [UIColor colorWithHexString:@"#323232"];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLineImgView];
    
    [self initWithHorizontalBlueLine];
    
    [self initWithAllButtonView];
    
    [self initWithBtnEdit];
    
}

/**
 *  初始化一条横线
 */
- (void)initWithLineImgView
{
    _lineImgView = [[UIImageView alloc] init];
    _lineImgView.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"];
    [self addSubview:_lineImgView];
    _lineImgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineImgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineImgView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lineImgView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineImgView)]];
    addConstraintHeight(_lineImgView, 1);
}

/**
 *  初始化水平的蓝色的线条
 */
- (void)initWithHorizontalBlueLine
{
    float width = _singleWidth;//55.0;//[[UIScreen mainScreen] screenWidth] / _btnTitleList.count;
    CGRect frame = CGRectMake(0, self.bounds.size.height - 2, width, 2.0f);
    _horizontalBlueLine = [[UIImageView alloc] initWithFrame:frame];
    _horizontalBlueLine.backgroundColor = _selectedLabelColor;
    [self addSubview:_horizontalBlueLine];
}

- (void)initWithAllButtonView
{
    int count = (int)[_btnTitleList count];
    //    float width = SCREEN_WIDTH / count;
    CGRect frame = CGRectMake(0, 0, _singleWidth, self.bounds.size.height);
    for (int i=0; i<count; i++)
    {
        frame.origin.x = i*_singleWidth;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.tag = 100 + (i+1);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitle:_btnTitleList[i] forState:UIControlStateNormal];
        [button setTitleColor:_unselectedLabelColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedRecommendType:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttonLists addObject:button];
    }
}

- (void)initWithBtnEdit
{
    if (!_btnEdit)
    {
//        UIImage *image = [UIImage imageNamed:@"kaicanting_btn_compile_nor"];
        CGRect frame = CGRectMake(0, (self.height - 40)/2, 40, 40);
        _btnEdit = [TYZCreateCommonObject createWithButton:self imgNameNor:@"kaicanting_btn_compile_nor" imgNameSel:@"kaicanting_btn_compile_sel" targetSel:@selector(clickedEdit:)];
        _btnEdit.frame = frame;
        _btnEdit.right = [[UIScreen mainScreen] screenWidth];
        [self addSubview:_btnEdit];
    }
}

- (BOOL)selectedIndex:(NSInteger)index
{
//    debugLog(@"selec=%d; index=%d", (int)_selectedIndex, (int)index);
    if (index != _selectedIndex)
    {
        for (UIButton *btn in _buttonLists)
        {
            [btn setTitleColor:_unselectedLabelColor forState:UIControlStateNormal];
        }
        UIButton *dest = _buttonLists[index-1];
        [dest setTitleColor:_selectedLabelColor forState:UIControlStateNormal];
        _selectedIndex = index;
        return YES;
    }
    return NO;
}

- (void)clickedEdit:(id)sender
{
    if (_clickedBtnEditBlock)
    {
        _clickedBtnEditBlock();
    }
}

- (void)clickedRecommendType:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag - 100;
    if ([self selectedIndex:tag])
    {
        if (_clickedButtonBlock)
        {
            _clickedButtonBlock((int)tag);
        }
    }
}

- (void)updateSelectedButtonIndex:(NSInteger)index
{
    _selectedIndex = index;
}

- (void)updateHorizonTalPosition:(NSInteger)index
{
//    debugLog(@"index=%d", (int)index);
    
    for (UIButton *btn in _buttonLists)
    {
        [btn setTitleColor:_unselectedLabelColor forState:UIControlStateNormal];
    }
    
    UIButton *btn = _buttonLists[index-1];
    [btn setTitleColor:_selectedLabelColor forState:UIControlStateNormal];
    CGRect frame = _horizontalBlueLine.frame;
    frame.origin.x = btn.frame.origin.x;
    _horizontalBlueLine.frame = frame;
}


@end
