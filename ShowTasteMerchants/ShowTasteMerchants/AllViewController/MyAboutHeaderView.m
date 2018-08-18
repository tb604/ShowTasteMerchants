//
//  MyAboutHeaderView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyAboutHeaderView.h"
#import "LocalCommon.h"

@interface MyAboutHeaderView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_versionLabel;
}

- (void)initWithThumalImgView;

- (void)initWithVersionLabel;

@end

@implementation MyAboutHeaderView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithThumalImgView];
    
    [self initWithVersionLabel];
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"login_icon_logo"];
        CGRect frame = CGRectMake((self.width - image.size.width*0.8)/2, (self.height - image.size.height*0.8)/2 - 10, image.size.width*0.8, image.size.height*0.8);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithVersionLabel
{
    if (!_versionLabel)
    {
        CGRect frame = CGRectMake(15, _thumalImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, 18);
        _versionLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
        _versionLabel.text = @"版本号 V1.1.1.1";
    }
}

- (void)updateViewData:(id)entity
{
    NSString *version = [NSString stringWithFormat:@"版本号 V%@", kLocalCurVersion];
    _versionLabel.text = version;
}

@end



























