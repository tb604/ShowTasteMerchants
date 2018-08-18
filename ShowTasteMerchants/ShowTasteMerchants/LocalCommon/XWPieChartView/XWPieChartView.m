//
//  XWPieChartView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "XWPieChartView.h"
#import "LocalCommon.h"
//#import "ZJPieChartView.h"

@interface XWPieChartView ()

@property (nonatomic, strong) UIView *pieChartView;

@property (nonatomic, strong) NSArray *pieChartList;

- (void)initWithPieChartView;

@end

@implementation XWPieChartView

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
    
    [self initWithPieChartView];
}

- (void)initWithPieChartView
{
    if (!_pieChartView)
    {
        
    }
}

- (void)updateViewData:(id)entity
{
    self.pieChartList = entity;
    
}

@end


























