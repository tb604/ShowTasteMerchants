//
//  MyRestaurantChoiceMouthCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantChoiceMouthCell.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantChoiceMouthCell ()
{
    UIImageView *_checkImgView;
    
    UILabel *_mouthLabel;
}

@property (nonatomic, strong) ShopMouthDataEntity *mouthEntity;

// cuisine_btn_sel
- (void)initWithCheckImgView;

- (void)initWithMouthLabel;

@end

@implementation MyRestaurantChoiceMouthCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(15, 40, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    // cuisine_btn_sel
    [self initWithCheckImgView];
    
    [self initWithMouthLabel];
    
}

// cuisine_btn_sel
- (void)initWithCheckImgView
{
    if (!_checkImgView)
    {
        UIImage *image = [UIImage imageNamed:@"cuisine_btn_sel"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, (40 - image.size.height) / 2, image.size.width, image.size.height);
        _checkImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_checkImgView];
    }
    UIImage *image = nil;
    if (_mouthEntity.isSelected)
    {
        image = [UIImage imageNamed:@"cuisine_btn_sel"];
    }
    else
    {
        image = [UIImage imageNamed:@"cuisine_btn_nor"];
    }
    _checkImgView.image = image;
}

- (void)initWithMouthLabel
{
    if (!_mouthLabel)
    {
        CGRect frame = CGRectMake(15, (40-20)/2, _checkImgView.left - 15 - 10 , 20);
        _mouthLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _mouthLabel.text = _mouthEntity.printer_name;
}

- (void)updateCellData:(id)cellEntity
{
    self.mouthEntity = cellEntity;
    
    [self initWithCheckImgView];
    
    [self initWithMouthLabel];
    
}

@end










