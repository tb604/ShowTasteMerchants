//
//  DinersRecipeFoodDetailHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeFoodDetailHeaderView.h"
#import "LocalCommon.h"
#import "ShopFoodDataEntity.h" // 菜品数据
#import "UIImageView+WebCache.h"

@interface DinersRecipeFoodDetailHeaderView ()
{
    /**
     *  菜品图片
     */
//    UIImageView *_foodImgView;
}

@property (nonatomic, strong, readwrite) UIImageView *foodImgView;

- (void)initWithFoodImgView;

@end

@implementation DinersRecipeFoodDetailHeaderView


- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self initWithFoodImgView];
    
}

- (void)initWithFoodImgView
{
    if (!_foodImgView)
    {
        CGRect frame = self.bounds;
        _foodImgView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_foodImgView];
    }
}

- (void)updateViewData:(id)entity
{
    ShopFoodDataEntity *foodEntity = entity;
    [_foodImgView sd_setImageWithURL:[NSURL URLWithString:foodEntity.image] placeholderImage:nil];
}

+ (NSInteger)getHeadViewHeight
{
    return ([[UIScreen mainScreen] screenWidth] / 1.45);
}


@end
