//
//  WYXCalendarViewController.m
//  51tour
//
//  Created by 唐斌 on 15/12/31.
//  Copyright © 2015年 51tour. All rights reserved.
//

#import "WYXCalendarViewController.h"
#import "WYXCalendarMonthCollectionViewLayout.h"
#import "WYXCalendarMonthHeaderView.h"
#import "WYXCalendarDayCell.h"
#import "NSDate+WYXCalendarLogic.h"
#import "WYXCalendarDayModel.h"
#import "WYXCalendarLogic.h"

@interface WYXCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _day;
    /**
     *  是否可以多选
     */
    BOOL _multChoice;
}
@property (nonatomic, strong) NSTimer *_timer;

@property (nonatomic, copy, nullable) NSString *selectDate;

/**
 *  多选的日期
 */
@property (nonatomic, strong) NSMutableArray *multSelectedDates;

- (void)initWithVar;

- (void)initWithSubView;

@end

@implementation WYXCalendarViewController

//static NSString *MonthHeader = @"MonthHeaderView";
//
//static NSString *DayCell = @"DayCell";

- (void)dealloc
{
//    NSLog(@"%s", __func__);
#if !__has_feature(objc_arc)
    [_collectionView release], _collectionView = nil;
    [_calendarMonth release], _calendarMonth = nil;
    [_calendarBlock release], _calendarBlock = nil;
    [_logic release], _logic = nil;
    [_selectDate release], _selectDate = nil;
    [_multSelectedDates release], _multSelectedDates = nil;
    [_logic release], _logic = nil;
    [super dealloc];
#endif
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil day:30 selectDate:nil multChoice:NO];
}

/**
 *  初始化
 *
 *  @param nibNameOrNil
 *  @param nibBundleOrNil
 *  @param day            天数
 *  @param selectDate     选择的日期
 *
 *  @return id
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil day:(NSInteger)day selectDate:(NSString *)selectDate multChoice:(BOOL)multChoice
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _day = day;
        _selectDate = [selectDate copy];
        _multChoice = multChoice;
        [self initWithVar];
        
        [self initWithSubView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)initWithVar
{
    _multSelectedDates = [[NSMutableArray alloc] initWithCapacity:0];
    
    _calendarMonth = [[NSMutableArray alloc] initWithCapacity:0];
    NSDate *date = [NSDate date];
    if (!_selectDate)
    {
        self.selectDate = [NSDate stringFromDateS:date];
    }
    _logic = [[WYXCalendarLogic alloc] initWithMultChoice:_multChoice];
    NSArray *array = [_logic reloadCalendarView:date selectDate:[NSDate dateFromStringS:_selectDate] needDays:_day];
    [_calendarMonth addObjectsFromArray:array];    
}

- (void)initWithSubView
{
    // 返回按钮
    [self initWithBackButton];
    
    WYXCalendarMonthCollectionViewLayout *layout = [[WYXCalendarMonthCollectionViewLayout alloc] init];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    // cell重用设置id
    [_collectionView registerClass:[WYXCalendarDayCell class] forCellWithReuseIdentifier:NSStringFromClass([WYXCalendarDayCell class])];
    
    [_collectionView registerClass:[WYXCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WYXCalendarMonthHeaderView class])];
    // 关闭下拉效果
//    _collectionView.bounces = NO;
    
#if !__has_feature(objc_arc)
    [layout release], layout = nil;
#endif
}


- (void)initWithBackButton
{
    UIImage *image = [UIImage imageNamed:@"nav_btn_back_nor"];
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    //    btnBack.backgroundColor = [UIColor orangeColor];
    [btnBack setImage:image forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"nav_btn_back_nor"] forState:UIControlStateSelected];
    [btnBack setImage:[UIImage imageNamed:@"nav_btn_back_nor"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(clickedBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    self.navigationItem.leftBarButtonItem = itemBack;
    //    NSLog(@"frame=%@", NSStringFromCGRect(itemBack.customView.frame));
#if !__has_feature(objc_arc)
    [itemBack release], itemBack = nil;
#endif
}

- (void)clickedBack:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (_calendarBlock)
    {
        if (_multChoice)
        {
            NSInteger count = [_multSelectedDates count];
            if (count == 1)
            {
                WYXCalendarDayModel *model = _multSelectedDates[0];
                [_multSelectedDates addObject:model];
            }
        }
        _calendarBlock(_multSelectedDates);
    }
    
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark start ICollectionViewDataSource, UICollectionViewDelegate
// 定义战士的section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger section = [_calendarMonth count];
    return section;
}

// 定义战士的UICollecionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = [_calendarMonth[section] count];
    return row;
}

// 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYXCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WYXCalendarDayCell class]) forIndexPath:indexPath];
    WYXCalendarDayModel *model = _calendarMonth[indexPath.section][indexPath.row];
    [cell updateCalendarData:model];
    return cell;
}

- (UICollectionReusableView * )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s", __func__);
    UICollectionReusableView *reusableview = [UICollectionReusableView new];
    if (kind == UICollectionElementKindSectionHeader)
    {
        NSMutableArray *month_Array = [_calendarMonth objectAtIndex:indexPath.section];
        WYXCalendarDayModel *model = [month_Array objectAtIndex:15];
        WYXCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([WYXCalendarMonthHeaderView class]) forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%d年 %d月",(int)model.year,(int)model.month];//@"日期";
        return monthHeader;
    }
    return reusableview;
}

// UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYXCalendarDayModel *model = _calendarMonth[indexPath.section][indexPath.row];
    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek || model.style == CellDayTypeClick)
    {// 将来的日期, 周末, 被点击的日期
//        [_logic selectLogic:model];
        [self insertSelectList:model];
    }
    if (model.style == CellDayTypePast)
    {
        return;
    }
    
    [_collectionView reloadData];
    
    if (!_multChoice)
    {
        [self clickedBack:nil];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark end ICollectionViewDataSource, UICollectionViewDelegate

- (void)insertSelectList:(WYXCalendarDayModel *)model
{
    /*for (WYXCalendarDayModel *day in _multSelectedDates)
    {
        if ([day.date compare:model.date] == NSOrderedSame)
        {
            return;
        }
    }*/
    
    model.style = CellDayTypeClick;
    if (_multChoice)
    {
        NSInteger count = [_multSelectedDates count];
//        NSLog(@"count=%d", (int)count);
        if (count == 0)
        {
            [_multSelectedDates addObject:model];
            return;
        }
        else if (count == 1)
        {
            WYXCalendarDayModel *firstModel = _multSelectedDates[0];
            
            // -1, 0, 1
            // firstModel的日期小于model为-1；相等为0；大于为1
            NSComparisonResult result = [firstModel.date compare:model.date];
            if (result == NSOrderedAscending)
            {// -1
                [_multSelectedDates addObject:model];
            }
            else if (result == NSOrderedDescending)
            {// 1
                [_multSelectedDates insertObject:model atIndex:0];
            }
            else
            {
                NSLog(@"只有一个");
                [_logic unSelectLogic:model];
                [_multSelectedDates removeAllObjects];
                return;
            }
        }
        else
        {
            WYXCalendarDayModel *firstModel = _multSelectedDates[0];
            WYXCalendarDayModel *secondModel = _multSelectedDates[1];
            int daynum = (int)[NSDate getDayNumbertoDay:firstModel.date beforDay:secondModel.date] + 1;
            NSLog(@"daynum=%d", daynum);
            NSComparisonResult result = [firstModel.date compare:model.date];
            if (result == NSOrderedDescending)
            {// 1 firstModel的日期大于model的日期
//                NSLog(@"if");
                [_multSelectedDates removeObject:firstModel];
                [_multSelectedDates insertObject:model atIndex:0];
            }
            else if (result == NSOrderedSame && daynum == 2)
            {
//                NSLog(@"else if");
                WYXCalendarDayModel *mod = _multSelectedDates[1];
                [_logic unSelectLogic:mod];
                [_multSelectedDates removeObjectAtIndex:1];
                
                return;
            }
            else
            {
//                NSLog(@"else");
                [_multSelectedDates removeObject:secondModel];
                if ([firstModel.date compare:model.date] != NSOrderedSame)
                {
                    [_multSelectedDates addObject:model];
                }
            }
        }
        
        count = [_multSelectedDates count];
        WYXCalendarDayModel *firstModel = _multSelectedDates[0];
        WYXCalendarDayModel *secondModel = nil;
        if (count == 2)
        {
           secondModel = _multSelectedDates[1];
        }
        for (NSArray *days in _calendarMonth)
        {
            for (WYXCalendarDayModel *day in days)
            {
                if (day.style == CellDayTypeEmpty)
                {
                    continue;
                }
                NSComparisonResult fresult = [firstModel.date compare:day.date];
                NSComparisonResult sresult = -2;
                if (count == 2)
                {
                    sresult = [secondModel.date compare:day.date];
                }
                if (fresult == NSOrderedAscending && sresult == NSOrderedDescending && count==2)
                {
                    [_logic selectLogic:day];
                }
                else if (fresult == NSOrderedSame || sresult == NSOrderedSame)
                {
                    [_logic selectLogic:day];
                }
                else
                {
                    if (day.style == CellDayTypeClick)
                    {
                        [_logic unSelectLogic:day];
                    }
                }
            }
        }
    }
    else
    {
        [_multSelectedDates removeAllObjects];
        [_multSelectedDates addObject:model];
    }
    
}

@end





























