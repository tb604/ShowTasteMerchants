/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerPerMissCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 10:08
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerPerMissCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface CTCRestaurantManagerPerMissCell ()
{
    UILabel *_titleLabel;
    
//    UITextView *_textView;
    UILabel *_detailLabel;
    
    
}

@property (nonatomic, strong) CALayer *bottomLine;

- (void)initWithBottomLine;

- (void)initWithTitleLabel;

- (void)initWithDetailLabel;

@end

@implementation CTCRestaurantManagerPerMissCell

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
    
    [self initWithBottomLine];
    
    [self initWithTitleLabel];
    
    [self initWithDetailLabel];
}

- (void)initWithBottomLine
{
    if (!_bottomLine)
    {
        CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(0, kCTCRestaurantManagerPerMissCellHeight - 0.5, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        self.bottomLine = line;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, 15, [[UIScreen mainScreen] screenWidth] - 20, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

- (void)initWithDetailLabel
{
    if (!_detailLabel)
    {
        CGRect frame = CGRectMake(10, _titleLabel.bottom + 10, [[UIScreen mainScreen] screenWidth] - 20, 60);
        _detailLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _detailLabel.numberOfLines = 0;
    }
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *ent = cellEntity;
    _titleLabel.text = ent.title;
    _detailLabel.height = ent.subTitleHeight;
    _detailLabel.attributedText = ent.subTitleAttri;
//    UIColor *color = [UIColor colorWithHexString:@"#dddddd"];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 10;
//    NSDictionary *attribute = @{NSFontAttributeName:FONTSIZE_13,NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName: color};
//    NSAttributedString *attriStr = [[NSAttributedString alloc]initWithString:cellEntity attributes:attribute];
//    _textView.attributedText = attriStr;
    
    self.bottomLine.bottom = kCTCRestaurantManagerPerMissCellHeight - 20 + ent.subTitleHeight;
}

@end


























