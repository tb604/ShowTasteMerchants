//
//  MyInfoLoginCommonButtonView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoLoginCommonButtonView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MyInfoLoginCommonButtonView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
}

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation MyInfoLoginCommonButtonView

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
        _thumalImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 28, 28)];
        _thumalImgView.centerY = self.height / 2;
        _thumalImgView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:CGRectMake(_thumalImgView.right + 10, 0, 40, 20) textColor:[UIColor colorWithHexString:@"#333333"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = self.height / 2;
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_titleLabel.text);
    }
}

- (void)updateViewData:(id)entity
{
    CellCommonDataEntity *dataEnt = entity;
    _thumalImgView.image = [UIImage imageNamed:dataEnt.thumalImgName];
    _titleLabel.text = dataEnt.title;
}

@end
