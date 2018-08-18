//
//  ShopOrderDetailDinersInfoCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderDetailDinersInfoCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "OrderDataEntity.h"
#import "CTCOrderDetailEntity.h"

@interface ShopOrderDetailDinersInfoCell ()
{
    /**
     *  头像
     */
    UIImageView *_headImgView;
    
    /**
     *  点击显示订单信息
     */
    UIButton *_btnOrder;
    
    /**
     *  食客姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  订单类型
     */
    UIImageView *_orderTypeImgView;
    
    /**
     *  电话
     */
    UILabel *_phoneLabel;
    
}
@property (nonatomic, strong) CALayer *line;

/**
 *  头像
 */
- (void)initWithHeadImgView;

/**
 *  点击显示订单信息
 */
- (void)initWithBtnOrder;

/**
 *  食客姓名
 */
- (void)initWithNameLabel;

- (void)initWithOrderTypeImgView;

/**
 *  电话
 */
- (void)initWithPhoneLabel;


@end


@implementation ShopOrderDetailDinersInfoCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    // 头像
    [self initWithHeadImgView];
    
    // 点击显示订单信息
    [self initWithBtnOrder];
    
    // 食客姓名
    [self initWithNameLabel];
    
    [self initWithOrderTypeImgView];
    
    // 电话
    [self initWithPhoneLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.6);
    line.left = 15;
    line.bottom = kShopOrderDetailDinersInfoCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#c0c0c0"].CGColor;
    [self.contentView.layer addSublayer:line];
    self.line = line;
}

/**
 *  头像
 */
- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        CGRect frame = CGRectMake(15, (kShopOrderDetailDinersInfoCellHeight - 40)/2, 40, 40);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_headImgView];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 40.0 / 2;
        _headImgView.image = [UIImage imageNamed:@"head_default"];
        _headImgView.layer.borderColor = [UIColor colorWithHexString:@"#c0c0c0"].CGColor;
        _headImgView.layer.borderWidth = 1;
    }
}

/**
 *  点击显示订单信息
 */
- (void)initWithBtnOrder
{
    if (!_btnOrder)
    {
        UIImage *image = [UIImage imageNamed:@"order_btn_shouqi_sel"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width*3, (kShopOrderDetailDinersInfoCellHeight-image.size.height*3)/2, image.size.width*3, image.size.height*3);
        _btnOrder = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_shouqi_nor" imgNameSel:@"order_btn_shouqi_sel" targetSel:@selector(clickedWithButton:)];
        _btnOrder.frame = frame;
//        _btnOrder.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_btnOrder];
    }
}

/**
 *  食客姓名
 */
- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_headImgView.right + 15, 10, 40, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithOrderTypeImgView
{
    if (!_orderTypeImgView)
    {
        // order_icon_shi
//        UIImage *image = [UIImage imageNamed:@"order_icon_ding"];
        CGRect frame = CGRectMake(_nameLabel.right + 10, 10, 18, 18);
        _orderTypeImgView = [[UIImageView alloc] initWithFrame:frame];
        _orderTypeImgView.centerY = _nameLabel.centerY;
        [self.contentView addSubview:_orderTypeImgView];
    }
}

/**
 *  电话
 */
- (void)initWithPhoneLabel
{
    if (!_phoneLabel)
    {
        CGRect frame = CGRectMake(_headImgView.right + 15, _nameLabel.bottom, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _phoneLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"323232"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(@(btn.selected));
    }
}

- (void)hiddenWithLine:(BOOL)hidden
{
    _line.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity isSelected:(BOOL)isSelected
{
    _btnOrder.selected = isSelected;
    [self updateCellData:cellEntity];
}

- (void)updateCellData:(id)cellEntity
{
    CTCOrderDetailEntity *orderEnt = cellEntity;
    NSString *headerUrl = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", orderEnt.avatar, [NSDate stringWithCurrentTimeStamp]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    // 食客姓名
    NSString *name = objectNull(orderEnt.name);
    if ([name isEqualToString:@""])
    {
        name = @"游客";
    }
    CGFloat width = [name widthForFont:_nameLabel.font];
    _nameLabel.width = width;
    _nameLabel.text = name;
    
    _orderTypeImgView.left = _nameLabel.right + 10;
    if (orderEnt.type == 1)
    {//预订
        _orderTypeImgView.image = [UIImage imageNamed:@"order_icon_ding"];
    }
    else if (orderEnt.type == 2)
    {// 即时
        _orderTypeImgView.image = [UIImage imageNamed:@"order_icon_shi"];
    }
    
    // 电话
    _phoneLabel.text = orderEnt.mobile;
}


@end









