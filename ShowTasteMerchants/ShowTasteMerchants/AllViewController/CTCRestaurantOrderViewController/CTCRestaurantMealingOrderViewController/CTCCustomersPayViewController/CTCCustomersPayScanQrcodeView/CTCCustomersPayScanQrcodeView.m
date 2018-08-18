/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayScanQrcodeView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 15:08
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayScanQrcodeView.h"
#import "LocalCommon.h"
#import "PayChannelDataEntity.h"
#import "UIImageView+WebCache.h"

@interface CTCCustomersPayScanQrcodeView ()
{
    UIView *_bgView;
    
    /// 支付方式名称
    UILabel *_payWayNameLabel;
    
    /// 二维码图片
    UIImageView *_qrcodeImgView;
    
    UIButton *_btnCancel;
    
    UIButton *_btnSubmit;
    
}

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CALayer *verticalLine;

- (void)initWithVar;

- (void)initWithSubView;

- (void)initWithBgView;

- (void)initWithPayWayNameLabel;

- (void)initWithQrcodeImgView;

- (void)initWithBtnCancel;

- (void)initWithBtnSubmit;

@end

@implementation CTCCustomersPayScanQrcodeView

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
    
    [self initWithPayWayNameLabel];
    
    [self initWithQrcodeImgView];
    
    [self initWithBtnCancel];
    
    [self initWithBtnSubmit];
}

- (void)initWithBgView
{
    if (!_bgView)
    {
        CGRect frame = CGRectMake(([[UIScreen mainScreen] screenWidth] - 300)/2., 0, 300, 345);
        _bgView = [[UIView alloc] initWithFrame:frame];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.centerY = [[UIScreen mainScreen] screenHeight] / 2.;
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }
}

- (void)initWithPayWayNameLabel
{
    if (!_payWayNameLabel)
    {
        CGRect frame = CGRectMake(20, 30, _bgView.width - 40, 20);
        _payWayNameLabel = [TYZCreateCommonObject createWithLabel:_bgView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(18) labelTag:0 alignment:NSTextAlignmentCenter];
        _payWayNameLabel.text = @"支付宝";
    }
}

- (void)initWithQrcodeImgView
{
    if (!_qrcodeImgView)
    {
        CGRect frame = CGRectMake(0, _payWayNameLabel.bottom + 46, 130, 130);
        _qrcodeImgView = [[UIImageView alloc] initWithFrame:frame];
        _qrcodeImgView.backgroundColor = [UIColor lightGrayColor];
        _qrcodeImgView.centerX = _bgView.width / 2.;
        [_bgView addSubview:_qrcodeImgView];
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

- (void)updateWithData:(id)entity
{
    PayChannelDataEntity *payChanEnt = entity;
    _payWayNameLabel.text = payChanEnt.desc;
    [_qrcodeImgView sd_setImageWithURL:[NSURL URLWithString:payChanEnt.image] placeholderImage:nil];
}

@end










