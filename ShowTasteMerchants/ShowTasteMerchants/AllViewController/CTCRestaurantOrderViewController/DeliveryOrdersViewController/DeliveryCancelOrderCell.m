//
//  DeliveryCancelOrderCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryCancelOrderCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DeliveryCancelOrderCell ()
{
    UIImageView *_checkImgView;
    
    UILabel *_titleLabel;
    
}
@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

- (void)initWithCheckImgView;

- (void)initwithTitleLabel;

@end

@implementation DeliveryCancelOrderCell

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
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(10, kDeliveryCancelOrderCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 10, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.bottomLine = line;
}

- (void)initWithCheckImgView
{
    if (!_checkImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"order_icon_yishang.png"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - 10, (kDeliveryCancelOrderCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _checkImgView = [[UIImageView alloc] initWithFrame:frame];
        _checkImgView.image = image;
        [self.contentView addSubview:_checkImgView];
    }
    _checkImgView.hidden = YES;
    if (_cellEntity.isCheck)
    {
        _checkImgView.hidden = NO;
    }
}

- (void)initwithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, (kDeliveryCancelOrderCellHeight-20)/2., _checkImgView.left - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _cellEntity.title;
}

- (void)updateCellData:(id)cellEntity
{
    self.cellEntity = cellEntity;
    
    [self initWithCheckImgView];
    
    [self initwithTitleLabel];
}

@end
