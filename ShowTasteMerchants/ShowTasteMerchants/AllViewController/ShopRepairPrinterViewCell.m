//
//  ShopRepairPrinterViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopRepairPrinterViewCell.h"
#import "LocalCommon.h"
//#import "ShopPrinterDataEntity.h"
#import "ShopBatchDataEntity.h"

@interface ShopRepairPrinterViewCell ()
{
    /**
     *  budan_icon_nor/budan_icon_sel
     */
    UIImageView *_thanImgView;
    
    UILabel *_printerNameLabel;
    
    /**
     *  补打
     */
    UIButton *_btnRepair;
}
@property (nonatomic, strong) ShopBatchDataEntity *printerEntity;


- (void)initWithThanImgView;

- (void)initWithPrinterNameLabel;

- (void)initWithBtnRepair;

@end

@implementation ShopRepairPrinterViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
    [self initWithBtnRepair];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kShopRepairPrinterViewCellHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
    
}

- (void)initWithThanImgView
{// budan_icon_nor/budan_icon_sel
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"budan_icon_sel"];
        CGRect frame = CGRectMake(15, (kShopRepairPrinterViewCellHeight - image.size.height)/2, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thanImgView];
        _thanImgView.image = image;
    }
    
    if (_printerEntity.isCheck)
    {
//        _thanImgView.image = [UIImage imageNamed:@"budan_icon_nor"];
        [UIView animateWithDuration:0.3 animations:^{
            _thanImgView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }];

        
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            _thanImgView.transform = CGAffineTransformMakeRotation(0);
        }];
//        _thanImgView.image = [UIImage imageNamed:@"budan_icon_sel"];
    }
}

- (void)initWithPrinterNameLabel
{
    if (!_printerNameLabel)
    {
        CGRect frame = CGRectMake(_thanImgView.right + 10, (kShopRepairPrinterViewCellHeight - 20)/2, [[UIScreen mainScreen] screenWidth] / 2, 20);
        _printerNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _printerNameLabel.text = _printerEntity.batch_no;
}

- (void)initWithBtnRepair
{
    if (!_btnRepair)
    {
        NSString *str = @"补打";
        CGFloat width = [str widthForFont:FONTSIZE_12] + 30;
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kShopRepairPrinterViewCellHeight - 26) / 2, width, 26);
        _btnRepair = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_14 targetSel:@selector(clickedWithRepair:)];
        _btnRepair.frame = frame;
        _btnRepair.layer.borderColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        _btnRepair.layer.borderWidth = 1;
        _btnRepair.layer.cornerRadius = 4;
        _btnRepair.layer.masksToBounds = YES;
        [self.contentView addSubview:_btnRepair];
    }
}

- (void)clickedWithRepair:(id)sender
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(_printerEntity);
    }
}

- (void)updateCellData:(id)cellEntity
{
    
    self.printerEntity = cellEntity;
//    debugLog(@"ent=%@", [_printerEntity modelToJSONString]);
    [self initWithThanImgView];
    
    [self initWithPrinterNameLabel];
}

@end


















