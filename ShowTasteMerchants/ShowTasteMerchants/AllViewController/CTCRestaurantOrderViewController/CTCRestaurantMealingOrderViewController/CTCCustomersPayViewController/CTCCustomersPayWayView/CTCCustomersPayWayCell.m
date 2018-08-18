/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayWayCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 14:43
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayWayCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface CTCCustomersPayWayCell ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}
@property (nonatomic, strong) CellCommonDataEntity *payWayEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation CTCCustomersPayWayCell

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

    [CALayer drawLine:self.contentView frame:CGRectMake(10, 45.0-0.5, [[UIScreen mainScreen] screenWidth] - 20, 0.5) lineColor:[UIColor colorWithHexString:@"#e2e2e2"]];
    
    // pay_icon_zhifubao.png
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
}


- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"pay_icon_zhifubao.png"];
        CGRect frame = CGRectMake(10, (45-image.size.height)/2., image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 10, (45-20)/2., [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 30, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)updateCellData:(id)cellEntity
{
    self.payWayEntity = cellEntity;
    
    _thumalImgView.image = [UIImage imageWithContentsOfFileName:_payWayEntity.thumalImgName];
    _titleLabel.text = _payWayEntity.title;
    
}

@end













