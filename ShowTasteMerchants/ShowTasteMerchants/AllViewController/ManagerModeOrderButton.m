//
//  ManagerModeOrderButton.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ManagerModeOrderButton.h"
#import "LocalCommon.h"
#import "OrderButtonEntity.h"

@interface ManagerModeOrderButton ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
}
@property (nonatomic, strong) OrderButtonEntity *orderButtonEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ManagerModeOrderButton

- (void)initWithSubView
{
    [super initWithSubView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
    // btn_current_uorder_nor
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"btn_current_uorder_nor"];
    CGRect frame = CGRectMake((self.width - image.size.width)/2, 13, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:_thumalImgView];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, _thumalImgView.bottom + 2, self.width - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:nil fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentCenter];
//    _titleLabel.backgroundColor = [UIColor lightGrayColor];
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(self);
    }
}

- (void)updateWithSelect:(BOOL)selected
{
    if (selected)
    {
        _orderButtonEntity.isCheck = YES;
    }
    else
    {
        _orderButtonEntity.isCheck = NO;
    }
    
    [self updateViewData:_orderButtonEntity];
}

- (void)updateViewData:(id)entity
{
    self.orderButtonEntity = entity;
    _titleLabel.text = _orderButtonEntity.title;
    if (_orderButtonEntity.isCheck)
    {
        _thumalImgView.image = [UIImage imageNamed:_orderButtonEntity.imageNameSel];
        _titleLabel.textColor = _orderButtonEntity.titleColorSel;
    }
    else
    {
        _thumalImgView.image = [UIImage imageNamed:_orderButtonEntity.imageNameNor];
        _titleLabel.textColor = _orderButtonEntity.titleColorNor;
    }
}

@end
