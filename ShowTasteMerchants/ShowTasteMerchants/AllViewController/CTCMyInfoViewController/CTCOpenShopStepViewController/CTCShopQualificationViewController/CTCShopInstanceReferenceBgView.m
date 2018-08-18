/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopInstanceReferenceBgView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 22:18
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopInstanceReferenceBgView.h"
#import "LocalCommon.h"

@interface CTCShopInstanceReferenceBgView ()

- (void)initWithSubView;

@end

@implementation CTCShopInstanceReferenceBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    UIImage *image = [UIImage imageWithContentsOfFileName:@"aptitude_bg_example.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
    imageView.image = image;
    [self addSubview:imageView];
    
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.touchWithHiddenBlock)
        {
            weakSelf.touchWithHiddenBlock();
        }
    }];
    [self addGestureRecognizer:tap];
    
}

@end










