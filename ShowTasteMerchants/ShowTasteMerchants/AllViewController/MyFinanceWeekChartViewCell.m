//
//  MyFinanceWeekChartViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceWeekChartViewCell.h"
#import "LocalCommon.h"
#import "MPGraphView.h"
#import "MPPlot.h"
#import "MPBarsGraphView.h"
#import "MyFinanceMonthEarningTitleView.h"

@interface MyFinanceWeekChartViewCell ()
{
    UIScrollView *_contentView;
    
    MPGraphView *_monthGraphView;
    
    MyFinanceMonthEarningTitleView *_monthGraphTitleView;
}

@property (nonatomic, strong) NSArray *list;

- (void)initWithContentView;

- (void)initWithMonthGraphView;

- (void)initWithMonthGraphTitleView;
@end

@implementation MyFinanceWeekChartViewCell

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
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [CALayer drawLine:self.contentView frame:CGRectMake(0, kMyFinanceWeekChartViewCellHeight, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#cacaca"]];
    
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        float width = [[UIScreen mainScreen] screenWidth];//[_list count] * fwidth + ([_list count] + 1) * 15;
        width = (width>[[UIScreen mainScreen] screenWidth]?width:[[UIScreen mainScreen] screenWidth]);
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kMyFinanceWeekChartViewCellHeight);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_contentView];
        _contentView.contentSize = CGSizeMake(width, _contentView.height);
    }
}

- (void)initWithMonthGraphView
{
    if (!_monthGraphView)
    {
        NSMutableArray *list = [NSMutableArray array];
        for (MyFinanceMonthEntity *ent in _list)
        {
            [list addObject:@(ent.value)];
        }
        CGRect frame = CGRectMake(0, 10, _contentView.contentSize.width, kMyFinanceWeekChartViewCellHeight - 10 - 30);
        _monthGraphView = [[MPGraphView alloc] initWithFrame:frame];
        _monthGraphView.waitToUpdate = NO;
        _monthGraphView.values = list;
        
//        _monthGraphView.fillColors = @[[UIColor colorWithHexString:@"#fdebdc"],[UIColor colorWithHexString:@"ff9b66"]];
        _monthGraphView.graphColor = [UIColor colorWithHexString:@"#ff5500"];
        _monthGraphView.detailBackgroundColor = [UIColor colorWithHexString:@"#fdebdc"];
        _monthGraphView.curved = NO;
        [_contentView addSubview:_monthGraphView];
    }
}

- (void)initWithMonthGraphTitleView
{
    if (!_monthGraphTitleView)
    {
        CGRect frame = _monthGraphView.frame;
        frame.size.height = kMyFinanceMonthEarningTitleViewHeight;
        frame.origin.y = _monthGraphView.bottom;
        _monthGraphTitleView = [[MyFinanceMonthEarningTitleView alloc] initWithFrame:frame];
        [_contentView addSubview:_monthGraphTitleView];
    }
    
    [_monthGraphTitleView removeAllSubviews];
    float width = _monthGraphTitleView.width / [_list count];
    CGRect frame = CGRectMake(0, 0, width, kMyFinanceMonthEarningTitleViewHeight);
    for (NSInteger i=0; i<[_list count]; i++)
    {
        MyFinanceMonthEntity *ent = _list[i];
        frame.origin.x = i * width;
        UILabel *label = [TYZCreateCommonObject createWithLabel:_monthGraphTitleView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
        label.text = ent.title;
        //        if (i % 2 == 0)
        //        {
        //            label.backgroundColor = [UIColor orangeColor];
        //        }
        //        else
        //        {
        //            label.backgroundColor = [UIColor purpleColor];
        //        }
    }
    
    
}

- (void)updateCellData:(id)cellEntity
{
    self.list = cellEntity;

    [self initWithContentView];

    [self initWithMonthGraphView];

    [self initWithMonthGraphTitleView];
}



@end




















