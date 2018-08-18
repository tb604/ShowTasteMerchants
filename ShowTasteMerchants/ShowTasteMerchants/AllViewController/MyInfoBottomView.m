//
//  MyInfoBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoBottomView.h"
#import "LocalCommon.h"
#import "UserInfoDataEntity.h"
#import "UserLoginStateObject.h"

@interface MyInfoBottomView ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thumalImgView;
}

- (void)initWithTitleLabel:(NSString *)title;

- (void)initWithThumalImgView;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation MyInfoBottomView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    [self initWithThumalImgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithTitleLabel:(NSString *)title
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(0, 0, 20, 40) textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//        [_titleLabel addGestureRecognizer:tap];
    }
    _titleLabel.centerY = self.height / 2;
    CGFloat fontWidth = [title widthForFont:_titleLabel.font] + 20;
    _titleLabel.width = fontWidth;
    _titleLabel.right = self.width / 2 + 20;
    _titleLabel.text = title;
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        _thumalImgView = [UIImageView new];
        [self addSubview:_thumalImgView];
    }
    UIImage *image = [UIImage imageNamed:@"i_btn_change"];
    _thumalImgView.image = image;
//    _thumalImgView.backgroundColor = [UIColor orangeColor];
    _thumalImgView.centerY = _titleLabel.centerY;
    _thumalImgView.width = image.size.width;
    _thumalImgView.height = image.size.height;
    if ([_titleLabel.text length] == 2)
    {
        _thumalImgView.left = _titleLabel.right + 30;
    }
    else
    {
//        debugLog(@"width=%.2f", self.width);
        _thumalImgView.right = self.width - _titleLabel.left - 20;
    }
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.bottomClickedBlock)
    {
        self.bottomClickedBlock(_titleLabel.text, 0);
    }
}

- (void)updateViewData:(id)entity
{
    UserInfoDataEntity *userInfo = entity;
    // UserLoginStateObject
    // 1表示未登录；2表示订购模式；3表示经营模式
    debugLog(@"userType=%d", (int)userInfo.user_type);
    if ([UserLoginStateObject userLoginState] == EUserUnlogin)
    {
        [self initWithTitleLabel:@"登录"];
        _titleLabel.centerX = self.width / 2;
        
        [self initWithThumalImgView];
        _thumalImgView.hidden = YES;
    }
    else if (userInfo && userInfo.userMode == 0 && userInfo.user_type == 1 && userInfo.shop_id == 0)
    {// 我要开店
        [self initWithTitleLabel:@"我要开店"];
        _titleLabel.right = self.width / 2 + 20;
        
        [self initWithThumalImgView];
        _thumalImgView.hidden = YES;
    }
    else if (userInfo && userInfo.userMode == 0)
    {// 普通模式
        [self initWithTitleLabel:@"进入经营模式"];
        _titleLabel.right = self.width / 2 + 20;
        
        [self initWithThumalImgView];
        _thumalImgView.hidden = NO;
    }
    else if (userInfo.userMode == 1)
    {// 经营模式
        [self initWithTitleLabel:@"进入订购模式"];
        _titleLabel.right = self.width / 2 + 20;
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
        [self initWithThumalImgView];
        _thumalImgView.hidden = NO;
    }
    else
    {
        [self initWithTitleLabel:@"切换到订购模式"];
        _titleLabel.right = self.width / 2 + 20;
        
        [self initWithThumalImgView];
        _thumalImgView.hidden = NO;
    }
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
}

@end
