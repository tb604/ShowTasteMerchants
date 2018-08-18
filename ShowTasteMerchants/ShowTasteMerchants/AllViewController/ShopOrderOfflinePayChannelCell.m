//
//  ShopOrderOfflinePayChannelCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderOfflinePayChannelCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"

@interface ShopOrderOfflinePayChannelCell ()
{
    UIImageView *_thumalImgView;
    
    UIImageView *_checkImgView;
    
    UILabel *_titleLabel;
}
@property (nonatomic, strong) PayChannelDataEntity *payChannelEnt;


- (void)initWithThumalImgView;

- (void)initWithCheckImgView;

- (void)initWithTitleLabel;

@end

@implementation ShopOrderOfflinePayChannelCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(20, 40-0.6, 300 - 40, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithThumalImgView];
    
    [self initWithCheckImgView];
    
    [self initWithTitleLabel];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(20, (kShopOrderOfflinePayChannelCellHeight-20)/2, 20, 20);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithCheckImgView
{
    if (!_checkImgView)
    {
        UIImage *image = [UIImage imageNamed:@"pay_icon_xuanzhong"];
        CGRect frame = CGRectMake(300 - 20 - image.size.width, 0, image.size.width, image.size.height);
        _checkImgView = [[UIImageView alloc] initWithFrame:frame];
        _checkImgView.image = image;
        _checkImgView.centerY = _thumalImgView.centerY;
        [self.contentView addSubview:_checkImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, (kShopOrderOfflinePayChannelCellHeight-20)/2, _checkImgView.left - _thumalImgView.right - 10, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.payChannelEnt = cellEntity;
    
    // 图标
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_payChannelEnt.image] placeholderImage:nil];
    
    // 名称
    _titleLabel.text = _payChannelEnt.desc;
    
    // 选中
    _checkImgView.hidden = YES;
    if (_payChannelEnt.isCheck)
    {
        _checkImgView.hidden = NO;
    }
}

@end













