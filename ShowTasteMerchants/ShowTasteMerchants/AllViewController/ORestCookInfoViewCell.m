//
//  ORestCookInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestCookInfoViewCell.h"
#import "LocalCommon.h"
#import "CookInfoView.h"
#import "RestaurantChefDataEntity.h"
#import "UIImageView+WebCache.h"


@interface ORestCookInfoViewCell ()
{
    UIImageView *_headImgView;
    
    UILabel *_titleLabel;
    
    /**
     *  姓名
     */
    CookInfoView *_nameView;
    
    /**
     *  等级
     */
    CookInfoView *_levelView;
    
    /**
     *  介绍
     */
    CookInfoView *_introduceView;
    
    /**
     *  介绍的内容
     */
    UILabel *_introduceLabel;
}

- (void)initWithHeadImgView;

- (void)initWithTitleLabel;

- (void)initWithNameView;

- (void)initWithLevelView;

- (void)initWithIntroduceView;

- (void) initWithIntroduceLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ORestCookInfoViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithHeadImgView];
    
    [self initWithTitleLabel];
    
    [self initWithNameView];
    
    [self initWithLevelView];
    
    [self initWithIntroduceView];
    
    [self initWithIntroduceLabel];
}

- (void)initWithHeadImgView
{
    if (!_headImgView)
    {
        CGRect frame = CGRectMake(15, 15, [[self class] getHeadImgWidth], [[self class] getHeadImgWidth]);
//        debugLog(@"width=%.2f", [[self class] getHeadImgWidth]);
        _headImgView = [[UIImageView alloc] initWithFrame:frame];
//        _headImgView.backgroundColor = [UIColor lightGrayColor];
        _headImgView.tag = 103;
        _headImgView.userInteractionEnabled = YES;
        _headImgView.image = [UIImage imageNamed:@"chef_default_head"];
        [self.contentView addSubview:_headImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_headImgView addGestureRecognizer:tap];
    }
    
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_headImgView.right + 10, _headImgView.top, [[UIScreen mainScreen] screenWidth] - _headImgView.right - 10 - 15, 14);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.text = @"基本信息";
    }
}

- (void)initWithNameView
{
    if (!_nameView)
    {
        CGRect frame = CGRectMake(_headImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _headImgView.right - 10 - 15, kCookInfoViewHeight);
        _nameView = [[CookInfoView alloc] initWithFrame:frame];
        _nameView.tag = 100;
        [self.contentView addSubview:_nameView];
        _nameView.centerY = _headImgView.centerY - 3;
//        _nameView.backgroundColor = [UIColor lightGrayColor];
        
//        NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
//        UIColor *color = [UIColor colorWithHexString:@"#ff5500"];
//        NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"人均" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
//        [mas appendAttributedString:butedStr];

    }
    __weak typeof(self)weakSelf = self;
    _nameView.viewCommonBlock = ^(id data)
    {
        [weakSelf clicked:data];
    };
}

- (void)initWithLevelView
{
    if (!_levelView)
    {
        CGRect frame = CGRectMake(_headImgView.right + 10, 0, [[UIScreen mainScreen] screenWidth] - _headImgView.right - 10 - 15, kCookInfoViewHeight);
        _levelView = [[CookInfoView alloc] initWithFrame:frame];
        _levelView.tag = 101;
        [self.contentView addSubview:_levelView];
        _levelView.bottom = _headImgView.bottom;
//        _levelView.backgroundColor = [UIColor lightGrayColor];
        
    }
    __weak typeof(self)weakSelf = self;
    _levelView.viewCommonBlock = ^(id data)
    {
        [weakSelf clicked:data];
    };
}

- (void)initWithIntroduceView
{
    if (!_introduceView)
    {
        CGRect frame = CGRectMake(15, _headImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, kCookInfoViewHeight);
        _introduceView = [[CookInfoView alloc] initWithFrame:frame];
        _introduceView.tag = 102;
//        _introduceView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_introduceView];
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"介绍" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        CGFloat titleWidth = [[title string] widthForFont:FONTSIZE_12];
//        color = [UIColor colorWithHexString:@"#323232"];
//        NSAttributedString *value = [[NSAttributedString alloc] initWithString:@"国家特级厨师" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        [_introduceView updateWithTitle:title titleWidth:titleWidth value:nil alignment:NSTextAlignmentCenter];
        [_introduceView hiddenBottomLine:YES];
    }
    __weak typeof(self)weakSelf = self;
    _introduceView.viewCommonBlock = ^(id data)
    {
        [weakSelf clicked:data];
    };
}

- (void) initWithIntroduceLabel
{
    if (!_introduceLabel)
    {
        CGRect frame = CGRectMake(15.0, _introduceView.bottom, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _introduceLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#a1a1a1"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
//        _introduceLabel.text = @"都是非法但是复苏的";
        _introduceLabel.numberOfLines = 0;
    }
}

- (void)clicked:(id)data
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(data);
    }
    
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    [self clicked:@(103)];
}

+ (CGFloat)getCookInfoViewCellHeight
{
    return 90.0 + [self getHeadImgWidth];
}

+ (CGFloat)getHeadImgWidth
{
    return 100.0;//[[UIScreen mainScreen] screenWidth] / 3.75;
}

- (void)updateCellData:(id)cellEntity
{
    RestaurantChefDataEntity *chefEntity = cellEntity;
//    debugLog(@"厨师信息=%@", [chefEntity modelToJSONString]);
    // 头像
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:chefEntity.image] placeholderImage:[UIImage imageNamed:@"chef_default_head"]];
    
    // 厨师姓名
    UIColor *color = [UIColor colorWithHexString:@"#646464"];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"姓名" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    CGFloat titleWidth = [[title string] widthForFont:FONTSIZE_12];
    color = [UIColor colorWithHexString:@"#323232"];
    NSAttributedString *value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", chefEntity.name] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [_nameView updateWithTitle:title titleWidth:titleWidth value:value alignment:NSTextAlignmentCenter];
    
    // 等级
    color = [UIColor colorWithHexString:@"#646464"];
    title = [[NSAttributedString alloc] initWithString:@"等级" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    titleWidth = [[title string] widthForFont:FONTSIZE_12];
    color = [UIColor colorWithHexString:@"#323232"];
    value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", chefEntity.title] attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
    [_levelView updateWithTitle:title titleWidth:titleWidth value:value alignment:NSTextAlignmentCenter];
    
    // 简介
    _introduceLabel.text = chefEntity.intro;
    _introduceLabel.height = chefEntity.introHeight;
    
}

@end



























