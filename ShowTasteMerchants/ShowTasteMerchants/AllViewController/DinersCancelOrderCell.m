//
//  DinersCancelOrderCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCancelOrderCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface DinersCancelOrderCell ()
{
    UIImageView *_checkImgView;
    
    UILabel *_descLabel;
}

- (void)initWithCheckImgView;

- (void)initWithDescLabel;

@end

@implementation DinersCancelOrderCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithCheckImgView];
    
    [self initWithDescLabel];
}


- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = kDinersCancelOrderCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.contentView.layer addSublayer:line];
}

- (void)initWithCheckImgView
{
    UIImage *image = [UIImage imageNamed:@"btn_diners_check_nor"];
    CGRect frame = CGRectMake(15, (kDinersCancelOrderCellHeight-image.size.height)/2, image.size.width, image.size.height);
    _checkImgView = [[UIImageView alloc] initWithFrame:frame];
    _checkImgView.image = image;
    [self.contentView addSubview:_checkImgView];
}

- (void)initWithDescLabel
{
    CGRect frame = CGRectMake(_checkImgView.right + 10, (kDinersCancelOrderCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] - _checkImgView.right - 10 - 15, 20);
    _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//    _descLabel.backgroundColor = [UIColor lightGrayColor];
}


- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *entity = cellEntity;
    if (entity.isCheck)
    {
        
        _checkImgView.image = [UIImage imageNamed:entity.checkImgName];
    }
    else
    {
        _checkImgView.image = [UIImage imageNamed:entity.uncheckImgName];
    }
    _descLabel.text = entity.title;
}

@end























