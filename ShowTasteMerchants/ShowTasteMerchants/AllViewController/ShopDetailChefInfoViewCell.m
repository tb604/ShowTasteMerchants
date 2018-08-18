//
//  ShopDetailChefInfoView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopDetailChefInfoViewCell.h"
#import "LocalCommon.h"
#import "ShopChefDataEntity.h"
#import "RestaurantChefDataEntity.h"
#import "UIImageView+WebCache.h"

@interface ShopDetailChefInfoViewCell ()
{
    /**
     *  头像
     */
    UIImageView *_headImgView;
    
    /**
     *  姓名
     */
    UILabel *_nameLabel;
    
    /**
     *  等级
     */
    UILabel *_rankLabel;
    
    /**
     *  厨师的简介
     */
    UILabel *_descLabel;
}

@property (nonatomic, strong) CALayer *line;

- (void)initWithHeadImgView;

- (void)initWithNameLabel;

- (void)initWithRankLabel;

- (void)initWithDescLabel;

@end

@implementation ShopDetailChefInfoViewCell

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
    
    [self initWithLine];
    
    [self initWithHeadImgView];
    
    [self initWithNameLabel];
    
    [self initWithRankLabel];
    
    [self initWithDescLabel];
}


- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.6);
    line.left = 0;
    line.bottom = kShopDetailChefInfoViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
    [self.contentView.layer addSublayer:line];
    self.line = line;
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        CGRect frame = CGRectMake(15, 20, 100, 100);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
        _headImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_headImgView];
    }
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_headImgView.right + 15, 0, [[UIScreen mainScreen] screenWidth] - _headImgView.right - 15 * 2, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _nameLabel.centerY = _headImgView.centerY - 15;
    }
}

- (void)initWithRankLabel
{
    if (!_rankLabel)
    {
        CGRect frame = _nameLabel.frame;
        _rankLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff9f83"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _rankLabel.centerY = _headImgView.centerY + 15;
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(15, _headImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.numberOfLines = 0;
    }
}

- (void)hiddenWithLine:(BOOL)hidden
{
    _line.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity
{
    ShopChefDataEntity *chefEntity = nil;
    
    RestaurantChefDataEntity *chefEnt = nil;
//    RestaurantChefDataEntity
    // shop/54/3000/f2945428-a206-492c-5fb0-18735639fb4f.png
    if ([cellEntity isKindOfClass:[RestaurantChefDataEntity class]])
    {
        chefEnt = cellEntity;
    }
    else if ([cellEntity isKindOfClass:[ShopChefDataEntity class]])
    {
        chefEntity = cellEntity;
    }
    
    // 头像
    if (chefEntity)
    {
        NSArray *headImages = chefEntity.chef_image;
        ShopChefImageDataEntity *imageEntity = nil;
        if ([headImages count] > 0)
        {
            imageEntity = headImages[0];
        }
        if (imageEntity)
        {
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:imageEntity.name] placeholderImage:[UIImage imageNamed:@"chef_default_head"]];
        }
        
        // 姓名
        _nameLabel.text = chefEntity.chef_name;
        
        // 级别
        _rankLabel.text = chefEntity.chef_title;
        
        // 简介
        CGRect frame = _descLabel.frame;
        frame.size.height = chefEntity.chef_introHeight;
        _descLabel.frame = frame;
        _descLabel.text = chefEntity.chef_intro;
        
        _line.bottom = kShopDetailChefInfoViewCellHeight - 20 + chefEntity.chef_introHeight;
    }
    else if (chefEnt)
    {
        debugLog(@"image=%@", chefEnt.image);
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:chefEnt.image] placeholderImage:[UIImage imageNamed:@"chef_default_head"]];
        
        // 姓名
        _nameLabel.text = chefEnt.name;
        
        // 级别
        _rankLabel.text = chefEnt.title;
        
        // 简介
        CGRect frame = _descLabel.frame;
        frame.size.height = chefEnt.introHeight;
        _descLabel.frame = frame;
        _descLabel.text = chefEnt.intro;
        
        _line.bottom = kShopDetailChefInfoViewCellHeight - 20 + chefEnt.introHeight;
    }
    
    
    
}

@end



















