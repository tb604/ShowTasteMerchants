//
//  WYXCalendarDayCell.m
//  51tour
//
//  Created by 唐斌 on 15/12/31.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "WYXCalendarDayCell.h"
//#import "UIImage+Category.h"
//#import "TYZKit.h"


#define kAnimationDuration 0.15

@interface WYXCalendarDayCell ()


- (void)initWithSubView;

@end

@implementation WYXCalendarDayCell

- (void)dealloc
{
//    NSLog(@"%s", __func__);
#if !__has_feature(objc_arc)
    [_dayLabel release], _dayLabel = nil;
    [_dayTitleLabel release], _dayTitleLabel = nil;
//    [_model release], _model = nil;
    [_backgroundLayer release], _backgroundLayer = nil;
    [super dealloc];
#endif
}

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
    // 日期
    _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, self.bounds.size.width, self.bounds.size.width - 20)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    _dayLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_dayLabel];
    
    // 农历
    _dayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 15, self.bounds.size.width, 13)];
    _dayTitleLabel.textColor = [UIColor lightGrayColor];
    _dayTitleLabel.font = [UIFont boldSystemFontOfSize:10];
    _dayTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dayTitleLabel];
    
    self.backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.fillColor = COLOR_THEME.CGColor;
    [self.contentView.layer insertSublayer:_backgroundLayer atIndex:0];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    CGRect tbounds = _dayLabel.frame;
    _backgroundLayer.frame = CGRectMake(self.bounds.size.width/2-tbounds.size.height/2, tbounds.origin.y, tbounds.size.height, tbounds.size.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
}

- (void)showAnimation
{
    _backgroundLayer.hidden = NO;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
    _backgroundLayer.fillColor = COLOR_THEME.CGColor;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration*3/4;
    
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transfrom.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration*3/4;
    zoomIn.duration = kAnimationDuration/4;
    
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_backgroundLayer addAnimation:group forKey:@"bounce"];
    
    [self configureCell:NO];
}

- (void)hideAnimation
{
    [self configureCell:YES];
}

- (void)configureCell:(BOOL)hidden
{
    _backgroundLayer.fillColor = COLOR_THEME.CGColor;
    _backgroundLayer.hidden = hidden;
    _backgroundLayer.path = [UIBezierPath bezierPathWithOvalInRect:_backgroundLayer.bounds].CGPath;
}

/*
- (void)setModel:(WYXCalendarDayModel *)model
{
#if !__has_feature(objc_arc)
    if (_model != model)
    {
        NSLog(@"_model dfsfd");
        [_model release], _model = nil;
        [model retain];
        _model = model;
    }
#else
    _model = model;
#endif
    
    switch (model.style)
    {
        case CellDayTypeEmpty:
        {// 不显示
            [self AllViewHidden];
        }
            break;
        case CellDayTypePast:
        {// 过去的日期
            [self PartViewShow];
            if (model.holiday)
            {// 如果有节日，就把日期改成节日
                _dayLabel.text = model.holiday;
            }
            else
            {// 显示日期
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
            }
            _dayLabel.textColor = [UIColor lightGrayColor];
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeFutur:
        {// 将来的日期
            [self PartViewShow];
            if (model.holiday)
            {// 节日
                _dayLabel.text = model.holiday;
                _dayLabel.textColor = [UIColor orangeColor];
            }
            else
            {
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
                _dayLabel.textColor = COLOR_THEME;
            }
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeWeek:
        {// 周末
            [self PartViewShow];
            if (model.holiday)
            {
                _dayLabel.text = model.holiday;
                _dayLabel.textColor = [UIColor orangeColor];
            }
            else
            {
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
                _dayLabel.textColor = COLOR_THEME1;
            }
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeClick:
        {// 被点解的日期
            [self PartViewShow];
            _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
            _dayLabel.textColor = [UIColor whiteColor];
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:NO];
        }
            break;
        default:
            [self configureCell:NO];
            break;
    }
    
}*/

- (void)AllViewHidden
{
    _dayLabel.hidden = YES;
    _dayTitleLabel.hidden = YES;
    [self configureCell:YES];
}

- (void)PartViewShow
{
    _dayLabel.hidden = NO;
    _dayTitleLabel.hidden = NO;
}

- (void)updateCalendarData:(id)entity
{
    WYXCalendarDayModel *model = entity;
//    NSLog(@"day=%d; style=%d", model.day, model.style);
    switch (model.style)
    {
        case CellDayTypeEmpty:
        {// 不显示
            [self AllViewHidden];
        }
            break;
        case CellDayTypePast:
        {// 过去的日期
            [self PartViewShow];
            if (model.holiday)
            {// 如果有节日，就把日期改成节日
                _dayLabel.text = model.holiday;
            }
            else
            {// 显示日期
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
            }
            _dayLabel.textColor = [UIColor lightGrayColor];
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeFutur:
        {// 将来的日期
            [self PartViewShow];
            if (model.holiday)
            {// 节日
                _dayLabel.text = model.holiday;
                _dayLabel.textColor = [UIColor orangeColor];
            }
            else
            {
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
                _dayLabel.textColor = COLOR_THEME;
            }
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeWeek:
        {// 周末
            [self PartViewShow];
            if (model.holiday)
            {
                _dayLabel.text = model.holiday;
                _dayLabel.textColor = [UIColor orangeColor];
            }
            else
            {
                _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
                _dayLabel.textColor = COLOR_THEME1;
            }
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:YES];
        }
            break;
        case CellDayTypeClick:
        {// 被点解的日期
//            NSLog(@"电煎锅了");
            [self PartViewShow];
            _dayLabel.text = [NSString stringWithFormat:@"%d", (int)model.day];
            _dayLabel.textColor = [UIColor whiteColor];
            _dayTitleLabel.text = model.chinese_calendar;
            [self configureCell:NO];
        }
            break;
        default:
            [self configureCell:NO];
            break;
    }
}

@end




























