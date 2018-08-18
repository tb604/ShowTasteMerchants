/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCUserInfoHeadViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 14:32
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCUserInfoHeadViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "UIImageView+WebCache.h"

@interface CTCUserInfoHeadViewCell ()
{
    UILabel *_titleLabel;
    
    UIImageView *_headImgView;
}

@property (nonatomic, strong) CALayer *bottomLine;

- (void)initWithTitleLabel;

- (void)initWithHeadImgView;

@end

@implementation CTCUserInfoHeadViewCell

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
    
    [self initWithHeadImgView];
    
    if (!_bottomLine)
    {
        CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kCTCUserInfoHeadViewCellHeight - 0.5, [[UIScreen mainScreen] screenWidth] - 30, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
        self.bottomLine = line;
    }
    self.bottomLine.hidden = YES;
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"头像";
        float width = [str widthForFont:FONTSIZE_13];
        CGRect frame = CGRectMake(15, (kCTCUserInfoHeadViewCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        UIImage *image = [UIImage imageWithContentsOfFileName:@"home_top_head_boss.png"];
        if ([UserLoginStateObject readWithUserLoginType] == 2)
        {// 员工
            image = [UIImage imageWithContentsOfFileName:@"home_top_head_yg.png"];
        }
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 40 - 15, (kCTCUserInfoHeadViewCellHeight-40)/2., 40, 40);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 40.0/2;
        _headImgView.image = image;
        [self.contentView addSubview:_headImgView];
    }
}

- (void)hiddenBottomLine:(BOOL)hidden
{
    _bottomLine.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity title:(NSString *)title
{
    _titleLabel.text = title;
    
    UIImage *image = [UIImage imageWithContentsOfFileName:@"home_top_head_boss.png"];
    if ([objectNull(cellEntity) isEqualToString:@""])
    {
        _headImgView.image = image;
    }
    else
    {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:cellEntity] placeholderImage:image];
    }
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *ent = cellEntity;
    _titleLabel.text = ent.title;
    UIImage *image = [UIImage imageWithContentsOfFileName:@"home_top_head_boss.png"];
    if ([objectNull(ent.thumalImgName) isEqualToString:@""])
    {
        _headImgView.image = image;
    }
    else
    {
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:ent.thumalImgName] placeholderImage:image];
    }
}

@end





















