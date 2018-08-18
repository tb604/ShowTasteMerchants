//
//  MyInfoHeadView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoHeadView.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"


@interface MyInfoHeadView ()
{
    UIImageView *_headImgView;
    
    UILabel *_nickNameLabel;
}

- (void)initWithHeadImgView;

- (void)initWithNickNameLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation MyInfoHeadView

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
    
    [self initWithHeadImgView];
    
    [self initWithNickNameLabel];
    
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        CGRect frame = CGRectMake(0, 0, 100, 100);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = frame.size.width / 2;
//        _headImgView.layer.borderWidth = 2;
//        _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImgView.centerY = self.width / 2;
        _headImgView.centerX = self.height / 2;
        _headImgView.image = [UIImage imageNamed:@"head_default"];
        [self addSubview:_headImgView];
        _headImgView.userInteractionEnabled = YES;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_headImgView addGestureRecognizer:tap];
}

- (void)initWithNickNameLabel
{
    if (!_nickNameLabel)
    {
        _nickNameLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(10, _headImgView.bottom + 10, self.width - 20, 20) textColor:[UIColor whiteColor] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
//        _nickNameLabel.text = @"游客";
        _nickNameLabel.centerX = _headImgView.centerX;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateViewData:(id)entity
{
    UserInfoDataEntity *userInfoEntity = entity;
    // 1表示未登录；2表示订购模式；3表示经营模式
    if ([entity isKindOfClass:[NSNumber class]])
    {
        if ([entity integerValue] == 1)
        {
            _headImgView.layer.borderWidth = 0;
            _headImgView.layer.borderColor =nil;
        }
        else
        {
            _headImgView.layer.borderWidth = 2;
            _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
    NSString *headerUrl = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", userInfoEntity.avatar, [NSDate stringWithCurrentTimeStamp]];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    NSString *faliyName = (userInfoEntity.family_name==nil?@"":userInfoEntity.family_name);
    NSString *lastName = (userInfoEntity.name==nil?@"":userInfoEntity.name);
    _nickNameLabel.text = [NSString stringWithFormat:@"%@%@", faliyName, lastName];
}

@end
