/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: ThridPartPayChoiceView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/27 23:07
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "ThridPartPayChoiceView.h"
#import "LocalCommon.h"
#import "PayInfoDataEntity.h"

// escrow_icon_zhifubaozhifu

@interface ThridPartPayChoiceView ()
{
    /// 支付类型图片
    UIImageView *_payTypeImgView;
    
    /// 支付类型名称
    UILabel *_payTitleLabel;
    
    /// 是否设置这个支付
    UISwitch *_onPaySwitch;
    
    
    
    /// 二维码图片
    UIImageView *_qrcodeImgView;
    
    UILabel *_descLabel;
}

@property (nonatomic, strong) PayInfoDataEntity *payEntity;

@property (nonatomic, strong) CALayer *midLine;

@property (nonatomic, strong) CALayer *bottomLine;


- (void)initWithMidLine;

- (void)initWithBottomLine;

/**
 *  支付类型图片
 */
- (void)initWithPayTypeImgView;

/**
 *  支付类型名称
 */
- (void)initWithPayTitleLabel;

/**
 *  是否设置这个支付
 */
- (void)initWithOnPaySwitch;

/**
 *  支付账号
 */
- (void)initWithPayAccountTxtField;

- (void)initWithQrcodeImgView;

- (void)initWithDescLabel;

@end

@implementation ThridPartPayChoiceView

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
    
    [self initWithMidLine];
    
    [self initWithBottomLine];
    
    // 支付类型图片
    [self initWithPayTypeImgView];
    
    // 支付类型名称
    [self initWithPayTitleLabel];
    
    // 是否设置这个支付
    [self initWithOnPaySwitch];
    
    // 支付账号
    [self initWithPayAccountTxtField];
    
    [self initWithQrcodeImgView];
    
    [self initWithDescLabel];
}

- (void)initWithMidLine
{
    if (!_midLine)
    {
        CALayer *line = [CALayer drawLine:self frame:CGRectMake(10, 72, [[UIScreen mainScreen] screenWidth] - 20, 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
        self.midLine = line;
    }
}

- (void)initWithBottomLine
{
    if (!_bottomLine)
    {
        CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, kThridPartPayChoiceViewHeight - 0.5, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#cbcbcb"]];
        self.bottomLine = line;
    }
}

/**
 *  支付类型图片
 */
- (void)initWithPayTypeImgView
{
    if (!_payTypeImgView)
    {
        UIImage *Image = [UIImage imageNamed:@"escrow_icon_zhifubaozhifu"];
        CGRect frame = CGRectMake(10, 15, Image.size.width, Image.size.height);
        _payTypeImgView = [[UIImageView alloc] initWithFrame:frame];
//        _payTypeImgView.image = Image;
        [self addSubview:_payTypeImgView];
    }
    
    UIImage *image = [UIImage imageNamed:_payEntity.payImageName];
    _payTypeImgView.image = image;
}

/**
 *  支付类型名称
 */
- (void)initWithPayTitleLabel
{
    if (!_payTitleLabel)
    {
        NSString *str = @"支付宝账户";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(_payTypeImgView.right + 5, 0, width, 20);
        _payTitleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _payTitleLabel.centerY = _payTypeImgView.centerY;
    }
    _payTitleLabel.text = _payEntity.payName;
}

/**
 *  是否设置这个支付
 */
- (void)initWithOnPaySwitch
{
    if (!_onPaySwitch)
    {
        CGRect frame = CGRectMake(0, 0, 100, 28);
        _onPaySwitch = [[UISwitch alloc] initWithFrame:frame];
        _onPaySwitch.right = [[UIScreen mainScreen] screenWidth] - 10;
        _onPaySwitch.centerY = _payTitleLabel.centerY;
        [_onPaySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_onPaySwitch];
    }
}

/**
 *  支付账号
 */
- (void)initWithPayAccountTxtField
{
    if (!_payAccountTxtField)
    {
        CGRect frame = CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] / 3 * 2, 30);
        _payAccountTxtField = [[UITextField alloc] initWithFrame:frame];
        _payAccountTxtField.font = FONTSIZE_15;
//        _payAccountTxtField.textColor = [UIColor colorWithHexString:@"#cccccc"];
        if (_payEntity.type == 1)
        {
            _payAccountTxtField.placeholder = @"请输入支付宝收款账号";
        }
        else
        {
            _payAccountTxtField.placeholder = @"请输入微信收款账号";
        }
        _payAccountTxtField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _payAccountTxtField.returnKeyType = UIReturnKeyDone;
        _payAccountTxtField.borderStyle = UITextBorderStyleNone;
        _payAccountTxtField.textAlignment = NSTextAlignmentLeft;
        _payAccountTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _payAccountTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _payAccountTxtField.delegate = self;
        _payAccountTxtField.bottom = _midLine.top - 6;
        [self addSubview:_payAccountTxtField];
    }
    
    _payAccountTxtField.text = _payEntity.account;
}

- (void)initWithQrcodeImgView
{
    if (!_qrcodeImgView)
    {
        CGRect frame = CGRectMake(10, 10+_midLine.bottom, 100, 100);
        _qrcodeImgView = [[UIImageView alloc] initWithFrame:frame];
        _qrcodeImgView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_qrcodeImgView];
        _qrcodeImgView.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            if (weakSelf.uploadQrcodeImageBlock)
            {
                weakSelf.uploadQrcodeImageBlock(_payEntity);
            }
        }];
        [_qrcodeImgView addGestureRecognizer:tap];
    }
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(_qrcodeImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _qrcodeImgView.right - 10 - 10, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        _descLabel.centerY = _qrcodeImgView.centerY;
    }
    if (_payEntity.type == 1)
    {
        _descLabel.text = @"请上传支付宝收款二维码";
    }
    else
    {
        _descLabel.text = @"请上传微信收款二维码";
    }
}

- (void)hiddenWithBottomLine:(BOOL)hidden
{
    _bottomLine.hidden = hidden;
}

- (void)switchAction:(id)sender
{
    UISwitch *onSwitch = (UISwitch *)sender;
    
}

- (void)updateViewData:(id)entity
{
    self.payEntity = entity;
    
    // 支付类型图片
    [self initWithPayTypeImgView];
    
    // 支付类型名称
    [self initWithPayTitleLabel];
    
    // 是否设置这个支付
    [self initWithOnPaySwitch];
    
    // 支付账号
    [self initWithPayAccountTxtField];
    
    [self initWithQrcodeImgView];
    
    [self initWithDescLabel];
}

@end










