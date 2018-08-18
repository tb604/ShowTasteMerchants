//
//  OMPlatInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/23.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMPlatInfoViewCell.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"
#import "OrderMealDataEntity.h"

@interface OMPlatInfoViewCell ()
{
    OMNearFoodTopView *_topView;
    
    UIImageView *_thumalImgView;
}

@property (nonatomic, strong) OrderMealDataEntity *orderMealEntity;

- (void)initWithTopView;

- (void)initWithThumalImgView;

@end

@implementation OMPlatInfoViewCell

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
    
    [self initWithTopView];
    
    [self initWithThumalImgView];

}


- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOMNearFoodTopViewHeight);
        _topView = [[OMNearFoodTopView alloc] initWithFrame:frame];
        [self.contentView addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.touchWithMoreInfoBlock = ^()
    {
        if (weakSelf.touchWithMoreInfoBlock)
        {
            weakSelf.touchWithMoreInfoBlock();
        }
    };
}


- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], [[self class] getThumalImgViewHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

/**
 *  图片的高度
 *
 *  @return <#return value description#>
 */
+ (NSInteger)getThumalImgViewHeight
{
    return (NSInteger)[[UIScreen mainScreen] screenWidth] / 1.63;
}

+ (CGFloat)getPlatInfoViewCellHeight
{
    return kOMNearFoodTopViewHeight + [self getThumalImgViewHeight];
}


- (void)updateCellData:(id)cellEntity
{
    self.orderMealEntity = cellEntity;
    
    [_topView updateViewData:_orderMealEntity.borad_name];
    
    OrderMealContentEntity *cEnt = _orderMealEntity.content;
    
    NSString *imgUrl = objectNull(cEnt.image);
    if (![imgUrl isEqualToString:@""])
    {
        imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", imgUrl];
//        debugLog(@"imgUrl=%@", imgUrl);
    }
    
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
}

@end















