/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserInfoFooterView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 15:52
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCUserInfoFooterView.h"
#import "LocalCommon.h"

@interface CTCUserInfoFooterView ()
{
    /// 退出登录
    UIButton *_btnOutLogin;
}

- (void)initWithBtnOutLogin;

@end

@implementation CTCUserInfoFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBtnOutLogin];
}

- (void)initWithBtnOutLogin
{
    if (!_btnOutLogin)
    {
        CGRect frame = CGRectMake(15, (kCTCUserInfoFooterViewHeight - 30)/2., [[UIScreen mainScreen] screenWidth] - 30, 40);
        
        _btnOutLogin = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"退出" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_13 targetSel:@selector(clickedOutLogin:)];
        _btnOutLogin.frame = frame;
        _btnOutLogin.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btnOutLogin];
    }
}

- (void)clickedOutLogin:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

@end
























