/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualicationImageView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 22:54
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopQualicationImageView.h"
#import "LocalCommon.h"

@interface CTCShopQualicationImageView ()
{
    UILabel *_titleLabel;
}

- (void)initWithSubView;

- (void)initWithTitleLabel;

@end

@implementation CTCShopQualicationImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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

- (void)initWithSubView
{
    [self initWithTitleLabel];
    self.userInteractionEnabled = YES;
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.touchWithBlock)
        {
            weakSelf.touchWithBlock();
        }
    }];
    [self addGestureRecognizer:tap];
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(5, (self.height - 20)/2., self.width - 10, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
    }
}

- (void)hiddenWithTitle:(BOOL)hidden
{
    _titleLabel.hidden = hidden;
}

- (void)updateWithTitle:(NSString *)title
{
    
    _titleLabel.text = title;
}

@end













