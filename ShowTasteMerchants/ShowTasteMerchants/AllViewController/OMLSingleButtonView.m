//
//  OMLSingleButtonView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLSingleButtonView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface OMLSingleButtonView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}
@property (nonatomic, strong) CellCommonDataEntity *dataEnt;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation OMLSingleButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        _thumalImgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-[OMLSingleButtonView getWithButtonWidth])/2, 0, [OMLSingleButtonView getWithButtonWidth], [OMLSingleButtonView getWithButtonWidth])];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGFloat space = 5;
//        if (kiPhone4 || kiPhone5)
//        {
//            space = 2;
//        }
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(0, _thumalImgView.bottom + space, self.width, 15) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
//        _titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_dataEnt);
    }
}

- (void)updateViewData:(id)entity
{
    CellCommonDataEntity *dataEnt = entity;
    self.dataEnt = dataEnt;
    _thumalImgView.image = [UIImage imageNamed:dataEnt.thumalImgName];
    _titleLabel.text = dataEnt.title;
}

+ (NSInteger)getWithButtonWidth
{
//    kiPhone6Plus?55:45.0
    NSInteger width = 45;
    if (kiPhone6Plus)
    {
        width = 55;
    }
    else if (kiPhone4 || kiPhone5)
    {
        width = 40;
    }
    return width;
}

@end





















