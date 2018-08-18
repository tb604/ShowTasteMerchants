//
//  RestaurantClassifiySmallSingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassifiySmallSingleView.h"
#import "LocalCommon.h"
//#import "CuisineContentDataEntity.h"

@interface RestaurantClassifiySmallSingleView ()
{
//    UILabel *_titleLabel;
    UIButton *_btnClassifiy;
}

@property (nonatomic, strong, readwrite) CuisineContentDataEntity *contentEntity;


- (void)initWithTitleLabel;

- (void)initWithBtnClassifiy;


@end

@implementation RestaurantClassifiySmallSingleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    
//    [self initWithTitleLabel];
    
    [self initWithBtnClassifiy];
    
}

- (void)initWithTitleLabel
{
    /*if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, 5, self.width - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    }*/
}

- (void)initWithBtnClassifiy
{
    if (!_btnClassifiy)
    {
        CGRect frame = CGRectMake(0, 0, self.width, 30);
        _btnClassifiy = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnClassifiy.frame = frame;
        _btnClassifiy.titleLabel.font = FONTSIZE_13;
        _btnClassifiy.layer.borderColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
        _btnClassifiy.layer.borderWidth = 1;
//        [_btnClassifiy setTitle:nil forState:UIControlStateNormal];
        [_btnClassifiy setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_btnClassifiy setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff5500"]] forState:UIControlStateSelected];
        [_btnClassifiy setTitleColor:[UIColor colorWithHexString:@"#323232"] forState:UIControlStateNormal];
        [_btnClassifiy setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnClassifiy addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnClassifiy];
    }
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(self);
    }
    
}

- (BOOL)getButtonSelected
{
    return _btnClassifiy.selected;
}

- (void)updateButtonUnSelected
{
    _btnClassifiy.selected = NO;
}

- (void)updateViewData:(id)entity
{
    self.contentEntity = entity;
    _btnClassifiy.width = self.width;
    [_btnClassifiy setTitle:_contentEntity.name forState:UIControlStateNormal];
//    _titleLabel.width = self.width - 20;
//    _titleLabel.text = _contentEntity.menu_name;
}

@end













