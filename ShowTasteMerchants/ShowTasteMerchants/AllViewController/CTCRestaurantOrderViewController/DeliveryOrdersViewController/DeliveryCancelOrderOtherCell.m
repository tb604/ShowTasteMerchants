//
//  DeliveryCancelOrderOtherCell.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryCancelOrderOtherCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"


@interface DeliveryCancelOrderOtherCell ()
{
//    UIImageView *_checkImgView;
    UIButton *_btnThan;
    
    UILabel *_titleLabel;
    
    
}
//@property (nonatomic, strong) CALayer *bottomLine;

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

//- (void)initWithCheckImgView;
- (void)initWithBtnThan;

- (void)initwithTitleLabel;

@end

@implementation DeliveryCancelOrderOtherCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kDeliveryCancelOrderOtherCellHeight - 0.5, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
//    self.bottomLine = line;
}

- (void)initWithBtnThan
{
    if (!_btnThan)
    {
        UIImage *image = [UIImage imageNamed:@"order_btn_shouqi_sel"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - image.size.width - 10, (kDeliveryCancelOrderOtherCellHeight-image.size.height)/2, image.size.width, image.size.height);
        _btnThan = [TYZCreateCommonObject createWithButton:self imgNameNor:@"order_btn_shouqi_nor" imgNameSel:@"order_btn_shouqi_sel" targetSel:nil];
        _btnThan.frame = frame;
        _btnThan.userInteractionEnabled = NO;
        [self.contentView addSubview:_btnThan];
    }
//    _btnThan.hidden = YES;
    _btnThan.selected = _cellEntity.isCheck;
}

- (void)initwithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, (kDeliveryCancelOrderOtherCellHeight-20)/2., _btnThan.left - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _cellEntity.title;
}

- (void)updateCellData:(id)cellEntity
{
    self.cellEntity = cellEntity;
    
    [self initWithBtnThan];
    
    [self initwithTitleLabel];
}

@end
