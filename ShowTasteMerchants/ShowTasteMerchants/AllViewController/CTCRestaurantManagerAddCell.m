/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerAddCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 09:09
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerAddCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface CTCRestaurantManagerAddCell ()
{
    UILabel *_titleLabel;
    
    UILabel *_valueLabel;
}

- (void)initWithTitleLabel;

- (void)initWithValueLabel;

@end

@implementation CTCRestaurantManagerAddCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithValueLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"手机号码";
        float width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake(15, (kCTCRestaurantManagerAddCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 15, (kCTCRestaurantManagerAddCellHeight-20)/2., [[UIScreen mainScreen] screenWidth] - _titleLabel.right - 15 - 40, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *ent = cellEntity;
    _titleLabel.text = ent.title;
    _valueLabel.text = ent.subTitle;
}

@end

























