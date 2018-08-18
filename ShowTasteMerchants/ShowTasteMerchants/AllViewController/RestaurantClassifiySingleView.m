//
//  RestaurantClassifiySingleView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassifiySingleView.h"
#import "LocalCommon.h"
#import "CuisineTypeDataEntity.h"
#import "RestaurantClassifiySmallSingleView.h"

@interface RestaurantClassifiySingleView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
    CGFloat _height;
    
    NSMutableArray *_buttonList;
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CuisineTypeDataEntity *cuisineTypeEntity;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

@end

@implementation RestaurantClassifiySingleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    _buttonList = [NSMutableArray new];
    
    _height = kRestaurantClassifiySingleViewHeight;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, 0.8);
    line.left = 15;
    line.bottom = self.height;
    line.backgroundColor = [UIColor colorWithHexString:@"999999"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithThumalImgView
{
    if (!_thumalImgView)
    {
        CGRect frame = CGRectMake(15, 15, 20, 20);
        _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_thumalImgView];
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {
        CGRect frame = CGRectMake(_thumalImgView.right + 5, 0, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 5 - 15, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        _titleLabel.centerY = _thumalImgView.centerY;
    }
}

- (CGFloat)getClassifiySingleViewHeight
{
    return _height;
}

- (void)updateViewData:(id)entity
{
    [_buttonList removeAllObjects];
    self.cuisineTypeEntity = entity;
    _thumalImgView.image = [UIImage imageNamed:_cuisineTypeEntity.imageName];
    _titleLabel.text = _cuisineTypeEntity.title;
    
//    debugLog(@"width=%.2f", [[UIScreen mainScreen] screenWidth]);
    
    CGFloat topSpace = 10.0;
    CGFloat leftSpace = 15.0;
    CGFloat midSpace = 15.0;
    
    if (kiPhone4 || kiPhone5)
    {
        midSpace = 8.0;
    }
    CGFloat width = 0.0;
    NSInteger num = 0;
    if (_cuisineTypeEntity.listMaxFontNum <= 4)
    {
        num = 4;
    }
    else
    {
        num = 3;
    }
    width = ([[UIScreen mainScreen] screenWidth] - leftSpace * 2 - midSpace*(num - 1)) / num;
    
    NSInteger row = ceilf([_cuisineTypeEntity.content count] / (float)num);
    // (15+20+10+30+15)
    _height = kRestaurantClassifiySingleViewHeight - 30 + row * 30 + (row - 1) * midSpace;
    _line.bottom = _height;
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(15, _titleLabel.bottom, width, 30);
    int j = 0;
    for (int i=0; i<[_cuisineTypeEntity.content count]; i++)
    {
        CuisineContentDataEntity *ent = _cuisineTypeEntity.content[i];
        if ((i % num) == 0)
        {
            frame.origin.x = 15;
            if (i == 0)
            {
                frame.origin.y = frame.origin.y + topSpace;
            }
            else
            {
                frame.origin.y = frame.origin.y + frame.size.height + topSpace;
            }
            j = 1;
        }
        else
        {
            frame.origin.x = 15 + j * (width + midSpace);
            j++;
        }
        
        RestaurantClassifiySmallSingleView *view = [[RestaurantClassifiySmallSingleView alloc] initWithFrame:frame];
        view.viewCommonBlock = ^(id data)
        {
            [weakSelf selectTypeView:data];
        };
        [view updateViewData:ent];
        [self addSubview:view];
        [_buttonList addObject:view];
    }
    
}

- (void)selectTypeView:(RestaurantClassifiySmallSingleView *)view
{
    for (RestaurantClassifiySmallSingleView *sview in _buttonList)
    {
        if (![sview isEqual:view])
        {
            [sview updateButtonUnSelected];
        }
    }
    if (self.viewCommonBlock)
    {
        if ([view getButtonSelected])
        {
            self.viewCommonBlock(view.contentEntity);
        }
        else
        {
            self.viewCommonBlock(nil);
        }
    }
}

@end























