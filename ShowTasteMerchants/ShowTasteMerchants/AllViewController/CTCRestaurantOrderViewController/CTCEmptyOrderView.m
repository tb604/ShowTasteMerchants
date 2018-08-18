//
//  CTCEmptyOrderView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "CTCEmptyOrderView.h"
#import "LocalCommon.h"


@interface CTCEmptyOrderView ()
{
    UIImageView *_thumalImgView;
}

- (void)initWithThumalImgView;

@end

@implementation CTCEmptyOrderView

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
    
    [self initWithThumalImgView];
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageWithContentsOfFileName:@"order_empty_icon.png"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
//    _thumalImgView.backgroundColor = [UIColor purpleColor];
    _thumalImgView.image = image;
    _thumalImgView.center = CGPointMake(self.width/2., self.height / 2.);
    [self addSubview:_thumalImgView];
}

@end
