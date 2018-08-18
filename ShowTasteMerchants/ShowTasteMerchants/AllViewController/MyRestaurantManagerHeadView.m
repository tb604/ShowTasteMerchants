//
//  MyRestaurantManagerHeadView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerHeadView.h"
#import "LocalCommon.h"

@interface MyRestaurantManagerHeadView ()
{
    /**
     *  姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  工位
     */
    UILabel *_stationLabel;
    
    /**
     *  手机号
     */
    UILabel *_mobileLabel;
    
    /**
     *  权限
     */
    UILabel *_permissionLabel;
    
    CGFloat _fourWidth;
    
    CGFloat _mobileWidth;
    
    CGFloat _space;
    
}

- (void)initWithNameLabel;

- (void)initWithStationLabel;

- (void)initWithMobileLabel;

- (void)initWithPermissionLabel;

@end

@implementation MyRestaurantManagerHeadView

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
    
    NSString *str = @"大堂经理";
    _fourWidth = [str widthForFont:FONTSIZE_15];
    
    str = @"13580833706";
    _mobileWidth = [str widthForFont:FONTSIZE_15];
    
    _space = ([[UIScreen mainScreen] screenWidth] - _fourWidth*3 - _mobileWidth - 30) / 3.0;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#989898"];
    
    [self initWithNameLabel];
    
    [self initWithStationLabel];
    
    [self initWithMobileLabel];
    
    [self initWithPermissionLabel];
    
}

- (void)initWithNameLabel
{
    NSString *str = @"姓名";
//    CGFloat width = [str widthForFont:FONTSIZE_15];
    CGRect frame = CGRectMake(15, 5, _fourWidth, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _nameLabel.text = str;
//    _nameLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithStationLabel
{
    CGRect frame = _nameLabel.frame;
    frame.origin.x = _nameLabel.right + _space;
    _stationLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _stationLabel.text = @"工位";
//    _stationLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithMobileLabel
{
    CGRect frame = _nameLabel.frame;
    frame.size.width = _mobileWidth;
    frame.origin.x = _stationLabel.right + _space;
    _mobileLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    _mobileLabel.text = @"手机号";
//    _mobileLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithPermissionLabel
{
    NSString *str = @"权限";
    CGRect frame = _nameLabel.frame;
    _permissionLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    _permissionLabel.text = str;
    _permissionLabel.right = self.width - 15;
//    _permissionLabel.backgroundColor = [UIColor lightGrayColor];
}

@end


























