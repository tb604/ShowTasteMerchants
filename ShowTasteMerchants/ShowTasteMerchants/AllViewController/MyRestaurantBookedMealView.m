//
//  MyRestaurantBookedMealView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantBookedMealView.h"
#import "LocalCommon.h"
#import "MyRestaurantBookedRoomView.h"

@interface MyRestaurantBookedMealView ()
{
    UILabel *_meanlLabel;
}
@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) CALayer *verticalLine;

@property (nonatomic, strong) NSMutableArray *mealList;

/**
 *  YES表示能给2整除，NO不能
 */
@property (nonatomic, assign) BOOL isDual;


- (void)initWithVerticalLine;

- (void)initWithMealLabel;

- (void)initWithMealAllView;

@end

@implementation MyRestaurantBookedMealView


- (id)initWithFrame:(CGRect)frame isDual:(BOOL)isDual
{
    _isDual = isDual;
    return [self initWithFrame:frame];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _mealList = [[NSMutableArray alloc] initWithCapacity:0];
    
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLine];
    
    [self initWithVerticalLine];
    
    [self initWithMealLabel];
    
    [self initWithMealAllView];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = self.height;
    line.backgroundColor = [UIColor colorWithHexString:@"#ff5900"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)initWithVerticalLine
{
    NSString *str = @"午餐";
    CGFloat width = [str widthForFont:FONTSIZE_15] + 10;
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, self.height);
    line.left = width;
    line.backgroundColor = [UIColor colorWithHexString:@"#bfbfbf"].CGColor;
    [self.layer addSublayer:line];
    self.verticalLine = line;
}

- (void)initWithMealLabel
{
    CGRect frame = CGRectMake((_verticalLine.left - 30.0) / 2, 15, 30, self.height - 30);
    _meanlLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _meanlLabel.numberOfLines = 0;
//    _meanlLabel.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithMealAllView
{
    CGRect frame = CGRectMake(_verticalLine.right, 0, self.width - _verticalLine.right, kMyRestaurantBookedRoomViewHeight);
    for (NSInteger i=0; i<5; i++)
    {
        frame.origin.y = i * kMyRestaurantBookedRoomViewHeight;
        MyRestaurantBookedRoomView *view = [[MyRestaurantBookedRoomView alloc] initWithFrame:frame];
        if (i % 2 == 0)
        {
            if (_isDual)
            {
                view.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
            }
        }
        else
        {
            if (_isDual)
            {
                view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
            }
            else
            {
                view.backgroundColor = [UIColor whiteColor];
            }
        }
        [view updateViewData:nil];
        [self addSubview:view];
    }
}

- (void)updateWithMealType:(NSString *)meal
{
    _meanlLabel.text = meal;
}

- (void)hiddenWithLine:(BOOL)hidden
{
    _line.hidden = hidden;
}


//+ (CGFloat)getWithViewWidth
//{
//    NSString *str = @"午餐";
//    CGFloat width = [str widthForFont:FONTSIZE_15];
//    return width + 30;
//}

@end


















