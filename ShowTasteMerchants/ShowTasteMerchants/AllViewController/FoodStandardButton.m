//
//  FoodStandardButton.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FoodStandardButton.h"
#import "LocalCommon.h"

@interface FoodStandardButton ()
{
    UIImageView *_thumalImgView;
}

- (void)initWithThumalImgView;

@end

@implementation FoodStandardButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithThumalImgView];
    }
    return self;
}

- (void)initWithThumalImgView
{
    // order_icon_selected
    UIImage *image = [UIImage imageNamed:@"order_icon_selected"];
    CGRect frame = CGRectMake(self.width - image.size.width, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    _thumalImgView.hidden = YES;
    [self addSubview:_thumalImgView];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _thumalImgView.hidden = !selected;
}

//- (void)hiddenWithRightImgView:(BOOL)hidden
//{
//    
//}

@end
