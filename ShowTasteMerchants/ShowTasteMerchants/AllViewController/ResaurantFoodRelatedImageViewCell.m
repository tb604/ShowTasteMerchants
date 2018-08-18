//
//  ResaurantFoodRelatedImageViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ResaurantFoodRelatedImageViewCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "ShopFoodImageEntity.h"

@interface ResaurantFoodRelatedImageViewCell ()
{
    ResaurantAddFoodImageView *_thumalImgView;
    
    UILabel *_descLabel;
}

- (void)initWithThumalImgView;

- (void)initWithDescLabel;

@end

@implementation ResaurantFoodRelatedImageViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithDescLabel];
    
}

- (void)initWithThumalImgView
{
    CGRect frame = CGRectMake(15, 15, [[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
    _thumalImgView = [[ResaurantAddFoodImageView alloc] initWithFrame:frame];
    _thumalImgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    _thumalImgView.layer.borderWidth = 1;
    _thumalImgView.userInteractionEnabled = NO;
    [self.contentView addSubview:_thumalImgView];
    [_thumalImgView updateWithTitle:@"请上传相关菜品图片"];
}

- (void)initWithDescLabel
{
    CGRect frame = CGRectMake(15, _thumalImgView.bottom+10, [[UIScreen mainScreen] screenWidth] - 30, 0);
    _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#a3a3a3"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _descLabel.numberOfLines = 0;
}

- (void)updateCellData:(id)cellEntity
{
    ShopFoodImageEntity *imageEntity = cellEntity;
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imageEntity.image] placeholderImage:nil];
    [_thumalImgView hiddenWithThumalImage:YES];
    if ([objectNull(imageEntity.desc) isEqualToString:@""])
    {
        _descLabel.hidden = YES;
    }
    else
    {
        
        _descLabel.hidden = NO;
        _descLabel.height = imageEntity.descHeight;
        _descLabel.text = imageEntity.desc;
    }
}


@end
