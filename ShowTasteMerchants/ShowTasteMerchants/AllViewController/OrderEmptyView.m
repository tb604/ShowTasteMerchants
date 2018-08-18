//
//  OrderEmptyView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OrderEmptyView.h"
#import "LocalCommon.h"

@interface OrderEmptyView ()
{
    UIImageView *_imgView;
    
    UILabel *_descLabel;
}

- (void)initWithImgView;

- (void)initWithDescLabel;

@end

@implementation OrderEmptyView

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithImgView];
    
    [self initWithDescLabel];

    self.userInteractionEnabled = NO;
    
    // temporarily-no-data02
}

- (void)initWithImgView
{
    if (!_imgView)
    {
        UIImage *image = [UIImage imageNamed:@"temporarily-no-data02"];
        CGRect frame = CGRectMake((self.width - image.size.width)/2, (self.height - image.size.height) / 2, image.size.width, image.size.height);
        _imgView = [[UIImageView alloc] initWithFrame:frame];
        _imgView.image = image;
        [self addSubview:_imgView];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGFloat width = [[UIScreen mainScreen] screenWidth] - 30;
        CGRect frame = CGRectMake((self.width - width)/2, _imgView.bottom, width, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.text = @"暂无订单";
    }
}

- (void)updateViewData:(id)entity
{
    _descLabel.text = entity;
}

@end
