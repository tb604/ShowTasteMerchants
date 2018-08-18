//
//  MyRestaurantMouthEditTopCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthEditTopCell.h"
#import "LocalCommon.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantMouthEditTopCell ()
{
    UIImageView *_thanImgView;
    
    UILabel *_titleLabel;
}

@property (nonatomic, strong) ShopMouthDataEntity *mouthEntity;

- (void)initWithThanImgView;

- (void)initWithTitleLabel;

@end

@implementation MyRestaurantMouthEditTopCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
//    [CALayer drawLine:self.contentView frame:CGRectMake(0, kMyRestaurantMouthCellHeigh, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#cccccc"]];
    
    [self initWithThanImgView];
    
    [self initWithTitleLabel];
}

- (void)initWithThanImgView
{// budan_icon_nor/budan_icon_sel
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"budan_icon_sel"];
        CGRect frame = CGRectMake(15, (kMyRestaurantMouthEditTopCellHeight - image.size.height)/2, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_thanImgView];
        _thanImgView.image = image;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kMyRestaurantMouthEditTopCellHeight - 20)/2, _thanImgView.left - 10 - 15, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame  textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _titleLabel.text = _mouthEntity.printer_name;
}


- (void)updateCellData:(id)cellEntity
{
    self.mouthEntity = cellEntity;
    
    [self initWithTitleLabel];
}

@end

























