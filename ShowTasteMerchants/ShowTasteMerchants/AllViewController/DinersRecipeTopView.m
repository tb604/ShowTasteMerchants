//
//  DinersRecipeTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeTopView.h"
#import "LocalCommon.h"
#import "ShopFoodCategoryDataEntity.h"

@interface DinersRecipeTopView ()
{
    UILabel *_categoryLabel;
}

- (void)initWithCategoryLabel;

@end

@implementation DinersRecipeTopView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ffcdb2"];
    
    [self initWithCategoryLabel];
}

- (void)initWithCategoryLabel
{
    CGRect frame = CGRectMake(15, 5, self.width - 30, 20);
    _categoryLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    
}

- (void)updateViewData:(id)entity
{
    ShopFoodCategoryDataEntity *categoryEnt = entity;
//    debugLog(@"name=%@", categoryEnt.name);
    _categoryLabel.text = [NSString stringWithFormat:@"%@（%d）", categoryEnt.name, (int)[categoryEnt.foods count]];//@"名厨推荐（0）";
}

@end


















