//
//  ORestQualifCertView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestQualifCertView.h"
#import "LocalCommon.h"
#import "ORestQualifCertImageView.h"
#import "UIImageView+WebCache.h"
#import "RestaurantImageEntity.h"

@interface ORestQualifCertView ()
{
    UILabel *_titleLabel;
    
    ORestQualifCertImageView *_thumalImgView;
}

@property (nonatomic, strong) RestaurantImageEntity *imageEntity;

- (void)initWithTitleLabel;

- (void)initWithThumalImgView;

@end

@implementation ORestQualifCertView

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
    
    [self initWithThumalImgView];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, 20, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        
    }
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth], [[self class] getQualifCertImgViewHeight]);
        _thumalImgView = [[ORestQualifCertImageView alloc] initWithFrame:frame];
        [self addSubview:_thumalImgView];
    }
    __weak typeof(self)weakSelf = self;
    _thumalImgView.touchImgViewBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(@(weakSelf.tag));
        }
    };
}

+ (NSInteger)getQualifCertImgViewHeight
{
    return [[UIScreen mainScreen] screenWidth] / 1.5;
}

+ (CGFloat)getQualifCertViewCellHeight
{
    return 50 + [self getQualifCertImgViewHeight];
}

- (void)updateWithTitle:(NSString *)title imageEntity:(id)imageEntity
{
    _titleLabel.text = title;
    self.imageEntity = imageEntity;
    [_thumalImgView hiddenWithTitle:YES];
    if ([objectNull(_imageEntity.name) isEqualToString:@""])
    {
//        [_thumalImgView hiddenWithTitle:NO];
    }
    else
    {
//        [_thumalImgView hiddenWithTitle:YES];
        [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_imageEntity.name] placeholderImage:nil];
    }
}

- (void)hiddenWithTitle:(BOOL)hidden
{
    [_thumalImgView hiddenWithTitle:hidden];
}

@end














