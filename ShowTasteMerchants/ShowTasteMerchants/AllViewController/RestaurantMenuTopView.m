//
//  RestaurantMenuTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuTopView.h"
#import "LocalCommon.h"
#import "ShopFoodCategoryDataEntity.h"

@interface RestaurantMenuTopView ()
{
    UILabel *_categoryLabel;
    
    UILabel *_numLabel;
}

- (void)initWithCategoryLabel;

- (void)initWithNumLabel;

@end

@implementation RestaurantMenuTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
 
    [self initWithCategoryLabel];
    
    [self initWithNumLabel];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 1.0);
    line.left = 0;
    line.bottom = kRestaurantMenuTopViewHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithCategoryLabel
{
    if (!_categoryLabel)
    {
        CGRect frame = CGRectMake(10, (self.height-20) / 2, 30, 20);
        _categoryLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithNumLabel
{
    if (!_numLabel)
    {
        CGRect frame = CGRectMake(10, (self.height-20) / 2, 30, 20);
        _numLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentLeft];
        _numLabel.right = self.width - 10;
    }
}

- (void)updateWithCategoryTitle:(NSAttributedString *)category numTitle:(NSAttributedString *)numTitle
{
    // 类型名称
    CGFloat width = [[category string] widthForFont:FONTSIZE_12 height:20];
    _categoryLabel.width = width;
    _categoryLabel.attributedText = category;
    
    // 数量
    _numLabel.hidden = YES;
    if (numTitle)
    {
        width = [[numTitle string] widthForFont:FONTSIZE_12 height:20];
        _numLabel.width = width;
        _numLabel.right = self.width - 10;
        _numLabel.attributedText = numTitle;
        _numLabel.hidden = NO;
    }
}

- (void)updateViewData:(id)entity
{
    ShopFoodCategoryDataEntity *categoryEnt = entity;
    
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:objectNull(categoryEnt.name) attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [mas appendAttributedString:butedStr];
    if (categoryEnt.type == 0 || categoryEnt.type == 1)
    {
        color = [UIColor colorWithHexString:@"#646464"];
        butedStr = [[NSAttributedString alloc] initWithString:@"（可上传5道）" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:butedStr];
        
        
    }
    else
    {
//        color = [UIColor colorWithHexString:@"#646464"];
//        NSString *str = [NSString stringWithFormat:@"（%d）", (int)[categoryEnt.foods count]];
//        butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
//        [mas appendAttributedString:butedStr];
//        [self updateWithCategoryTitle:mas numTitle:nil];
    }
    
    NSMutableAttributedString *nummas = [[NSMutableAttributedString alloc] init];
    color = [UIColor colorWithHexString:@"#646464"];
    butedStr = [[NSAttributedString alloc] initWithString:@"已上传" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [nummas appendAttributedString:butedStr];
    color = [UIColor colorWithHexString:@"#ff5500"];
    NSString *str = [NSString stringWithFormat:@" %d ", (int)[categoryEnt.foods count]];
    butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [nummas appendAttributedString:butedStr];
    
    color = [UIColor colorWithHexString:@"#646464"];
    butedStr = [[NSAttributedString alloc] initWithString:@"道" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [nummas appendAttributedString:butedStr];
    [self updateWithCategoryTitle:mas numTitle:nummas];
}


@end
