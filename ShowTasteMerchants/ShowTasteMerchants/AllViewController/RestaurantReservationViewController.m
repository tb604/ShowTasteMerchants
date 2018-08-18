//
//  RestaurantReservationViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantReservationViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "ORestCommonSingleCell.h"
#import "RestaurantReservationNoteCell.h"
#import "RestaurantReservationFooterView.h"
#import "RestaurantReservationInputEntity.h"
#import "UserLoginStateObject.h"
#import "OrderDataEntity.h" // 订单
#import "TYZTimeChoiceView.h" // 选择时间段
#import "WYXCalendarDayModel.h"
#import "ChoiceShopLocationView.h" // 选择餐厅位置视图
#import "ShopSeatInfoEntity.h"

@interface RestaurantReservationViewController ()
{
    CGFloat _titleWidth;
    
    RestaurantReservationFooterView *_footerView;
    
    /**
     *  选择时间视图
     */
    TYZTimeChoiceView *_timeView;
    
    /**
     *  选择餐厅位置视图
     */
    ChoiceShopLocationView *_locationView;
    
}

/**
 *  传入参数
 */
//@property (nonatomic, strong) RestaurantReservationInputEntity *inputEntity;

/**
 *  订单
 */
//@property (nonatomic, strong) OrderDataEntity *orderEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithFooterView;

@end

@implementation RestaurantReservationViewController

- (void)initWithVar
{
    [super initWithVar];
    
    NSString *str = @"预订日前去";
    _titleWidth = [str widthForFont:FONTSIZE_12 height:20];
    
    ShopSeatInfoEntity *ent = [_seatLocList objectOrNilAtIndex:0];
    _inputEntity.shopLocation = ent.id;
    _inputEntity.shopLocationNote = ent.name;
    
//    _inputEntity = [RestaurantReservationInputEntity new];
//    _inputEntity.userId = [UserLoginStateObject getUserId];
    /*if (_orderEntity)
    {
        _inputEntity.shopId = _orderEntity.shop_id;
        NSArray *list = [_orderEntity.dining_date componentsSeparatedByString:@" "];
        _inputEntity.dueDate = objectNull([list objectOrNilAtIndex:0]);
        _inputEntity.arriveShopTime = objectNull([list objectOrNilAtIndex:1]);
        _inputEntity.number = _orderEntity.number;
        if ([objectNull(_orderEntity.seat_type) isEqualToString:@""])
        {
            _inputEntity.shopLocation = -1;
            _inputEntity.shopLocationNote = @"请选择餐厅位置";
        }
        else
        {
            _inputEntity.shopLocation = [_orderEntity.seat_type integerValue];
            // 0大厅；1包间；2走廊
            if (_inputEntity.shopLocation == 0)
            {
                _inputEntity.shopLocationNote = @"大厅";
            }
            else if (_inputEntity.shopLocation == 1)
            {
                _inputEntity.shopLocationNote = @"包间";
            }
            else if (_inputEntity.shopLocation == 2)
            {
                _inputEntity.shopLocationNote = @"走廊";
            }
        }
    }
    else if (_shopEntity)
    {
        NSDate *date = [NSDate date];
        _inputEntity.shopId = _shopEntity.shopId;
        _inputEntity.dueDate = [date stringWithFormat:@"yyyy-MM-dd"];
        _inputEntity.arriveShopTime = [date stringWithFormat:@"HH:mm"];
        _inputEntity.number = 0;
        _inputEntity.shopLocation = 1;
        _inputEntity.shopLocationNote = @"包间";
    }
    else
    {
        NSDate *date = [NSDate date];
        _inputEntity.shopId = _shopId;
        _inputEntity.dueDate = [date stringWithFormat:@"yyyy-MM-dd"];
        _inputEntity.arriveShopTime = [date stringWithFormat:@"HH:mm"];
        _inputEntity.number = 0;
        _inputEntity.shopLocation = 1;
        _inputEntity.shopLocationNote = @"包间";
    }*/
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"预订餐厅";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    [self initWithFooterView];
}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kRestaurantReservationFooterViewHeight);
    _footerView = [[RestaurantReservationFooterView alloc] initWithFrame:frame];
    self.baseTableView.tableFooterView = _footerView;
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedWithReservation:data];
    };
}

- (void)showChoiceTimeView:(BOOL)show
{
    if (!_timeView)
    {
        _timeView = [[TYZTimeChoiceView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _timeView.alpha = 0;
    }
    __weak typeof(self)blockSelf = self;
    _timeView.pickupTimeBlock = ^(NSString *time)
    {
        [blockSelf updatePickupTime:time];
    };
    
    if (show)
    {
        [self.view.window addSubview:_timeView];
        
        NSString *hour = nil;
        NSString *minute = nil;
//        NSRange range = [_inputEntity.arriveShopTime rangeOfString:@":"];
//        debugLog(@"length=%d;location=%d", range.length, range.location);
        if ([_inputEntity.arriveShopTime rangeOfString:@":"].length != 0)
        {
            NSArray *array = [_inputEntity.arriveShopTime componentsSeparatedByString:@":"];
            hour = [NSString stringWithFormat:@"%@点", [array objectOrNilAtIndex:0]];
            minute = [NSString stringWithFormat:@"%@分", [array objectOrNilAtIndex:1]];
        }
        
        [_timeView updateCurrentTimeHour:hour minite:minute];
        
        [UIView animateWithDuration:0.5 animations:^{
            _timeView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _timeView.alpha = 0;
        } completion:^(BOOL finished) {
            [_timeView removeFromSuperview];
        }];
    }
}

- (void)updatePickupTime:(NSString *)time
{
    [self showChoiceTimeView:NO];
    if (time)
    {
        _inputEntity.arriveShopTime = time;
        
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
}

/**
 *  实现餐厅位置选择视图
 *
 *  @param show isShow description
 */
- (void)showWithLocationView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_locationView)
    {
//        NSArray *list = @[@"大厅", @"包间", @"走廊"];
        _locationView = [[ChoiceShopLocationView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]) locationList:_seatLocList];
        _locationView.alpha = 0;
    }
    _locationView.choiceShopLocationBlock = ^(id data)
    {
        
        // ShopSeatInfoEntity
        // 餐厅位置。0大厅；1包间；2走廊
        if (data)
        {
            ShopSeatInfoEntity *ent = data;
            weakSelf.inputEntity.shopLocationNote = ent.name;
            weakSelf.inputEntity.shopLocation = ent.id;
            [weakSelf.baseTableView reloadData];
        }
        [weakSelf showWithLocationView:NO];
    };
    if (show)
    {
        [self.view.window addSubview:_locationView];
        ShopSeatInfoEntity *ent = nil;
        for (ShopSeatInfoEntity *entit in _seatLocList)
        {
            if (_inputEntity.shopLocation == entit.id)
            {
                ent = entit;
                break;
            }
        }
        [_locationView updateWithLocation:ent];
        [UIView animateWithDuration:0.5 animations:^{
            _locationView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _locationView.alpha = 0;
        } completion:^(BOOL finished) {
            [_locationView removeFromSuperview];
        }];
    }
}


// 预订
- (void)clickedWithReservation:(id)data
{
    if ([objectNull(_inputEntity.dueDate) isEqualToString:@"请选择预订日期"])
    {
        [SVProgressHUD showErrorWithStatus:_inputEntity.dueDate];
        return;
    }
    if ([objectNull(_inputEntity.arriveShopTime) isEqualToString:@"请选择到店时段"])
    {
        [SVProgressHUD showErrorWithStatus:_inputEntity.arriveShopTime];
        return;
    }
    if (_inputEntity.number == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入就餐人数"];
        return;
    }
    if (_inputEntity.shopLocation == -1)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择餐厅位置"];
        return;
    }
    
    // 【 订单状态 1 待商家确认；2 已创建预订；3 待支付订金； 4 已完成预订；101 待下单； 102 就餐中； 103 结账中； 104  支付完成； 200 订单已完成； 300 订单已取消； 400 商家已拒绝   】
    
    // 食客获取菜谱，显示菜谱视图控制器
    [MCYPushViewController showWithRecipeVC:self data:_inputEntity completion:^(id data) {
        
    }];    
}

- (NSAttributedString *)attributedWithString:(NSString *)value color:(UIColor *)color font:(UIFont *)font
{
    NSAttributedString *attValue =  [[NSAttributedString alloc] initWithString:objectNull(value) attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
    return attValue;
}

- (UITableViewCell *)reservationWithTableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor *color = nil;
    NSAttributedString *title = nil;
    NSAttributedString *value = nil;
    
    switch (indexPath.row)
    {
        case EN_SHOP_RESERVATION_INFO_DATE_ROW:// 预订日期
        {
            color = [UIColor colorWithHexString:@"#999999"];
            title = [self attributedWithString:@"预订日期" color:color font:FONTSIZE(13)];
            color = [UIColor colorWithHexString:@"#1a1a1a"];
            value = [self attributedWithString:objectNull(_inputEntity.dueDate) color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentRight];
            return cell;
        } break;
        case EN_SHOP_RESERVATION_INFO_TIME_ROW: // 到店时段
        {
            color = [UIColor colorWithHexString:@"#999999"];
            title = [self attributedWithString:@"到店时段" color:color font:FONTSIZE(13)];
            color = [UIColor colorWithHexString:@"#1a1a1a"];
            value = [self attributedWithString:objectNull(_inputEntity.arriveShopTime) color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentRight];
            return cell;
        } break;
        case EN_SHOP_RESERVATION_INFO_NUMBER_ROW: // 就餐人数
        {
            color = [UIColor colorWithHexString:@"#999999"];
            title = [self attributedWithString:@"就餐人数" color:color font:FONTSIZE(13)];
            color = [UIColor colorWithHexString:@"#1a1a1a"];
            value = [self attributedWithString:[NSString stringWithFormat:@"%d", (int)_inputEntity.number] color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentRight];
            return cell;
        } break;
        case EN_SHOP_RESERVATION_INFO_LOCATION_ROW: // 餐厅位置
        {
            color = [UIColor colorWithHexString:@"#999999"];
            title = [self attributedWithString:@"餐厅位置" color:color font:FONTSIZE(13)];
            color = [UIColor colorWithHexString:@"#1a1a1a"];
            NSString *str = @"";
            // 0大厅；1包间；2走廊
            if (_inputEntity.shopLocation == 0)
            {
                str = @"大厅";
            }
            else if (_inputEntity.shopLocation == 1)
            {
                str = @"包间";
            }
            else if (_inputEntity.shopLocation == 2)
            {
                str = @"走廊";
            }
            else
            {
                str = _inputEntity.shopLocationNote;
            }
            value = [self attributedWithString:str color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentRight];
            return cell;
        } break;
        default:
            break;
    }
    
    return nil;
}

- (void)textViewEdit:(NSInteger)type
{
    if (type == 1)
    {// 编辑开始
        if (kiPhone4)
        {
            self.baseTableView.contentOffset = CGPointMake(0, 150);
        }
    }
    else if (type == 2)
    {// 编辑结束
        if (kiPhone4)
        {
            self.baseTableView.contentOffset = CGPointMake(0, 0);
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:NULL];
    //    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    debugMethod();
    if (!decelerate)
    {
        //        debugLog(@"dfdfd");
        //        if (_fpsLabel.alpha != 0)
        //        {
        //            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //                _fpsLabel.alpha = 0;
        //            } completion:NULL];
        //        }
        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    debugMethod();
    [self.view endEditing:YES];
    //    if (_fpsLabel.alpha != 0)
    //    {
    //        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 0;
    //        } completion:NULL];
    //    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    //    debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:^(BOOL finished) {
    //        }];
    //    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_SHOP_RESERVATION_MAX_SESTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == EN_SHOP_RESERVATION_INFO_SECTION)
    {
        count = EN_SHOP_RESERVATION_INFO_MAX_ROW;
    }
    else if (section == EN_SHOP_RESERVATION_NOTE_SECTION)
    {
        count = EN_SHOP_RESERVATION_NOTE_MAX_ROW;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == EN_SHOP_RESERVATION_INFO_SECTION)
    {
        return [self reservationWithTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == EN_SHOP_RESERVATION_NOTE_SECTION)
    {
        RestaurantReservationNoteCell *cell = [RestaurantReservationNoteCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:nil];
        cell.textViewEditBlock = ^(NSInteger type)
        {
            [weakSelf textViewEdit:type];
        };
        cell.baseTableViewCellBlock = ^(id data)
        {
            weakSelf.inputEntity.note = objectNull(data);
        };
        return cell;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = kORestCommonSingleCellHeight;
    if (indexPath.section == EN_SHOP_RESERVATION_NOTE_SECTION)
    {
        height = kRestaurantReservationNoteCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_SHOP_RESERVATION_INFO_SECTION)
    {
        return 10.0;
    }
    else
    {
        return 30.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == EN_SHOP_RESERVATION_INFO_SECTION)
    {
        return nil;
    }
    else
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 0, view.width - 30, view.height) textColor:[UIColor colorWithHexString:@"#9e9691"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"添加备注";
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section == EN_SHOP_RESERVATION_INFO_SECTION)
//    {
//        return 10.0;
//    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == EN_SHOP_RESERVATION_INFO_SECTION)
    {// 基本信息
        switch (indexPath.row)
        {
            case EN_SHOP_RESERVATION_INFO_DATE_ROW: // 预订日期
            {
                [MCYPushViewController showWithCalendarVC:self days:60 title:@"选择预订日期" startDate:nil multChoice:NO completion:^(NSArray *selectList) {
//                    debugLog(@"list=%@", selectList);
                    WYXCalendarDayModel *model = [selectList objectOrNilAtIndex:0];
                    if (model)
                    {
                        weakSelf.inputEntity.dueDate = [model toString];
                        [weakSelf.baseTableView reloadData];
                    }
                }];
            } break;
            case EN_SHOP_RESERVATION_INFO_TIME_ROW: // 到店时段
            {
                [self showChoiceTimeView:YES];
            } break;
            case EN_SHOP_RESERVATION_INFO_NUMBER_ROW: // 就餐人数
            {
                NSDictionary *param = @{@"title":@"就餐人数", @"data":@(_inputEntity.number), @"placeholder":@"请输入就餐人数", @"isNumber":@(YES)};
                [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                    weakSelf.inputEntity.number = [data integerValue];
                    [weakSelf.baseTableView reloadData];
                }];
            } break;
            case EN_SHOP_RESERVATION_INFO_LOCATION_ROW: // 餐厅位置
            {
                [self showWithLocationView:YES];
            } break;
            default:
                break;
        }
    }
    
}

/*
 EN_SHOP_RESERVATION_INFO_DATE_ROW = 0, ///< 预订日期
 EN_SHOP_RESERVATION_INFO_TIME_ROW, ///< 到店时段
 EN_SHOP_RESERVATION_INFO_NUMBER_ROW, ///< 就餐人数
 EN_SHOP_RESERVATION_INFO_LOCATION_ROW, ///< 餐厅位置
 */

@end












