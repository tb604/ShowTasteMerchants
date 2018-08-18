/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantManagerAddFooterView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/21 09:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantManagerAddFooterView.h"
#import "LocalCommon.h"

@interface CTCRestaurantManagerAddFooterView ()
{
    UILabel *_descLabel;
}

- (void)initWithDescLabel;

@end

@implementation CTCRestaurantManagerAddFooterView

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
    
    [self initWithDescLabel];
    
}

- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        NSString *str = @"查看权限说明";
        float width = [str widthForFont:FONTSIZE_12];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - width, (kCTCRestaurantManagerAddFooterViewHeight - 30)/2., width, 30);
        _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:nil labelTag:0 alignment:NSTextAlignmentRight];
        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
        UIColor *color = [UIColor colorWithHexString:@"#999999"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"查看" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        
        [UIColor colorWithHexString:@"#323232"];
        bTitle = [[NSAttributedString alloc] initWithString:@"权限说明" attributes:@{NSFontAttributeName: FONTBOLDSIZE(12), NSForegroundColorAttributeName: color}];
        [mas appendAttributedString:bTitle];
        _descLabel.attributedText = mas;
        _descLabel.userInteractionEnabled = YES;
        __weak typeof(self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            debugLog(@"查看权限说明");
            if (weakSelf.viewCommonBlock)
            {
                weakSelf.viewCommonBlock(nil);
            }
        }];
        [_descLabel addGestureRecognizer:tap];
    }
}

@end
























