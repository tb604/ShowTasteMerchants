//
//  MyRestaurantMenuTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMenuTopView.h"
#import "LocalCommon.h"
#import "ShopFoodCategoryDataEntity.h"


@interface MyRestaurantMenuTopView ()
{
    UILabel *_categoryLabel;
}

- (void)initWithCategoryLabel;

@end

@implementation MyRestaurantMenuTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffcdb2"];
    
    [self initWithCategoryLabel];
    
}

- (void)initWithCategoryLabel
{
    if (!_categoryLabel)
    {
        CGRect frame = CGRectMake(10, (self.height-20) / 2, self.width - 20, 20);
        _categoryLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateViewData:(id)entity
{
    ShopFoodCategoryDataEntity *categoryEnt = entity;
    if (entity)
    {
        _categoryLabel.text = [NSString stringWithFormat:@"%@（%d）", objectNull(categoryEnt.name), (int)[categoryEnt.foods count]];
    }
}


@end


















