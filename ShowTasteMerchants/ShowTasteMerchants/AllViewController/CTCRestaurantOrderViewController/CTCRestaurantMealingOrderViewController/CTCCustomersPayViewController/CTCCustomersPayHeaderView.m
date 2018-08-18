/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayHeaderView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/27 18:22
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayHeaderView.h"
#import "LocalCommon.h"
#import "CTCMealOrderDetailsEntity.h"


@interface CTCCustomersPayHeaderView ()
{
    UILabel *_titleLabel;
}

- (void)initWithTitleLabel;

@end

@implementation CTCCustomersPayHeaderView

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
    
    [self initWithTitleLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(15, (self.height - 20)/2., [[UIScreen mainScreen] screenWidth] - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(24) labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)updateViewData:(id)entity
{
    CTCMealOrderDetailsEntity *orderEntity = entity;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@号买单", orderEntity.seat_number];
    
}

@end


























