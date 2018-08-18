//
//  MyFinanceDayBaseInfoCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyFinanceDayBaseInfoCell.h"
#import "LocalCommon.h"

@interface MyFinanceDayBaseInfoCell ()
{
    UIButton *_btnCalendar;
    // finance_btn_calendar
    
    /**
     *  日期
     */
    UILabel *_dateLabel;
    
    /**
     *  回到当天
     */
    UIButton *_btnToday;
    
    /**
     *  餐厅名字
     */
    UILabel *_shopNameLabel;
    
    /**
     *  ”营业额“
     */
    UILabel *_turnOverTitleLabel;
    
    UIImageView *_thanImgView;
    
    /**
     *  金额
     */
    UILabel *_amountLabel;
}

- (void)initWithBtnCalendar;

- (void)initWithDateLabel;

- (void)initWithBtnToday;

- (void)initWithShopNameLabel;

- (void)initWithTurnOverTitleLabel;

/**
 *  大于号
 */
- (void)initWithThanImgView;

- (void)initWithAmountLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@property (nonatomic, strong) CALayer *line;

@end

@implementation MyFinanceDayBaseInfoCell

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
    
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kMyFinanceDayBaseInfoCellHeight - 55, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e1e1e1"]];
    self.line = line;
    
    
    [self initWithBtnCalendar];
    
    [self initWithDateLabel];
    
    [self initWithBtnToday];
    
    [self initWithShopNameLabel];
    
    [self initWithTurnOverTitleLabel];
    
    [self initWithThanImgView];
    
    [self initWithAmountLabel];
}

- (void)initWithBtnCalendar
{
    if (!_btnCalendar)
    {
        UIImage *image = [UIImage imageNamed:@"finance_btn_calendar"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, 15, image.size.width, image.size.height);
        _btnCalendar = [TYZCreateCommonObject createWithButton:self imgNameNor:@"finance_btn_calendar" imgNameSel:@"finance_btn_calendar" targetSel:@selector(clickedWithCalendar:)];
        _btnCalendar.frame = frame;
        [self.contentView addSubview:_btnCalendar];
    }
}

- (void)initWithDateLabel
{
    if (!_dateLabel)
    {
        CGRect frame = CGRectMake(15, 0, _btnCalendar.left - 15 - 10, 20);
        _dateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _dateLabel.centerY = _btnCalendar.centerY;
    }
    
    _dateLabel.text = @"2016-06-32";
}

- (void)initWithBtnToday
{// 如果不是今天的日期，此按钮显示；如果是今天的日期隐藏
    if (!_btnToday)
    {
        NSString *date = @"2016-32-12";
        float dwidth = [date widthForFont:FONTSIZE_15];
        NSString *str = @"回今天";
        float width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15 + dwidth + 10, 0, width, 30);
        _btnToday = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor colorWithHexString:@"#ff5500"] titleFont:FONTSIZE_15 targetSel:@selector(clickedWithToday:)];
        _btnToday.frame = frame;
        _btnToday.centerY = _dateLabel.centerY;
        [self.contentView addSubview:_btnToday];
    }
}

- (void)initWithShopNameLabel
{
    if (!_shopNameLabel)
    {
        CGRect frame = CGRectMake(15, _btnCalendar.bottom + 16, [[UIScreen mainScreen] screenWidth] - 30, 30);
        _shopNameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE(30) labelTag:0 alignment:NSTextAlignmentLeft];
    }
//    _shopNameLabel.text = @"唐氏集团餐饮";
}

- (void)initWithTurnOverTitleLabel
{
    if (!_turnOverTitleLabel)
    {
        NSString *str = @"营业额(元)";
        CGFloat width = [str widthForFont:FONTSIZE_15];
        CGRect frame = CGRectMake(15, _line.bottom + (55.0-20)/2, width, 20);
        _turnOverTitleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE(15) labelTag:0 alignment:NSTextAlignmentLeft];
        _turnOverTitleLabel.text = str;
    }
}

- (void)initWithThanImgView
{
    if (!_thanImgView)
    {// btn_tiaozhuan
        UIImage *image = [UIImage imageNamed:@"finance_btn_tiao"];
        CGRect frame = CGRectMake([[UIScreen mainScreen] screenWidth] - 15 - image.size.width, 0, image.size.width, image.size.height);
        _thanImgView = [[UIImageView alloc] initWithFrame:frame];
        _thanImgView.image = image;
        [self.contentView addSubview:_thanImgView];
        _thanImgView.centerY = _turnOverTitleLabel.centerY;
    }
}

- (void)initWithAmountLabel
{
    if (!_amountLabel)
    {
        //CGRect frame = CGRectMake(_turnOverTitleLabel.right + 15, 0, [[UIScreen mainScreen] screenWidth] - 15 - 15 - _turnOverTitleLabel.right, 20);
        CGRect frame = CGRectMake(_turnOverTitleLabel.right + 15, 0, _thanImgView.left  - _turnOverTitleLabel.right -20, 36);
        _amountLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTBOLDSIZE(17) labelTag:0 alignment:NSTextAlignmentRight];
        _amountLabel.centerY = _turnOverTitleLabel.centerY;
        // _amountLabel.backgroundColor = [UIColor lightGrayColor];
        
        _amountLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_amountLabel addGestureRecognizer:tap];
    }
//    _amountLabel.text = @"123.90";
}

// 选择日期
- (void)clickedWithToday:(id)sender
{
    if (self.todayWithDateBlock)
    {
        self.todayWithDateBlock();
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_touchTurnoverBlock)
    {
        _touchTurnoverBlock();
    }
}

- (void)updateCellData:(id)cellEntity
{
    MyFinanceTodayDataEntity *todayEnt = cellEntity;
    //
    _dateLabel.text = todayEnt.todayDate;
    
    // 餐厅名称
    _shopNameLabel.text = todayEnt.shop_name;
    
    // 金额
    _amountLabel.text = [NSString stringWithFormat:@"%.2f", todayEnt.total_amount];
    
    NSDate *date = [NSDate date];
    NSString *strDate = [date stringWithFormat:@"yyyy-MM-dd"];
    if ([strDate isEqualToString:todayEnt.todayDate])
    {
        _btnToday.hidden = YES;
    }
    else
    {
        _btnToday.hidden = NO;
    }
}

- (void)clickedWithCalendar:(id)sender
{
    if (self.choiceWithDateBlock)
    {
        self.choiceWithDateBlock();
    }
}

@end














