//
//  RestaurantMenuContentCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuContentCell.h"
#import "LocalCommon.h"
#import "RestaurantMenuContentView.h"
#import "ShopFoodDataEntity.h"
#import "UIImageView+WebCache.h"


@interface RestaurantMenuContentCell ()
{
    UIImageView *_thumalImgView;
    
    RestaurantMenuContentView *_contentView;
}

@property (nonatomic, strong) ShopFoodDataEntity *foodEntity;

- (void)initWithThumalImgView;

- (void)initWithContentView;

@end

@implementation RestaurantMenuContentCell

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
    
    [self initWithThumalImgView];
    
    [self initWithContentView];
    
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longGesture];
    
}

- (void)initWithLine
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
    
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(rightWidth, 0.8);
    line.left = 0;
    line.bottom = [[self class] getWithMenuContentCellHeight];
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
        int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
        CGRect frame = CGRectMake(0, 0, rightWidth, [[self class] getWithImgViewHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        CGRect frame = CGRectMake(0, _thumalImgView.bottom, _thumalImgView.width, kRestaurantMenuContentViewHeight);
        _contentView = [[RestaurantMenuContentView alloc] initWithFrame:frame];
        [self.contentView addSubview:_contentView];
    }
}


+ (NSInteger)getWithImgViewHeight
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    int rightWidth = [[UIScreen mainScreen] screenWidth] - leftWidth;
    
    return (rightWidth / 1.425);
}

+ (NSInteger)getWithMenuContentCellHeight
{
    return [self getWithImgViewHeight] + kRestaurantMenuContentViewHeight;
}

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
    if (self.baseTableViewCellBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
            //            debugLog(@"开始");
            self.baseTableViewCellBlock(_foodEntity);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
            //            debugLog(@"结束");
        }
    }
}


- (void)updateCellData:(id)cellEntity
{
    ShopFoodDataEntity *foodEntity = cellEntity;
//    debugLog(@"image=%@", foodEntity.image);
    self.foodEntity = foodEntity;
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:foodEntity.image] placeholderImage:nil];
    
    [_contentView updateViewData:cellEntity];
    
}

@end
