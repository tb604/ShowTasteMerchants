/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserInfoViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 14:24
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCUserInfoViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface CTCUserInfoViewCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_valueLabel;
}
@property (nonatomic, strong) CALayer *bottomLine;

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithValueLabel;

@end

@implementation CTCUserInfoViewCell

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
    
    if (!_bottomLine)
    {
        CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kCTCUserInfoViewCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 30, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
        self.bottomLine = line;
    }
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithValueLabel];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"手机号码";
        float width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake(15, (kCTCUserInfoViewCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"home_inform_btn_more.png"];
        CGRect frame = CGRectMake(0, (kCTCUserInfoViewCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithValueLabel
{
    if (!_valueLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, (kCTCUserInfoViewCellHeight-20)/2., _thanImgView.left - _titleLabel.right - 20, 20);
        _valueLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
    }
}

- (void)updateCellData:(id)cellEntity title:(NSString *)title hiddenLine:(BOOL)hiddenLine isModify:(BOOL)isModify
{
    if (title)
    {
        _titleLabel.text = title;
    }
    
    _bottomLine.hidden = hiddenLine;
    if (cellEntity)
    {
        _valueLabel.text = cellEntity;
    }
    
    if (isModify)
    {
        _valueLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    }
    else
    {
        _valueLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *entity = cellEntity;
    _titleLabel.text = entity.title;
    
    NSString *value = objectNull(entity.subTitle);
    if ([value isEqualToString:@""])
    {
        value = entity.placeholder;
    }
    _valueLabel.text = value;
}

- (void)hiddenWithThanImgView:(BOOL)hidden
{
    _thanImgView.hidden = hidden;
}

@end















