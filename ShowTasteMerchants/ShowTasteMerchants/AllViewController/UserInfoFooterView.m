//
//  UserInfoFooterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserInfoFooterView.h"
#import "LocalCommon.h"

@interface UserInfoFooterView ()
{
    /**
     *  退出登录
     */
    UIButton *_btnOutLogin;
    
    UILabel *_descLabel;
}

- (void)initWithBtnOutLogin;

- (void)initWithDescLabel;

@end

@implementation UserInfoFooterView

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
    
    [self initWithBtnOutLogin];
    
    [self initWithDescLabel];
}

- (void)initWithBtnOutLogin
{
    if (!_btnOutLogin)
    {
        CGFloat top = 50;
        CGRect frame = CGRectMake(15, top, self.width - 30, 40);
        _btnOutLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"退出当前账号" titleColor:[UIColor colorWithHexString:@"#646464"] titleFont:FONTSIZE_14 targetSel:@selector(clickedButton:)];
        _btnOutLogin.frame = frame;
        _btnOutLogin.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self addSubview:_btnOutLogin];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(_btnOutLogin.left, _btnOutLogin.bottom + 10, _btnOutLogin.width, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        
    }
}

- (void)clickedButton:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}


- (void)updateViewData:(id)entity
{
//    _descLabel.text = @"注册时间  2016-02-01";
}

@end
