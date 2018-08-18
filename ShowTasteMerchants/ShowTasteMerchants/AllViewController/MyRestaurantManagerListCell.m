//
//  MyRestaurantManagerListCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantManagerListCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "ShopManageNewDataEntity.h"


@interface MyRestaurantManagerListCell ()
{
    /// 头像
    UIImageView *_headerImgView;
    
    /// 姓名
    UILabel *_nameLabel;
    
    /// 电话号码
    UILabel *_phoneLabel;
    
    /// 角色
    UILabel *_roleNamelabel;
    
    UIImageView *_thanImgView;
}

@property (nonatomic, strong) ShopManageNewDataEntity *manageEntity;

/**
 *  头像
 */
- (void)initWithHeaderImgView;

/**
 * 姓名
 */
- (void)initWithNameLabel;

/**
 * 手机号码
 */
- (void)initWithPhoneLabel;

/**
 * 角色
 */
- (void)initWithRoleNamelabel;

/**
 * 更多
 */
- (void)initWithThanImgView;

@end

@implementation MyRestaurantManagerListCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kMyRestaurantManagerListCellHeight - 0.5, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
}

/**
 *  头像
 */
- (void)initWithHeaderImgView
{
    UIImage *image = [UIImage imageWithContentsOfFileName:@"home_top_head_yg.png"];
    [self.contentView addSubview:_headerImgView];
    if (!_headerImgView)
    {
        CGRect frame = CGRectMake(10, (kMyRestaurantManagerListCellHeight-30.)/2., 30, 30);
        _headerImgView = [[UIImageView alloc] initWithFrame:frame];
        _headerImgView.image = image;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = CGRectGetWidth(frame)/2.;
        [self.contentView addSubview:_headerImgView];
    }
//    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:_manageEntity.role_name] placeholderImage:image];
}

/**
 * 姓名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        float space = 10;
        NSString *str = @"唐斌你号呀我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"唐斌你号呀";
            space = 5;
        }
        else if (kiPhone6)
        {
            str = @"唐斌你号呀";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_headerImgView.right + space, 0, width, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _nameLabel.centerY = _headerImgView.centerY;
//        _nameLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _nameLabel.text = objectNull(_manageEntity.username);
}

/**
 * 手机号码
 */
- (void)initWithPhoneLabel
{
    if (!_phoneLabel)
    {
        NSString *str = @"1826192960412312";
        if (kiPhone4 || kiPhone5)
        {
            str = @"1826192960413";
        }
        else if (kiPhone6)
        {
            str = @"1826192960412";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_nameLabel.right + 5, 0, width, 20);
        _phoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//        _phoneLabel.backgroundColor = [UIColor lightGrayColor];
        _phoneLabel.centerY = _headerImgView.centerY;
    }
    _phoneLabel.text = _manageEntity.mobile;
}

/**
 * 角色
 */
- (void)initWithRoleNamelabel
{
    if (!_roleNamelabel)
    {
        NSString *str = @"管理员我的我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"管理员我";
        }
        else if (kiPhone6)
        {
            str = @"管理员我的";
        }
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_phoneLabel.right + 5, 0, width, 20);
        _roleNamelabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//        _roleNamelabel.backgroundColor = [UIColor lightGrayColor];
        _roleNamelabel.centerY = _headerImgView.centerY;
    }
    _roleNamelabel.text = _manageEntity.role_name;
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"home_inform_btn_more.png"];
        CGRect frame = CGRectMake(0, (kMyRestaurantManagerListCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 10;
        [self.contentView addSubview:_thanImgView];
    }
    _thanImgView.hidden = NO;
    if ([_manageEntity.role_name isEqualToString:@"创建者"])
    {
        _thanImgView.hidden = YES;
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.manageEntity = cellEntity;
    // 头像
    [self initWithHeaderImgView];
    
    // 姓名
    [self initWithNameLabel];
    
    // 手机号码
    [self initWithPhoneLabel];
    
    // 角色
    [self initWithRoleNamelabel];
    
    // 更多
    [self initWithThanImgView];
}

@end












