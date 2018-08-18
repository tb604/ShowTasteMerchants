
//
//  RestaurantMenuLeftViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuLeftViewCell.h"
#import "LocalCommon.h"
#import "ShopFoodCategoryDataEntity.h"
#import "RestaurantMenuLeftView.h"

@interface RestaurantMenuLeftViewCell ()
{
    CGFloat _cellWidth;
    
    /**
     *  显示数量
     */
    UILabel *_categoryNumLabel;
    
    UILabel *_titleLabel;
}

@property (nonatomic, strong) ShopFoodCategoryDataEntity *categoryEntity;

/**
 *  右边的线
 */
@property (nonatomic, strong) CALayer *rightVerticalLine;

- (void)initWithRightVerticalLine;

- (void)initWithCategoryNumLabel;

- (void)initWithTitleLabel;

@end

@implementation RestaurantMenuLeftViewCell

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
    
    [self initWithLine];
    
    [self initWithCategoryNumLabel];
    
    [self initWithTitleLabel];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longGesture];
    
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.5);
    line.left = 0;
    line.bottom = kRestaurantMenuLeftViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithCategoryNumLabel
{
    // CGRect frame = CGRectMake(15, (kRestaurantMenuLeftViewCellHeight-20)/2, [RestaurantMenuLeftView getMenuLeftViewWidth] - 30, 20);
    
    if (!_categoryNumLabel)
    {
        CGRect frame = CGRectMake([RestaurantMenuLeftView getMenuLeftViewWidth] - 8 - 14, (kRestaurantMenuLeftViewCellHeight-14)/2, 14, 14);
        _categoryNumLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ffffff"] fontSize:FONTBOLDSIZE_9 labelTag:0 alignment:NSTextAlignmentCenter];
        _categoryNumLabel.layer.cornerRadius = frame.size.width / 2;
        _categoryNumLabel.layer.masksToBounds = YES;
//        _categoryNumLabel.text = @"13";
        _categoryNumLabel.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    }
    
    _categoryNumLabel.hidden = YES;
    if (_categoryEntity.selectNum != 0)
    {
        _categoryNumLabel.hidden = NO;
        _categoryNumLabel.text = [NSString stringWithFormat:@"%d", (int)_categoryEntity.selectNum];
    }
    
}

- (void)initWithRightVerticalLine
{
    if (!_rightVerticalLine)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake(4, kRestaurantMenuLeftViewCellHeight);
        line.top = 0;
//        line.right = _cellWidth-1;
        line.left = 0;
        line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        [self.layer addSublayer:line];
        self.rightVerticalLine = line;
        _rightVerticalLine.hidden = YES;
    }
}

- (void)initWithTitleLabel
{
    if (!_titleLabel)
    {// RestaurantMenuLeftView
//        CGRect frame = CGRectMake(10, (kRestaurantMenuLeftViewCellHeight-20)/2, [RestaurantMenuLeftView getMenuLeftViewWidth] - 10 - 20 - 10 - 2, 20);
        CGRect frame = CGRectMake(10, (kRestaurantMenuLeftViewCellHeight-20)/2, _categoryNumLabel.left - 10 - 2, 20);
        _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTBOLDSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
//        _titleLabel.backgroundColor = [UIColor purpleColor];
    }
}

- (void)hiddenWithVerticalLine:(BOOL)hidden
{
    _rightVerticalLine.hidden = hidden;
}

/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
    if (self.baseTableViewCellBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
            //            debugLog(@"开始");
            self.baseTableViewCellBlock(nil);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
//            debugLog(@"结束");
        }
    }
}


- (void)updateCellData:(id)cellEntity cellWidth:(CGFloat)cellWidth
{
    self.categoryEntity = cellEntity;
    _cellWidth = cellWidth;
//    debugLog(@"width=%.2f", _cellWidth);
    [self initWithRightVerticalLine];
    
    [self initWithCategoryNumLabel];
    
    [self initWithTitleLabel];
    
    _titleLabel.text = _categoryEntity.name;
}


@end
