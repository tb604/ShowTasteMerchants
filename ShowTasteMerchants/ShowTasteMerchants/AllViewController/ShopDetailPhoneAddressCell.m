//
//  ShopDetailPhoneAddressCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailPhoneAddressCell.h"
#import "LocalCommon.h"
#import "ShopDetailPAView.h"
#import "ShopBaseInfoDataEntity.h"
#import "RestaurantBaseDataEntity.h"

@interface ShopDetailPhoneAddressCell ()

@property (nonatomic, strong) ShopDetailPAView *phoneView;

@property (nonatomic, strong) ShopDetailPAView *addressView;

- (void)initWithPhoneView;

- (void)initWithAddressView;

@end

@implementation ShopDetailPhoneAddressCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLineTwo];
    
    [self initWithLine];
    
    [self initWithPhoneView];
    
    [self initWithAddressView];
}

- (void)initWithLineTwo
{
    [CALayer drawLine:self.contentView frame:CGRectMake(15, kShopDetailPhoneAddressCellHeight/2, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
}


- (void)initWithLine
{
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kShopDetailPhoneAddressCellHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
}

- (void)initWithPhoneView
{
    if (!_phoneView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kShopDetailPAViewHeight);
        _phoneView = [[ShopDetailPAView alloc] initWithFrame:frame];
        _phoneView.tag = 100;
        [self.contentView addSubview:_phoneView];
    }
    __weak typeof(self)weakSelf = self;
    _phoneView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}

- (void)initWithAddressView
{
    if (!_addressView)
    {
        CGRect frame = CGRectMake(0, _phoneView.bottom, [[UIScreen mainScreen] screenWidth], kShopDetailPAViewHeight-0.6);
        _addressView = [[ShopDetailPAView alloc] initWithFrame:frame];
//        _addressView.backgroundColor = [UIColor purpleColor];
        _addressView.tag = 101;
        [self.contentView addSubview:_addressView];
    }
    __weak typeof(self)weakSelf = self;
    _addressView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}

- (void)updateCellData:(id)cellEntity
{
    NSString *mobile = @"";
    NSString *address = @"";
    if ([cellEntity isKindOfClass:[RestaurantBaseDataEntity class]])
    {
        RestaurantBaseDataEntity *shopEnt = cellEntity;
        mobile = shopEnt.mobile;
        address = shopEnt.address;
    }
    else if ([cellEntity isKindOfClass:[ShopBaseInfoDataEntity class]])
    {
        ShopBaseInfoDataEntity *shopEnt = cellEntity;
        mobile = shopEnt.mobile;
        address = shopEnt.address;
    }
    [_phoneView updateViewData:mobile imageIcon:[UIImage imageNamed:@"hall_icon_phone"]];
    
    [_addressView updateViewData:address imageIcon:[UIImage imageNamed:@"hall_icon_addr"]];
}

@end























