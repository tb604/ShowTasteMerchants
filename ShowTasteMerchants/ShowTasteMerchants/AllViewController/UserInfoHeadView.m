//
//  UserInfoHeadView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserInfoHeadView.h"
#import "LocalCommon.h"
#import "UserLoginStateObject.h"
#import "UIImageView+WebCache.h"


@interface UserInfoHeadView ()
{
    /**
     *  头像
     */
    UIImageView *_headImgView;
    
    /**
     *  相机
     */
    UIImageView *_cameraImgView;
    
}

- (void)initWithHeadImgView;

- (void)initWithCameraImgView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation UserInfoHeadView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#db3400"];
    
    [self initWithHeadImgView];
    
    [self initWithCameraImgView];
    
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _headImgView.image = [UIImage imageNamed:@"head_default"];
        _headImgView.layer.borderColor = [UIColor colorWithHexString:@"#cabdad"].CGColor;
        _headImgView.layer.borderWidth = 1;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 100.0 / 2;
        _headImgView.userInteractionEnabled = YES;
        _headImgView.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:_headImgView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_headImgView addGestureRecognizer:tap];
}

- (void)initWithCameraImgView
{
    if (!_cameraImgView)
    {
        _cameraImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        //_cameraImgView.backgroundColor = [UIColor whiteColor];
        _cameraImgView.image = [UIImage imageNamed:@"btn_photo"];
        _cameraImgView.layer.borderColor =  [UIColor colorWithHexString:@"#cabdad"].CGColor;
        _cameraImgView.layer.borderWidth = 1;
        _cameraImgView.layer.masksToBounds = YES;
        _cameraImgView.layer.cornerRadius = 32.0 / 2;
        _cameraImgView.center = CGPointMake(self.width/2, _headImgView.bottom);
        _cameraImgView.userInteractionEnabled = YES;
        [self addSubview:_cameraImgView];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [_cameraImgView addGestureRecognizer:tap];
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
    UserInfoDataEntity *userInfo = entity;
    
    NSString *headerUrl = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", userInfo.avatar, [NSDate stringWithCurrentTimeStamp]];
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
}

@end
