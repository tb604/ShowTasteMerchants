//
//  OMShareViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMShareViewCell.h"
#import "LocalCommon.h"
#import "OrderMealDataEntity.h"
#import "UIImageView+WebCache.h"
#import "OrderMealContentEntity.h"

@interface OMShareViewCell ()
{
    UIImageView *_thumalImgView;
}

- (void)initWithThumalImgView;

@end

@implementation OMShareViewCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#c0c0c0"]];
    
    [self initWithThumalImgView];
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 5, [[UIScreen mainScreen] screenWidth], [[self class] getWithImgHeigh]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

+ (NSInteger)getWithImgHeigh
{
    NSInteger height = [[UIScreen mainScreen] screenWidth] / 2.2058;
//    debugLog(@"height===%d", (int)height);
    return height;
}

+ (NSInteger)getWithCellHeight
{
    return ([self getWithImgHeigh] + 10);
}

- (void)updateCellData:(id)cellEntity
{
    OrderMealDataEntity *mealEnt = cellEntity;
    OrderMealContentEntity *contentEnt = mealEnt.content;
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:contentEnt.image] placeholderImage:nil];
}

@end
