//
//  LocationCityTableViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "LocationCityTableViewCell.h"
#import "LocalCommon.h"

@interface LocationCityTableViewCell ()
{
    UILabel *_titleLabel;
    
//    UILabel *_descLabel;
    
    UIButton *_btnRefresh;
    
}

- (void)initWithTitleLabel;

- (void)initWithDescLabel;

- (void)initWithBtnRefresh;

@end

@implementation LocationCityTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithBtnRefresh];
    
    [self initWithDescLabel];
    
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        NSString *str = @"GPS定位";
        CGFloat width = [str widthForFont:FONTSIZE_15 height:20];
        CGRect frame = CGRectMake(15, (46.0-20)/2, width, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = str;
    }
}

- (void)initWithBtnRefresh
{
    if (!_btnRefresh)
    {
        // kaicanting_addr_btn_refurbish
        UIImage *image = [UIImage imageNamed:@"kaicanting_addr_btn_refurbish"];
        CGRect frame = CGRectMake(0, (46.0-image.size.height)/2, image.size.width, image.size.height);
        _btnRefresh = [TYZCreateCommonObject createWithButton:self imgNameNor:@"kaicanting_addr_btn_refurbish" imgNameSel:@"kaicanting_addr_btn_refurbish" targetSel:@selector(clickedRefresh:)];
        _btnRefresh.frame = frame;
        _btnRefresh.right = [[UIScreen mainScreen] screenWidth] - 15;
        [self.contentView addSubview:_btnRefresh];
    }
}


- (void)initWithDescLabel
{
    if (!_descLabel)
    {
        CGRect frame = CGRectMake(_titleLabel.right + 10, 0, [[UIScreen mainScreen] screenWidth] - (_titleLabel.right - 20)*2, 20);
        _descLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_16 labelTag:0 alignment:NSTextAlignmentCenter];
        _descLabel.centerY = _titleLabel.centerY;
//        _descLabel.backgroundColor = [UIColor lightGrayColor];
        _descLabel.text = @"定位中";
    }
}

- (void)clickedRefresh:(id)seder
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(nil);
    }
}

- (void)updateCellData:(id)cellEntity
{
    if ([objectNull(cellEntity) isEqualToString:@""])
    {
        _descLabel.text = @"定位失败";
    }
    else
    {
        _descLabel.text = cellEntity;
    }
}


@end
