/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualificationHeaderView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 17:52
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopQualificationHeaderView.h"
#import "LocalCommon.h"
#import "CTCShopLicenseDataEntity.h"

@interface CTCShopQualificationHeaderView ()
{
    UILabel *_titleLabel;
    
    /// 未通过视图
    UILabel *_passNotLabel;
}

- (void)initWithTitleLabel;

/// 未通过的提示
- (void)initWithPassNotLabel;

@end

@implementation CTCShopQualificationHeaderView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithTitleLabel];
    
    /// 未通过的提示
    [self initWithPassNotLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (kCTCShopQualificationHeaderViewHeight-20)/2., self.width - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE(15) labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = @"* 上传餐厅资质认证图片（4张）";
    }
}

/// 未通过的提示
- (void)initWithPassNotLabel
{
    if (!_passNotLabel)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        _passNotLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cc0000"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
        _passNotLabel.backgroundColor = [UIColor colorWithHexString:@"#feac00"];
    }
}

- (void)updateViewData:(id)entity
{
    CTCShopLicenseDataEntity *licenseEnt = entity;
    _passNotLabel.hidden = YES;
    _titleLabel.hidden = YES;
    
    // 1：未上传过资质图片 2：已上传，待审核  3：审核失败 4：审核成功
    
    _passNotLabel.text = @"等待审核中";
    if (!licenseEnt)
    {
        _passNotLabel.hidden = YES;
        _titleLabel.hidden = NO;
    }
    else if (licenseEnt.state == 2)
    {
        _passNotLabel.hidden = NO;
        _titleLabel.hidden = YES;
    }
    else if (licenseEnt.state == 3)
    {// 审核有问题
        _passNotLabel.text = @"审核未通过，请根据提示修改资质信息";
        _passNotLabel.hidden = NO;
        _titleLabel.hidden = YES;
    }
    else
    {
        _passNotLabel.hidden = YES;
        _titleLabel.hidden = NO;
    }
}

@end













