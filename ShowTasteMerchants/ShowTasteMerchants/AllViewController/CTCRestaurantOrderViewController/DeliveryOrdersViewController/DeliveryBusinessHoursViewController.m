//
//  DeliveryBusinessHoursViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryBusinessHoursViewController.h"
#import "LocalCommon.h"
#import "DeliveryBusinessThroughoutDayCell.h"
#import "CellCommonDataEntity.h"
#import "DeliveryBusinessAddHoursCell.h"
#import "DeliveryBusinessHoursCell.h"
#import "DeliveryBusinessChoiceHoursView.h"

@interface DeliveryBusinessHoursViewController ()
{
    DeliveryBusinessChoiceHoursView *_choiceTimeView;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation DeliveryBusinessHoursViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)initWithVar
{
    [super initWithVar];
    
    NSMutableArray *addList = [NSMutableArray new];
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"24小时营业";
    ent.isCheck = YES;
    [addList addObject:ent];
    [self.baseList addObject:addList];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"营业时间";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


/**
 *  是否24小时营业
 */
- (void)throughoutDay:(CellCommonDataEntity *)entity
{
    if (entity.isCheck)
    {
        NSInteger count = self.baseList.count;
        if (count == 2)
        {
            [self.baseList removeLastObject];
        }
    }
    else
    {
        NSMutableArray *addList = [NSMutableArray new];
        CellCommonDataEntity *ent = [CellCommonDataEntity new];
        ent.title = @"09:00";
        ent.subTitle = @"21:00";
        [addList addObject:ent];
        [self.baseList addObject:addList];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:2];
}

/**
 *  更新时间
 *  @pram entity ent
 *  @param type 1表示开始时间；2表示结束时间
 */
- (void)updateWithTime:(CellCommonDataEntity *)entity type:(int)type
{
    debugLog(@"type=%d", type);
    
    NSString *time = nil;
    if (type == 1)
    {
        time = entity.title;
        if ([objectNull(time) isEqualToString:@""])
        {
            time = @"09:00";
        }
    }
    else
    {
        time = entity.subTitle;
        if ([objectNull(time) isEqualToString:@""])
        {
            time = @"21:00";
        }
    }
    
    [self showChoiceTimeView:YES time:time type:type completion:^(NSString *time) {
        
        [self editWithTime:time type:type];
    }];
    
}

/**
 *
 *  @param time 时间
 *  @param type 1表示开始时间；2表示结束时间
 */
- (void)editWithTime:(NSString *)time type:(int)type
{
    if (!time)
    {
        [self showChoiceTimeView:NO time:nil type:type completion:nil];
        return;
    }
    NSArray *array = [self.baseList objectOrNilAtIndex:1];
    CellCommonDataEntity *ent = [array objectOrNilAtIndex:_indexPath.row];
    if (type == 1)
    {
        ent.title = objectNull(time);
    }
    else
    {
        ent.subTitle = objectNull(time);
    }
    [self showChoiceTimeView:NO time:nil type:type completion:nil];
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}

/**
 *
 * @param type 1表示开始时间；2表示结束时间
 */
- (void)showChoiceTimeView:(BOOL)show time:(NSString *)time type:(int)type completion:(void(^)(NSString *time))completion
{
    if (!_choiceTimeView)
    {
        _choiceTimeView = [[DeliveryBusinessChoiceHoursView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _choiceTimeView.alpha = 0;
    }
    _choiceTimeView.choiceTimeBlock = completion;
    
    if (show)
    {
        [self.view.window addSubview:_choiceTimeView];
        NSArray *array = [time componentsSeparatedByString:@":"];
        NSString *hour = [array objectOrNilAtIndex:0];
        NSString *minute = [array objectOrNilAtIndex:1];
        
        [_choiceTimeView updateCurrentTimeHour:hour minite:minute type:type];
        
        [UIView animateWithDuration:0.5 animations:^{
            _choiceTimeView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _choiceTimeView.alpha = 0;
        } completion:^(BOOL finished) {
            [_choiceTimeView removeFromSuperview];
        }];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = self.baseList.count;
    count = (count==1?2:count);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.baseList objectOrNilAtIndex:section];
    if (section == 0)
    {
        return [array count];
    }
    if (!array)
    {
        return 0;
    }
    return [array count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0)
    {
        DeliveryBusinessThroughoutDayCell *cell = [DeliveryBusinessThroughoutDayCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.section][indexPath.row]];
        cell.baseTableViewCellBlock = ^(id data)
        {// 是否24小时营业
            [weakSelf throughoutDay:data];
        };
        return cell;
    }
    else if (indexPath.section == 1)
    {
        NSArray *array = [self.baseList objectOrNilAtIndex:1];
        if (array.count == indexPath.row)
        {// 添加营业时间
            DeliveryBusinessAddHoursCell *cell = [DeliveryBusinessAddHoursCell cellForTableView:tableView];
            return cell;
        }
        else
        {
            DeliveryBusinessHoursCell *cell = [DeliveryBusinessHoursCell cellForTableView:tableView];
            [cell updateCellData:array[indexPath.row]];
            // type 1表示开始时间；2表示结束时间
            cell.uploadTimeBlock = ^(id data, int type)
            {
                weakSelf.indexPath = indexPath;
                [weakSelf updateWithTime:data type:type];
            };
            return cell;
        }
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kDeliveryBusinessThroughoutDayCellHeight;
    }
    return kDeliveryBusinessThroughoutDayCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 15;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
//        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(10, 0, view.width - 20, view.height) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"自定义营业时间";
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSMutableArray *array = [self.baseList objectAtIndex:1];
        if (array && indexPath.row != array.count)
        {
            if (editingStyle == UITableViewCellEditingStyleDelete)
            {
                [array removeObjectAtIndex:indexPath.row];
                [self.baseTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSArray *array = [self.baseList objectAtIndex:1];
        if (array && indexPath.row != array.count)
        {
            return YES;
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        NSArray *array = [self.baseList objectOrNilAtIndex:1];
        if (array && [array count] == indexPath.row)
        {
            debugLog(@"添加");
            CellCommonDataEntity *ent = [CellCommonDataEntity new];
            ent.title = @"";
            ent.subTitle = @"";
            [self.baseList[indexPath.section] addObject:ent];
            [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
        }
    }
}

@end




















