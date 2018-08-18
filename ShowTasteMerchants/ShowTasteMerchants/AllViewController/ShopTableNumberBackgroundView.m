//
//  ShopTableNumberBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopTableNumberBackgroundView.h"
#import "LocalCommon.h"
#import "ShopTableNumberView.h"
#import "TYZComboBox.h"
#import "ShopSeatInfoEntity.h"

@interface ShopTableNumberBackgroundView () <ComboBoxDelegate>
{
    ShopTableNumberView *_tableNumberView;
    
    /**
     *  空间.大厅、包间
     */
    TYZComboBox *_locationComboBox;
}

@property (nonatomic, strong) ShopTableNumberSeatEntity *seatEntity;

@property (nonatomic, strong) NSArray *seatLocList;

- (void)initWithSubView;

- (void)initWithTableNumberView;

- (void)initWithLocationComboBox;

- (void)tagGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopTableNumberBackgroundView


- (id)initWithFrame:(CGRect)frame seatList:(NSArray *)seatList
{
    self.seatLocList = seatList;
    return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    _seatEntity = [ShopTableNumberSeatEntity new];
    
    [self initWithTableNumberView];
    
    [self initWithLocationComboBox];
    
    // top
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _tableNumberView.top);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [self addSubview:view];
    
    // bottom
    frame = CGRectMake(0, _tableNumberView.bottom, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _tableNumberView.bottom);
    UIView *bottom = [[UIView alloc] initWithFrame:frame];
    [self addSubview:bottom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture:)];
    [view addGestureRecognizer:tap];
    [bottom addGestureRecognizer:tap];
    
}

- (void)initWithTableNumberView
{
    if (!_tableNumberView)
    {
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - 300)/2, 0, 300, 206); // 180
        _tableNumberView = [[ShopTableNumberView alloc] initWithFrame:frame];
        [self addSubview:_tableNumberView];
        _tableNumberView.centerY = [[UIScreen mainScreen] screenHeight] / 2 - 50;
        _tableNumberView.layer.cornerRadius = 4;
        _tableNumberView.layer.masksToBounds = YES;
    }
    __weak typeof(self)weakSelf = self;
    _tableNumberView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.seatEntity.seatId == 0 && data)
        {
            [SVProgressHUD showErrorWithStatus:@"请选择空间"];
            return;
        }
        ShopTableNumberSeatEntity *ent = data;
        weakSelf.seatEntity.personNum = ent.personNum;
        weakSelf.seatEntity.tableNo = ent.tableNo;
//        NSString *str = data;
//        debugLog(@"str=%@", str);
        if (weakSelf.touchTableNumberBlock)
        {
            if (data)
            {
                weakSelf.touchTableNumberBlock(weakSelf.seatEntity);
            }
            else
            {
                weakSelf.touchTableNumberBlock(nil);
            }
        }
    };
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
        
        CGFloat y = _tableNumberView.top + 15;
//        NSString *str = @"工位";
//        CGFloat fontWidth = [str widthForFont:FONTSIZE_12];
        CGFloat width = _tableNumberView.width - 60;
        _locationComboBox = [[TYZComboBox alloc] initWithFrame:CGRectMake((self.width - width)/2, y + 10, width, 34)];
        _locationComboBox.listItems = list;
        _locationComboBox.tag = 100;
        _locationComboBox.borderColor = [UIColor colorWithHexString:@"#cdcdcd"];
        _locationComboBox.bgColor = [UIColor colorWithHexString:@"#f5f5f5"];
        _locationComboBox.borderWidth = 1.0f;
        _locationComboBox.cornerRadius = 4.0f;
        _locationComboBox.arrowImage = [UIImage imageNamed:@"btn_xialasanjiao"];
        _locationComboBox.delegate = self;
        _locationComboBox.testString = @"请选择空间";
//        _locationComboBox.centerX = self.width / 2;
//        if (_staffEntity)
//        {
//            _inputEnt.title = _staffEntity.user_title_id;
//            _postNameComboBox.testString = _staffEntity.user_title;
//        }
//        else
//        {
//            _postNameComboBox.testString = @"请选择";
//        }
        [self addSubview:_locationComboBox];
    }
}

- (void)tagGesture:(UITapGestureRecognizer *)tap
{
    if (_touchTableNumberBlock)
    {
        _touchTableNumberBlock(nil);
    }
}

#pragma mark ComboBoxDelegate
- (void)comboBox:(TYZComboBox *)comboBox didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *seat = comboBox.listItems[indexPath.row];
    for (ShopSeatInfoEntity *ent in _seatLocList)
    {
        if ([seat isEqualToString:ent.name])
        {
            _seatEntity.seatId = ent.id;
            _seatEntity.seatName = ent.name;
            break;
        }
    }
    /*if (comboBox.tag == 100)
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
    }*/
    
}


@end











