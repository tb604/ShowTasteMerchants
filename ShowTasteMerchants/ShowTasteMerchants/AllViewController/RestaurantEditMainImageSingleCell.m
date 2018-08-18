//
//  RestaurantEditMainImageSingleCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantEditMainImageSingleCell.h"
#import "LocalCommon.h"
#import "RestaurantEditImageView.h"
#import "RestaurantImageEntity.h"
#import "UIImageView+WebCache.h"

@interface RestaurantEditMainImageSingleCell ()
{
    
}

@property (nonatomic, strong) RestaurantEditImageView *shopImageView;

@property (nonatomic, strong) RestaurantImageEntity *imageEntity;

- (void)initWithImageView;


@end

@implementation RestaurantEditMainImageSingleCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    [self initWithImageView];
    
}

- (void)initWithImageView
{
    CGRect frame = CGRectMake(10, 10, [[UIScreen mainScreen] screenWidth] - 20, [[self class] getWithCellHeight] - 20);
    _shopImageView = [[RestaurantEditImageView alloc] initWithFrame:frame];
    _shopImageView.backgroundColor = [UIColor whiteColor];
    _shopImageView.tag = 100;
    [self.contentView addSubview:_shopImageView];
    __weak typeof(self)weakSelf = self;
    _shopImageView.touchwithImgViewBlock = ^(RestaurantEditImageView *imgView)
    {
        RestaurantImageEntity *ent = imgView.imageEntity;
        ent.tag = weakSelf.shopImageView.tag;
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(ent);
        }
    };
}

- (void)updateCellData:(id)cellEntity title:(NSString *)title
{
    self.imageEntity = cellEntity;
    _shopImageView.imageEntity = cellEntity;
    [_shopImageView sd_setImageWithURL:[NSURL URLWithString:_imageEntity.name] placeholderImage:nil];
    if (![objectNull(_imageEntity.name) isEqualToString:@""])
    {
        [_shopImageView updateWithTitle:nil];
    }
    else
    {
        [_shopImageView updateWithTitle:title];
    }
}

+ (NSInteger)getWithCellHeight
{
    return ceilf([[UIScreen mainScreen] screenWidth] / 1.5);
}

@end























