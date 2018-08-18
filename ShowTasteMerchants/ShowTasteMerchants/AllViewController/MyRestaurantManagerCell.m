//
//  MyRestaurantManagerCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerCell.h"
#import "LocalCommon.h"
//#import "ShopManageDataEntity.h"
#import "ShopManageNewDataEntity.h"

@interface MyRestaurantManagerCell ()
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

@implementation MyRestaurantManagerCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    NSString *str = @"大堂经理";
    _fourWidth = [str widthForFont:FONTSIZE_15];
    
    str = @"13580833706";
    _mobileWidth = [str widthForFont:FONTSIZE_15];
    
    _space = ([[UIScreen mainScreen] screenWidth] - _fourWidth*3 - _mobileWidth - 30) / 3.0;
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithNameLabel];
    
    [self initWithStationLabel];
    
    [self initWithMobileLabel];
    
    [self initWithPermissionLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.bottom = kMyRestaurantManagerCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e1e1e1"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithNameLabel
{
    CGRect frame = CGRectMake(15, 10, _fourWidth, 20);
    _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)initWithStationLabel
{
    CGRect frame = _nameLabel.frame;
    frame.origin.x = _nameLabel.right + _space;
    _stationLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)initWithMobileLabel
{
    CGRect frame = _nameLabel.frame;
    frame.size.width = _mobileWidth;
    frame.origin.x = _stationLabel.right + _space;
    _mobileLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)initWithPermissionLabel
{
    CGRect frame = _nameLabel.frame;
    frame.origin.x = _mobileLabel.right + _space;
    _permissionLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
}


- (void)updateCellData:(id)cellEntity
{
    ShopManageNewDataEntity *dataEnt = cellEntity;
    // 姓名
    _nameLabel.text = dataEnt.username;
    
    // 职位
    _stationLabel.text = dataEnt.title_name;
    
    // 手机号码
    _mobileLabel.text = dataEnt.mobile;
    
    // 权限
    _permissionLabel.text = dataEnt.role_name;
}


@end
