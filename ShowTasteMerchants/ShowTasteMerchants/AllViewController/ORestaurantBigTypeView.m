//
//  ORestaurantBigTypeView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestaurantBigTypeView.h"
#import "LocalCommon.h"
#import "CuisineTypeDataEntity.h"

@interface ORestaurantBigTypeView ()
{
    UIImageView *_thumalImgView;
    
    UILabel *_titleLabel;
    
}

@property (nonatomic, strong) CuisineTypeDataEntity *typeEntity;

@property (nonatomic, strong) CALayer *lineOne;

@property (nonatomic, strong) CALayer *_lineTwo;

- (void)initWithThumalImgView;

- (void)initWithTitleLabel;

- (void)initWithLineOne;

- (void)initWithLineTwo;

@end

@implementation ORestaurantBigTypeView

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
    
    _selectedList = [NSMutableArray new];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithThumalImgView];
    
    [self initWithTitleLabel];
    
    [self initWithLineOne];
    
    [self initWithLineTwo];
}

- (void)initWithThumalImgView
{
    CGRect frame = CGRectMake(30, 20, 15, 15);
    if (kiPhone4 || kiPhone5)
    {
        frame.origin.x = 15;
    }
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:_thumalImgView];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(_thumalImgView.right + 5, 0, [[UIScreen mainScreen] screenWidth] - _thumalImgView.right - 5 - _thumalImgView.left, 15);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
    _titleLabel.centerY = _thumalImgView.centerY;
}

- (void)initWithLineOne
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] - _thumalImgView.left * 2, 1.0);
    line.left = _thumalImgView.left;
    line.top = _thumalImgView.bottom + 10;
    line.backgroundColor = [UIColor colorWithHexString:@"1b1b1b"].CGColor;
    [self.layer addSublayer:line];
    self.lineOne = line;
}

- (void)initWithLineTwo
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(_lineOne.width, 0.5);
    line.left = _thumalImgView.left;
    line.top = _lineOne.bottom + 1.2;
    line.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
    [self.layer addSublayer:line];
    self._lineTwo = line;
}

- (void)clickedButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    NSInteger index = btn.tag - 100;
    CuisineContentDataEntity *ent = _typeEntity.content[index];
    if (btn.selected)
    {
        [self addWithCuisineData:ent];
    }
    else
    {
        [self removeWithCuisineData:ent];
    }
}

- (void)removeWithCuisineData:(CuisineContentDataEntity *)entity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_selectedList count]; i++)
    {
        CuisineContentDataEntity *selEnt = _selectedList[i];
        if (selEnt.id == entity.id)
        {
            index = i;
            break;
        }
    }
    [_selectedList removeObjectAtIndex:index];
}

- (void)addWithCuisineData:(CuisineContentDataEntity *)entity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_selectedList count]; i++)
    {
        CuisineContentDataEntity *selEnt = _selectedList[i];
        if (selEnt.id ==entity.id)
        {
            index = i;
            break;
        }
    }
    if (index == -1)
    {
        [_selectedList addObject:entity];
    }
}

- (void)updateViewData:(id)entity
{
    self.typeEntity = entity;
    _thumalImgView.image = [UIImage imageNamed:_typeEntity.imageName];
    _titleLabel.text = _typeEntity.title;
    
    CGFloat leftSpace = _thumalImgView.left;
    if (kiPhone4 || kiPhone5)
    {
        leftSpace += 10;
    }
    else
    {
        leftSpace += 15;
    }
    CGFloat topSpace = 15;
    if (kiPhone4 || kiPhone5)
    {
        topSpace = 10;
    }
    
    NSInteger col = 3;
    CGFloat width = ([[UIScreen mainScreen] screenWidth] - leftSpace * 2 - topSpace * (col-1)) / col;
    CGRect frame = CGRectMake(leftSpace, __lineTwo.bottom, width, 30);
    NSInteger j = 0;
    for (NSInteger i=0; i<[_typeEntity.content count]; i++)
    {
        CuisineContentDataEntity *ent = _typeEntity.content[i];
        if ((i % col) == 0)
        {
            frame.origin.x = leftSpace;
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
            frame.origin.x = frame.origin.x+width + topSpace;
            j++;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"cuisine_btn_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"cuisine_btn_sel"] forState:UIControlStateSelected];
        NSString *str = [NSString stringWithFormat:@" %@", ent.name];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#323232"] forState:UIControlStateNormal];
        button.titleLabel.font = FONTSIZE_15;
        [button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.borderColor = [UIColor purpleColor].CGColor;
//        button.layer.borderWidth = 1;
        [self addSubview:button];
    }
}

@end



























