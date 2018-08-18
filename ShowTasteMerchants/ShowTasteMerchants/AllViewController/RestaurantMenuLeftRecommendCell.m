//
//  RestaurantMenuLeftRecommendCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuLeftRecommendCell.h"
#import "LocalCommon.h"
#import "RestaurantMenuLeftView.h"
#import "ShopFoodCategoryDataEntity.h"

@interface RestaurantMenuLeftRecommendCell ()
{
    UIImageView *_thumalImgView;
    
    /**
     *  显示数量
     */
    UILabel *_categoryNumLabel;
    
    UILabel *_titleLabel;
    
    CGFloat _cellWidth;
    
}

@property (nonatomic, strong) ShopFoodCategoryDataEntity *categoryEntity;

/**
 *  右边的线
 */
@property (nonatomic, strong) CALayer *rightVerticalLine;

- (void)initWithThumalImgView;

- (void)initWithCategoryNumLabel;

- (void)initWithTitleLabel;

- (void)initWithRightVerticalLine;

@end

@implementation RestaurantMenuLeftRecommendCell

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
    
    [self initWithThumalImgView];
    
    [self initWithCategoryNumLabel];
    
    [self initWithTitleLabel];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongGesture:)];
    longGesture.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:longGesture];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(self.width, 0.8);
    line.left = 0;
    line.bottom = [[self class] getRecommendCellHeight];
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithThumalImgView
{
    // menu_btn_mingchutuijian
    UIImage *image = [UIImage imageNamed:@"menu_btn_mingchutuijian"];
    CGRect frame = CGRectMake(([RestaurantMenuLeftView getMenuLeftViewWidth] - image.size.width)/2, ([[self class] getRecommendCellHeight] - image.size.height)/2 - 10, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    [self.contentView addSubview:_thumalImgView];
}

- (void)initWithCategoryNumLabel
{
    // CGRect frame = CGRectMake(15, (kRestaurantMenuLeftViewCellHeight-20)/2, [RestaurantMenuLeftView getMenuLeftViewWidth] - 30, 20);
    
    if (!_categoryNumLabel)
    {
        CGRect frame = CGRectMake([RestaurantMenuLeftView getMenuLeftViewWidth] - 8 - 14, ([[self class] getRecommendCellHeight]-14)/2, 14, 14);
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

- (void)initWithTitleLabel
{
    CGRect frame = _thumalImgView.frame;
    frame.origin.x = 10;
    frame.origin.y = _thumalImgView.bottom;
    frame.size.height = 20;
    frame.size.width = [RestaurantMenuLeftView getMenuLeftViewWidth] - 20;
    _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_10 labelTag:0 alignment:NSTextAlignmentCenter];
//    _titleLabel.text = @"名厨推荐";
}

- (void)initWithRightVerticalLine
{
    if (!_rightVerticalLine)
    {
        CALayer *line = [CALayer layer];
        line.size = CGSizeMake(4, [[self class] getRecommendCellHeight]);
        line.top = 0;
//        line.right = _cellWidth-1;
        line.left = 0;
        line.backgroundColor = [UIColor colorWithHexString:@"#ff5500"].CGColor;
        [self.layer addSublayer:line];
        self.rightVerticalLine = line;
        _rightVerticalLine.hidden = YES;
    }
}


/**
 *  长按
 *
 *  @param tap tap
 */
- (void)tapLongGesture:(UILongPressGestureRecognizer *)tap
{
//    debugMethod();
    if (self.baseTableViewCellBlock)
    {
        if (tap.state == UIGestureRecognizerStateBegan)
        {
//            debugLog(@"开始");
            self.baseTableViewCellBlock(_categoryEntity);
        }
        else if (tap.state == UIGestureRecognizerStateEnded)
        {
//            debugLog(@"结束");
        }
    }
}


- (void)hiddenWithVerticalLine:(BOOL)hidden
{
    _rightVerticalLine.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity cellWidth:(CGFloat)cellWidth
{
    self.categoryEntity = cellEntity;
    _cellWidth = cellWidth;
    
    [self initWithCategoryNumLabel];
    
    [self initWithRightVerticalLine];
    
    _titleLabel.text = _categoryEntity.name;
}


+ (NSInteger)getRecommendCellHeight
{
    return [RestaurantMenuLeftView getMenuLeftViewWidth] / 1.2;
}

@end
