/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMainHeaderView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/14 13:47
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCMainHeaderView.h"
#import "LocalCommon.h"
#import "UIImageView+WebCache.h"

@interface CTCMainHeaderView ()
{
    UIImageView *_thumalImgView;
    
    UIImageView *_bottomView;
    
    /// 人数
    UILabel *_numLabel;
}

- (void)initWithThumalImgView;

- (void)initWithBottomView;

@end

@implementation CTCMainHeaderView

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
    
    [self initWithThumalImgView];
    
//    [self initWithBottomView];
    
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[self class] getWithViewHeight]);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        _thumalImgView.image = [UIImage imageNamed:@"home_top_phone"];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        CGRect frame = CGRectMake(0, [[self class] getWithViewHeight] - 30, [[UIScreen mainScreen] screenWidth], 30);
        _bottomView = [[UIImageView alloc] initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        _bottomView.userInteractionEnabled = YES;
        [self addSubview:_bottomView];
        
        // 右边的按钮，上传图片
        UIImage *image = [UIImage imageNamed:@"home_btn_phone"];
        frame = CGRectMake(0, 0, image.size.width*1.5, image.size.height*1.5);
        UIButton *btnUpload = [TYZCreateCommonObject createWithButton:self imgNameNor:@"home_btn_phone" imgNameSel:@"home_btn_phone" targetSel:@selector(clickedWithUpload:)];
        btnUpload.frame = frame;
        btnUpload.right = [[UIScreen mainScreen] screenWidth] - 10;
        btnUpload.centerY = _bottomView.height / 2;
        [_bottomView addSubview:btnUpload];
        
        // 左边的视图
        image = [UIImage imageNamed:@"home_icon_member"];
        frame = CGRectMake(10, 0, image.size.width, image.size.height);
        UIImageView *numImgView = [[UIImageView alloc] initWithFrame:frame];
        numImgView.image = image;
        numImgView.centerY = btnUpload.centerY;
        [_bottomView addSubview:numImgView];
        
        frame = CGRectMake(numImgView.right + 5, (30.0-20)/2., btnUpload.left - numImgView.right - 5 - 20, 20);
        _numLabel = [TYZCreateCommonObject createWithLabel:_bottomView labelFrame:frame textColor:[UIColor whiteColor] fontSize:FONTSIZE(13) labelTag:0 alignment:NSTextAlignmentLeft];
//        _numLabel.text = @"全体成员12人";
    }
}

- (void)clickedWithUpload:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

+ (NSInteger)getWithViewHeight
{
    return [[UIScreen mainScreen] screenWidth] / 1.893939;
}

- (void)updateViewData:(id)entity
{
    int number = [entity intValue];
    _numLabel.text = [NSString stringWithFormat:@"全体成员%d人", number];
}

@end























