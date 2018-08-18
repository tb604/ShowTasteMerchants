/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualificationViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 21:47
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopQualificationViewCell.h"
#import "LocalCommon.h"
#import "CTCShopQualicationImageView.h"
//#import "CTCShopLicenseDataEntity.h"
#import "CTCShopCertificateDataEntity.h"
#import "UIImageView+WebCache.h"

@interface CTCShopQualificationViewCell ()
{
    CTCShopQualicationImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    /// 描述
    UILabel *_descLabel;
}

@property (nonatomic, strong) CTCShopCertificateDataEntity *licenseEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

/**
 *  初始化描述
 */
- (void)initWithDescLabel;

@end

@implementation CTCShopQualificationViewCell

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
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, [[self class] getWithCellHeight] - 0.5, [[UIScreen mainScreen] screenWidth], 0.5) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    // 初始化描述
    [self initWithDescLabel];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        NSInteger width = [[self class] getWithCellHeight] - 20;
        CGRect frame = CGRectMake(0, 10, width, width);
        _thumalImgView = [[CTCShopQualicationImageView alloc] initWithFrame:frame];
        _thumalImgView.right = [[UIScreen mainScreen] screenWidth] - 10;
        _thumalImgView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [_thumalImgView updateWithTitle:@"添加图片"];
        [self.contentView addSubview:_thumalImgView];
    }
    __weak typeof(self)weakSelf = self;
    _thumalImgView.touchWithBlock = ^()
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(nil);
        }
    };
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(10, 15, _thumalImgView.left - 10 - 10, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
}

/**
 *  初始化描述
 */
- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = _titleLabel.frame;
        frame.size.height = 16;
        frame.origin.y = frame.size.height + frame.origin.y + 3;
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:nil fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    NSString *str = @"已通过";
    UIColor *color = [UIColor colorWithHexString:@"#00b259"];
    NSString *url = nil;
    // 0：未处理 1：有问题 2：成功
    if ([_titleLabel.text isEqualToString:@"营业执照"])
    {
        if ([objectNull(_licenseEntity.name) isEqualToString:@""] || _licenseEntity.status == 0) // 未审核
        {
            // debugLog(@"if");
            url = objectNull(_licenseEntity.name);
            str = @"必填";
            color = [UIColor colorWithHexString:@"#999999"];
        }
        else if (_licenseEntity.status == 1)
        {// 有问题
            // debugLog(@"elseif");
            str = _licenseEntity.remark;
            color = [UIColor colorWithHexString:@"#cc0000"];
            url = _licenseEntity.name;
        }
        else
        {
            // debugLog(@"else");
            url = _licenseEntity.name;
        }
        debugLog(@"name=%@", _licenseEntity.name);
        debugLog(@"--url=%@", url);
    }
    else if ([_titleLabel.text isEqualToString:@"餐厅经营许可证/卫生许可证"])
    {
        if ([objectNull(_licenseEntity.name) isEqualToString:@""] || _licenseEntity.status == 0)
        {
            str = @"必填";
            url = objectNull(_licenseEntity.name);
            color = [UIColor colorWithHexString:@"#999999"];
        }
        else if (_licenseEntity.status == 1)
        {// 有问题
            str = _licenseEntity.remark;
            color = [UIColor colorWithHexString:@"#cc0000"];
            url = _licenseEntity.name;
        }
        else
        {
            url = _licenseEntity.name;
        }
    }
    else if ([_titleLabel.text isEqualToString:@"健康证(1)"])
    {
        if ([objectNull(_licenseEntity.name) isEqualToString:@""] || _licenseEntity.status == 0)
        {
            str = @"可选";
            url = objectNull(_licenseEntity.name);
            color = [UIColor colorWithHexString:@"#999999"];
        }
        else if (_licenseEntity.status == 1)
        {// 有问题
            str = _licenseEntity.remark;//@"证件上传不完整，请参考范例";
            color = [UIColor colorWithHexString:@"#cc0000"];
            url = _licenseEntity.name;
        }
        else
        {
            url = _licenseEntity.name;
        }
    }
    else if ([_titleLabel.text isEqualToString:@"健康证(2)"])
    {
        if ([objectNull(_licenseEntity.name) isEqualToString:@""]  || _licenseEntity.status == 0)
        {
            str = @"可选";
            url = objectNull(_licenseEntity.name);
            color = [UIColor colorWithHexString:@"#999999"];
        }
        else if (_licenseEntity.status == 1)
        {// 有问题
            str = _licenseEntity.name;//@"证件上传不完整，请参考范例";
            color = [UIColor colorWithHexString:@"#cc0000"];
            url = _licenseEntity.name;
        }
        else
        {
            url = _licenseEntity.name;
        }
    }
    
    debugLog(@"url=%@", url);
    
    _descLabel.textColor = color;
    _descLabel.text = str;
    if (![objectNull(url) isEqualToString:@""])
    {
        [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        [_thumalImgView hiddenWithTitle:YES];
    }
    else
    {
        [_thumalImgView hiddenWithTitle:NO];
    }
}

+ (NSInteger)getWithCellHeight
{
    return [[UIScreen mainScreen]screenWidth] / 4.6875;
}

- (void)updateCellData:(id)cellEntity title:(NSString *)title
{
    self.licenseEntity = cellEntity;
    debugLog(@"title=%@", title);
    debugLog(@"-----enurl=%@", _licenseEntity.name);
    
    _titleLabel.text = title;
    
    // 初始化描述
    [self initWithDescLabel];
}

@end













