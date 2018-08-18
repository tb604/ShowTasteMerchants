/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualificationFooterView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 17:52
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopQualificationFooterView.h"
#import "LocalCommon.h"

@interface CTCShopQualificationFooterView ()
{
    UIView *_bottomView;
}

- (void)initWithBottomView;

@end

@implementation CTCShopQualificationFooterView

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
    
    [self initWithBottomView];
    
    
    NSString *str = @"查看图片实例参考";
    float width = [str widthForFont:FONTSIZE(12)];
    UIImage *image = [UIImage imageWithContentsOfFileName:@"aptitude_icon_see.png"];
    float leftSpace = ([[UIScreen mainScreen] screenWidth] - width - image.size.width - 5)/2.;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.left = leftSpace;
    imageView.centerY = 30 / 2.;
    [self addSubview:imageView];
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(imageView.right + 5, 0, width, 30);
    UILabel *label = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = str;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(nil);
        }
    }];
    [label addGestureRecognizer:tap];
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        CGRect frame = CGRectMake(0, 30, self.width, kCTCShopQualificationFooterViewHeight - 30);
        _bottomView = [[UIView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self addSubview:_bottomView];
        
        NSString *str = @"请确保所提供证件的真实性，我们将尽快审核";
        float width = [str widthForFont:FONTBOLDSIZE(12)];
        UIImage *image = [UIImage imageWithContentsOfFileName:@"aptitude_icon_hint.png"];
        float leftSpace = ([[UIScreen mainScreen] screenWidth] - width - image.size.width - 5) / 2.;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.top = 10;
        imageView.left = leftSpace;
//        imageView.centerY = _bottomView.height / 2.;
        [_bottomView addSubview:imageView];
        frame = CGRectMake(imageView.right + 5, 0, width, 20);
        UILabel *label = [TYZCreateCommonObject createWithLabel:_bottomView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(12) labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = str;
        label.centerY = imageView.centerY;
        
        frame = label.frame;
        frame.size.height = 16;
        frame.origin.y = frame.origin.y + frame.size.height;
        UILabel *desLabel = [TYZCreateCommonObject createWithLabel:_bottomView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE(10) labelTag:0 alignment:NSTextAlignmentCenter];
        desLabel.text = @"如有其他问题，可联系客服电话025-52817386";
    }
}

@end





















