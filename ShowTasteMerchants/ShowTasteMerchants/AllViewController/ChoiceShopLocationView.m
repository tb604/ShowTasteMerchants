//
//  ChoiceShopLocationView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ChoiceShopLocationView.h"
#import "LocalCommon.h"
#import "ShopSeatInfoEntity.h"

@interface ChoiceShopLocationView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *_locationPicker;
    
    NSMutableArray *_locationLists;
    
    UIView *_toolView;
}

//@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) ShopSeatInfoEntity *location;


- (void)initWithSubView;

- (void)initWithLocationPicker;

- (void)initWithToolView;

- (void)initWithButtons;


@end

@implementation ChoiceShopLocationView

- (void)dealloc
{
    _locationPicker.dataSource = nil;
    _locationPicker.delegate = nil;
}


- (id)initWithFrame:(CGRect)frame locationList:(NSArray *)locationList
{
    _locationLists = [NSMutableArray arrayWithArray:locationList];
    if (self = [super initWithFrame:frame])
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    
    [self initWithLocationPicker];
    
    [self initWithToolView];
    
    [self initWithButtons];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _toolView.top)];
    [self addSubview:bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [bgView addGestureRecognizer:tap];
    
    self.location = [_locationLists objectOrNilAtIndex:0];
    
    [self updateWithLocation:nil];
}

- (void)initWithLocationPicker
{
    CGRect frame = CGRectMake(0.0f, 44.0f, [[UIScreen mainScreen] screenWidth], 216.0f);
    _locationPicker = [[UIPickerView alloc] initWithFrame:frame];
    _locationPicker.dataSource = self;
    _locationPicker.delegate = self;
    _locationPicker.backgroundColor = [UIColor whiteColor];
    _locationPicker.bottom = self.bounds.size.height;
    [self addSubview:_locationPicker];
}

- (void)initWithToolView
{
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 44)];
    _toolView.backgroundColor = [UIColor whiteColor];
    _toolView.bottom = _locationPicker.top;
    [self addSubview:_toolView];
}

- (void)initWithButtons
{
    UIButton *btnLeft = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
    btnLeft.left = 5;
    btnLeft.tag = 100;
    btnLeft.size = CGSizeMake(60, 30);
    btnLeft.centerY = _toolView.height/2;
    //    btnLeft.backgroundColor = [UIColor orangeColor];
    [_toolView addSubview:btnLeft];
    
    CGRect frame = btnLeft.frame;
    UIButton *btnRight = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确定" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_15 targetSel:@selector(clickedButton:)];
    btnRight.frame = frame;
    btnRight.right = [[UIScreen mainScreen] screenWidth] - 5;
    btnRight.tag = 101;
    //    btnRight.backgroundColor = [UIColor orangeColor];
    [_toolView addSubview:btnRight];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    if (_choiceShopLocationBlock)
    {
        _choiceShopLocationBlock(nil);
    }
    
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *str = nil;
    if (btn.tag == 100)
    {// 取消
        str = nil;
    }
    else
    {// 确定
//        str = _location;
    }
//    debugLog(@"str=%@", str);
    if (_choiceShopLocationBlock)
    {
        _choiceShopLocationBlock(_location);
    }
}

- (void)updateWithLocation:(ShopSeatInfoEntity *)location
{
    if ([_locationLists count] == 0)
    {
        return;
    }
    if (!location)
    {
        [_locationPicker selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        NSInteger row = 0;
        for (NSInteger i=0; i<_locationLists.count; i++)
        {
            ShopSeatInfoEntity *ent = _locationLists[i];
            if ([ent.name isEqualToString:location.name])
            {
                row = i;
                break;
            }
        }
        [_locationPicker selectRow:row inComponent:0 animated:YES];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_locationLists count];
}

/*
 // 每列的宽度
 - (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
 {
 
 }*/

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.location = _locationLists[row];
}

// 返回当前行的内容，此处是将数据中数值添加到滚动的那个现实栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ShopSeatInfoEntity *ent = _locationLists[row];
    return ent.name;
}



@end
