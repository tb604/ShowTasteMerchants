//
//  ResaurantAddFoodImageViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ResaurantAddFoodImageViewCell.h"
#import "LocalCommon.h"
#import "ResaurantAddFoodImageView.h"
#import "ShopFoodDataEntity.h"
#import "FoodAavourableActivityView.h"
#import "UIImageView+WebCache.h"

@interface ResaurantAddFoodImageViewCell ()
{
    UILabel *_titleLabel;
    
    ResaurantAddFoodImageView *_thumalImgView;
    
    /**
     *  优惠活动视图
     */
    FoodAavourableActivityView *_activityView;
}

- (void)initWithTitleLabel;

- (void)initWithThumalImgView;

- (void)initWithActivityView;

@end

@implementation ResaurantAddFoodImageViewCell

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
    
    [self initWithTitleLabel];
    
    [self initWithThumalImgView];
    
    [self initWithActivityView];
    
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.text = @"菜品图片";
}

- (void)initWithThumalImgView
{
    CGRect frame = CGRectMake(15, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
    _thumalImgView = [[ResaurantAddFoodImageView alloc] initWithFrame:frame];
    _thumalImgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    _thumalImgView.layer.borderWidth = 1;
    [self.contentView addSubview:_thumalImgView];
    __weak typeof(self) weakSelf = self;
    _thumalImgView.touchUploadImageBlock = ^()
    {
        if (weakSelf.touchUploadFoodImageBlock)
        {
            weakSelf.touchUploadFoodImageBlock();
        }
    };
}

- (void)initWithActivityView
{
    CGRect frame = CGRectMake(0, _thumalImgView.bottom + 10, [[UIScreen mainScreen] screenWidth], kFoodAavourableActivityViewHeight);
    _activityView = [[FoodAavourableActivityView alloc] initWithFrame:frame];
//    _activityView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_activityView];
    __weak typeof(self) weakSelf = self;
    _activityView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}

- (void)updateCellData:(id)cellEntity
{
    ShopFoodDataEntity *imageEntity = cellEntity;
//    debugLog(@"image=%@", imageEntity.image);
//    _thumalImgView.image = imageEntity.imageData;
    if ([objectNull(imageEntity.image) isEqualToString:@""])
    {
        [_thumalImgView hiddenWithThumalImage:NO];
    }
    else
    {
//        [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imageEntity.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            debugLog(@"err=%@", [error description]);
//            debugLogSize(image.size);
//        }];
        [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imageEntity.image] placeholderImage:nil];
        [_thumalImgView hiddenWithThumalImage:YES];
    }
    
    [_activityView updateViewData:imageEntity.remark title:@"优惠活动"];
}

@end

























