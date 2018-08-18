//
//  DeliveryOrderInfoChargeView.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrderInfoChargeView.h"
#import "LocalCommon.h"

@interface DeliveryOrderInfoChargeView ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
}

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

@end

@implementation DeliveryOrderInfoChargeView

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
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.touchChargeBlock)
        {
            weakSelf.touchChargeBlock();
        }
    }];
    [self addGestureRecognizer:tap];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"收取";
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake(0, (self.height - 20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#52a3cc"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"展开";
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"btn_takeout_sprend.png"];
        CGRect frame = CGRectMake(_titleLabel.right + 5, (self.height-image.size.height)/2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self addSubview:_thanImgView];
    }
}

- (void)updateWithCharge:(BOOL)charge
{
    if (charge)
    {
        _titleLabel.text = @"收取";
        _thanImgView.image = [UIImage imageWithContentsOfFileName:@"btn_takeout_close.png"];
    }
    else
    {
        _titleLabel.text = @"展开";
        _thanImgView.image = [UIImage imageWithContentsOfFileName:@"btn_takeout_sprend.png"];
    }
}

@end













