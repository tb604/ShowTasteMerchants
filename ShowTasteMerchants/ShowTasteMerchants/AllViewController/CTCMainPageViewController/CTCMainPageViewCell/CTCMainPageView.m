/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMainPageView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/14 14:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCMainPageView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface CTCMainPageView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}

@property (nonatomic, strong) CellCommonDataEntity *cellEntity;

@property (nonatomic, strong) CALayer *leftLine;

@property (nonatomic, strong) CALayer *rightLine;

@property (nonatomic, strong) CALayer *bottomLine;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation CTCMainPageView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
//    self.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
//    self.layer.borderWidth = 0.5;
//    self.backgroundColor = [UIColor lightGrayColor];
    CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, 0, 0.5, self.height) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.leftLine = line;
    
    line = [CALayer drawLine:self frame:CGRectMake(self.width, 0, 0.5, self.height) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.rightLine = line;
    
    line = [CALayer drawLine:self frame:CGRectMake(0, self.height-0.5, self.width, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.bottomLine = line;
    
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(weakSelf.cellEntity);
        }
    }];
    [self addGestureRecognizer:tap];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        UIImage *image = [UIImage imageNamed:@"home_oreder_icon_history"];
        CGRect frame = CGRectMake((self.width - image.size.width) / 2., 0, image.size.width, image.size.height);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = image;
        _thumalImgView.bottom = self.height / 2.;
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, _thumalImgView.bottom + 20, self.width - 20, 16);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

+ (CGFloat)getWithWidth
{
    return [[UIScreen mainScreen] screenWidth] / 3;
}

+ (CGFloat)getWithHeight
{
    return [self getWithWidth];
}

- (void)hiddenWithLeftLine:(BOOL)hidden
{
    self.leftLine.hidden = hidden;
}

- (void)hiddenWithRightLine:(BOOL)hidden
{
    self.rightLine.hidden = hidden;
}

- (void)hiddenWithBottomLine:(BOOL)hidden
{
    self.bottomLine.hidden = hidden;
}

- (void)updateViewData:(id)entity
{
    self.cellEntity = entity;
    
    _thumalImgView.image = [UIImage imageNamed:_cellEntity.thumalImgName];
    _titleLabel.text = _cellEntity.title;
    
}

@end
