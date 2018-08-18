/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPaySubmitView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 15:55
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPaySubmitView.h"
#import "LocalCommon.h"


@interface CTCCustomersPaySubmitView ()
{
    UIView *_bgView;
    
    /// 提示
    UILabel *_tipLabel;
    
    UILabel *_msgLabel;
    
    UILabel *_descLabel;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CALayer *verticalLine;

- (void)initWithVar;

- (void)initWithSubView;

- (void)initWithBgView;

- (void)initWithTipLabel;

- (void)initWithMsgLabel;

- (void)initWithDescLabel;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation CTCCustomersPaySubmitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVar];
        
        [self initWithSubView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithVar
{
    
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithBgView];
    
    CALayer *line = [CALayer drawLine:_bgView frame:CGRectMake(0, _bgView.height - 45, _bgView.width, 0.5) lineColor:[UIColor colorWithHexString:@"cccccc"]];
    self.line = line;
    
    line = [CALayer drawLine:_bgView frame:CGRectMake(0, _line.bottom, 0.5, 45) lineColor:[UIColor colorWithHexString:@"cccccc"]];
    line.centerX = _bgView.width / 2.;
    self.verticalLine = line;
    
    [self initWithTipLabel];
    
    [self initWithMsgLabel];
    
    [self initWithDescLabel];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
}

- (void)initWithBgView
{
    if (!_bgView)
    {
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - 300)/2., ([[UIScreen mainScreen] screenHeight] - 200)/2., 300, 200);
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 4;
        [self addSubview:_bgView];
    }
}

- (void)initWithTipLabel
{
    if (!_tipLabel)
    {
        CGRect frame = CGRectMake(20, 30, _bgView.width - 40, 20);
        _tipLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentCenter];
        _tipLabel.text = @"提示";
    }
}

- (void)initWithMsgLabel
{
    if (!_msgLabel)
    {
        CGRect frame = CGRectMake(10, _tipLabel.bottom + 30, _bgView.width - 20, 16);
        _msgLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentCenter];
        _msgLabel.text = @"请确认是否完成交易";
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = _msgLabel.frame;
        frame.origin.y = _msgLabel.bottom + 10;
        _msgLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentCenter];
        _msgLabel.text = @"(由店家承担确认收款事宜)";
    }
}

- (void)initWithBtnCancel
{
    if (!_btnCancel)
    {
        CGRect frame = CGRectMake(0, _line.bottom, _bgView.width/2., _verticalLine.height);
        _btnCancel = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"取消" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnCancel.frame = frame;
        _btnCancel.tag = 100;
        [_bgView addSubview:_btnCancel];
    }
}

- (void)initWithBtnSubmit
{
    if (!_btnSubmit)
    {
        CGRect frame = _btnCancel.frame;
        frame.origin.x = _bgView.width / 2.;
        _btnSubmit = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确定" titleColor:[UIColor colorWithHexString:@"#323232"] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithButton:)];
        _btnSubmit.frame = frame;
        _btnSubmit.tag = 101;
        [_bgView addSubview:_btnSubmit];
    }
}

- (void)clickedWithButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (_touchCancelSubmitBlock)
    {
        _touchCancelSubmitBlock(btn.tag);
    }
}

@end





















