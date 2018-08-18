/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMainMessageNoteCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/14 16:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCMainMessageNoteCell.h"
#import "LocalCommon.h"


@interface CTCMainMessageNoteCell ()
{
    UIImageView *_iconImgView;
    
    UILabel *_noteNumLabel;
    
    UILabel *_titleLabel;
    
    UIImageView *_thanImgView;
    
    UILabel *_detailLabel;
}

@property (nonatomic, strong) CALayer *vline;

- (void)initWithIconImgView;

- (void)initWithNoteNumLabel;

- (void)initWithTitleLabel;

- (void)initWithThanImgView;

- (void)initWithDetailLabel;

@end

@implementation CTCMainMessageNoteCell

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
    
    [self initWithIconImgView];
    
    [self initWithNoteNumLabel];
    
    [self initWithTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithDetailLabel];
}

- (void)initWithIconImgView
{
    if (!_iconImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_inform_icon_message"];
        CGRect frame = CGRectMake(10, (kCTCMainMessageNoteCellHeight - image.size.height*1.2)/2., image.size.width*1.2, image.size.height*1.2);
        _iconImgView = [[UIImageView alloc] initWithFrame:frame];
        _iconImgView.image = image;
        [self.contentView addSubview:_iconImgView];
    }
}

- (void)initWithNoteNumLabel
{
    if (!_noteNumLabel)
    {
        CGRect frame = _iconImgView.bounds;
        _noteNumLabel = [TYZCreateCommonObject createWithLabel:_iconImgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_9 labelTag:0 alignment:NSTextAlignmentCenter];
        _noteNumLabel.text = @"32";
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"通知";
        float width = [str widthForFont:FONTSIZE_16];
        CGRect frame = CGRectMake(_iconImgView.right + 5, (kCTCMainMessageNoteCellHeight-20)/2., width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentCenter];
        _titleLabel.text = str;
        
        
        CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(_titleLabel.right + 10, 13, 1, kCTCMainMessageNoteCellHeight - 13 * 2) lineColor:[UIColor colorWithHexString:@"#cdcdcd"]];
        self.vline = line;
        
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_inform_btn_more"];
        CGRect frame = CGRectMake(0, (kCTCMainMessageNoteCellHeight-image.size.height)/2., image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.right = [[UIScreen mainScreen] screenWidth] - 10;
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
    }
}

- (void)initWithDetailLabel
{
    if (!_detailLabel)
    {
        CGRect frame = CGRectMake(_vline.right + 10, (kCTCMainMessageNoteCellHeight - 20)/2., _thanImgView.left - _vline.right - 10 - 15, 20);
        _detailLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _detailLabel.text = @"无先生在06/10/13预定了一个餐位，收电费水费。";
    }
}

@end















