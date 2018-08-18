/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayFooterView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 11:38
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayFooterView.h"
#import "LocalCommon.h"
#import "CTCMealOrderDetailsEntity.h"

@interface CTCCustomersPayFooterView ()
{
    /// 合计、应付视图
    UIView *_sfyfView;
    
    /// 合计
    UILabel *_totalTitleLabel;
    
    /// 合计金额
    UILabel *_totalAmountLabel;
    
    /// 总数量
    UILabel *_totalCountLabel;
    
    /// 应付
    UILabel *_yfTitleLabel;
    
    /// 应付金额
    UILabel *_yfAmountLabel;
    
    /// 实付
    UILabel *_sfTitleLabel;
    
    /// 实付金额
    UILabel *_sfAmountLabel;
    
    /// 修改按钮
    UIButton *_btnEdit;
    
    /// 备注信息，(当修改总金额的时候，需要输入原因)
    UILabel *_noteLabel;
}

@property (nonatomic, strong) CTCMealOrderDetailsEntity *orderDetailEntity;

@property (nonatomic, strong) CALayer *line;

/**
 * 实付应付视图
 */
- (void)initWithSfyfView;

/**
 *  初始化合计
 */
- (void)initWithTotalTitleLabel;

/**
 *  合计总金额
 */
- (void)initWithTotalAmountLabel;

/**
 *  合计总数量
 */
- (void)initWithTotalCountLabel;

/**
 *  初始化应付
 */
- (void)initWithYfTitleLabel;

/**
 *  初始化应付金额
 */
- (void)initWithYfAmountLabel;

/**
 *  初始化实付
 */
- (void)initWithSfTitleLabel;

/**
 *  初始化实付金额
 */
- (void)initWithSfAmountLabel;

- (void)initWithBtnEdit;

- (void)initWithNoteLabel;

@end

@implementation CTCCustomersPayFooterView

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
    
    // 实付应付视图
    [self initWithSfyfView];
    
    CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, _sfyfView.bottom + 45, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e2e2e2"]];
    self.line = line;
    
    // 初始化合计
    [self initWithTotalTitleLabel];
    
    // 合计总金额
    [self initWithTotalAmountLabel];
    
    // 合计总数量
    [self initWithTotalCountLabel];
    
    // 初始化应付
    [self initWithYfTitleLabel];
    
    // 初始化应付金额
    [self initWithYfAmountLabel];
    
    // 初始化实付
    [self initWithSfTitleLabel];
    
    // 初始化实付金额
    [self initWithSfAmountLabel];
    
    [self initWithBtnEdit];
    
    [self initWithNoteLabel];
}

/**
 * 实付应付视图
 */
- (void)initWithSfyfView
{
    if (!_sfyfView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 72.);
        _sfyfView = [[UIView alloc] initWithFrame:frame];
        _sfyfView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:_sfyfView];
    }
}

/**
 *  初始化合计
 */
- (void)initWithTotalTitleLabel
{
    if (!_totalTitleLabel)
    {
        NSString *str = @"合计：";
        float width = [str widthForFont:FONTSIZE_15] + 2;
        CGRect frame = CGRectMake(10, 15, width, 16);
        _totalTitleLabel = [TYZCreateCommonObject createWithLabel:_sfyfView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _totalTitleLabel.text = str;
    }
}

/**
 *  合计总金额
 */
- (void)initWithTotalAmountLabel
{
    if (!_totalAmountLabel)
    {
        NSString *str = @"￥123453459";
        if (kiPhone4 || kiPhone5)
        {
            str = @"￥123453";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - width - 10, 0, width, 16);
        _totalAmountLabel = [TYZCreateCommonObject createWithLabel:_sfyfView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        _totalAmountLabel.centerY = _totalTitleLabel.centerY;
//        _totalAmountLabel.text = @"￥457.00";
    }
    _totalAmountLabel.text = [NSString stringWithFormat:@"￥%.2f", _orderDetailEntity.yf_amount];
}

/**
 *  合计总数量
 */
- (void)initWithTotalCountLabel
{
    if (!_totalCountLabel)
    {
        NSString *str = @"数量你号我";
        if (kiPhone4 || kiPhone5)
        {
            str = @"数量你";
        }
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake(_totalAmountLabel.left - 5 - width, _totalAmountLabel.y, width, 16);
        _totalCountLabel = [TYZCreateCommonObject createWithLabel:_sfyfView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        _totalCountLabel.centerY = _totalTitleLabel.centerY;
//        _totalCountLabel.text = @"32";
    }
    _totalCountLabel.text = [NSString stringWithFormat:@"%d", (int)_orderDetailEntity.total_count];
}

/**
 *  初始化应付
 */
- (void)initWithYfTitleLabel
{
    if (!_yfTitleLabel)
    {
        CGRect frame = _totalTitleLabel.frame;
        _yfTitleLabel = [TYZCreateCommonObject createWithLabel:_sfyfView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _yfTitleLabel.bottom = _sfyfView.height - 15;
        _yfTitleLabel.text = @"应付：";
    }
}

/**
 *  初始化应付金额
 */
- (void)initWithYfAmountLabel
{
    if (!_yfAmountLabel)
    {
        CGRect frame = _totalAmountLabel.frame;
        _yfAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentRight];
        _yfAmountLabel.centerY = _yfTitleLabel.centerY;
//        _yfAmountLabel.text = @"￥246.00";
    }
    _yfAmountLabel.text = [NSString stringWithFormat:@"￥%.2f", _orderDetailEntity.yf_amount];
//
}

/**
 *  初始化实付
 */
- (void)initWithSfTitleLabel
{
    if (!_sfTitleLabel)
    {
        CGRect frame = _yfTitleLabel.frame;
        frame.origin.y = _sfyfView.bottom + (45.0-20)/2;
        _sfTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _sfTitleLabel.text = @"实付";
    }
}

/**
 *  初始化实付金额
 */
- (void)initWithSfAmountLabel
{
    if (!_sfAmountLabel)
    {
        CGRect frame = _totalAmountLabel.frame;
        frame.size.width = frame.size.width + 30;
        _sfAmountLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentRight];
        _sfAmountLabel.centerY = _sfTitleLabel.centerY;
        _sfAmountLabel.centerX = [[UIScreen mainScreen] screenWidth] / 2.;
//        _sfAmountLabel.text = @"￥200.00";
    }
    _sfAmountLabel.text = [NSString stringWithFormat:@"￥%.2f", _orderDetailEntity.sf_amount];
}

- (void)initWithBtnEdit
{
    if (!_btnEdit)
    {
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 50 - 10, 0, 50, 25);
        _btnEdit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"修改" titleColor:[UIColor colorWithHexString:@"#999999"] titleFont:FONTSIZE_13 targetSel:@selector(clickedWithEdit:)];
        _btnEdit.frame = frame;
        _btnEdit.centerY = _sfTitleLabel.centerY;
        _btnEdit.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        _btnEdit.layer.borderWidth = 1;
        [self addSubview:_btnEdit];
    }
}

- (void)initWithNoteLabel
{
    if (!_noteLabel)
    {
        CGRect frame = CGRectMake(10, _line.bottom + 10, [[UIScreen mainScreen] screenWidth] - 20, 38);
        _noteLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _noteLabel.numberOfLines = 2;
//        _noteLabel.backgroundColor = [UIColor lightGrayColor];
    }
    _noteLabel.text = _orderDetailEntity.waiter_amt_note;
}

- (void)clickedWithEdit:(id)sender
{
    if (_touchEditAmountBlock)
    {
        _touchEditAmountBlock();
    }
}

- (void)updateViewData:(id)entity
{
    self.orderDetailEntity = entity;
    
    // 合计总金额
    [self initWithTotalAmountLabel];
    
    // 合计总数量
    [self initWithTotalCountLabel];
    
    // 初始化应付金额
    [self initWithYfAmountLabel];
    
    // 初始化实付金额
    [self initWithSfAmountLabel];
    
    [self initWithNoteLabel];
    
}

@end



















