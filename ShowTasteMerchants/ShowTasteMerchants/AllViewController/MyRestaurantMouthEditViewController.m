//
//  MyRestaurantMouthEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/3.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthEditViewController.h"
#import "LocalCommon.h"
#import "MyRestaurantMouthEditTopCell.h"
#import "MyRestaurantMouthEditFoodCell.h"
#import "MyRestaurantMouthEditFoodSectionHeader.h"
#import "MyRestaurantMouthEditBottomView.h"
#import "ShopFoodDataEntity.h"
#import "ShopMouthDataEntity.h"
#import "RefreshMouthDataEntity.h"
#import "UserLoginStateObject.h"
#import "MyRestaurantChoiceMouthBackgroundView.h"
#import "MyRestaurantMouthSelectEntity.h"

@interface MyRestaurantMouthEditViewController () <UIAlertViewDelegate>
{
    NSInteger _selectIndex;
    
    MyRestaurantMouthEditBottomView *_bottomView;
    
    /**
     *  是否有更新
     */
    BOOL _isUpdate;
    
    MyRestaurantChoiceMouthBackgroundView *_choiceMouthView;
    
    /**
     *  操作过的数据
     */
    NSMutableArray *_operatorList;
}

@property (nonatomic, assign) NSInteger selectIndex;

- (void)initWithBottomView;

@end

@implementation MyRestaurantMouthEditViewController

- (void)initWithVar
{
    [super initWithVar];
    
    _operatorList = [NSMutableArray new];
    
    _selectIndex = 0;
    
    _isUpdate = NO;
    
    
//    for (ShopMouthDataEntity *mouthEnt in _mouthList)
//    {
//        debugLog(@"id=%d；printerName=%@", (int)mouthEnt.id, mouthEnt.printer_name);
//    }
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"档口编辑";
    
    NSString *str = @"保存";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    CGRect frame = CGRectMake(0, 0, width, 30);
    UIButton *btn = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:str titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedWithBtnRight:)];
    btn.frame = frame;
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = itemRight;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    AppDelegate *app = [UtilityObject appDelegate];
//    CGRect frame = self.baseTableView.frame;
//    frame.size.height = frame.size.height - [app tabBarHeight];
//    self.baseTableView.frame = frame;
//    self.baseTableView.backgroundColor = [UIColor purpleColor];
    
    self.baseTableView.scrollEnabled = NO;
    
//    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    if (sender && ![sender isKindOfClass:[NSString class]] && _isUpdate)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本次操作未保存，请选保存！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    else
    {
        [super clickedBack:sender];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
    {
        [super clickedBack:nil];
    }
}

/**
 *  保存
 */
- (void)clickedWithBtnRight:(id)sender
{
    if (!_isUpdate)
    {
        [SVProgressHUD showErrorWithStatus:@"您没有改动任何档口菜品！"];
        return;
    }
    
    RefreshMouthDataEntity *mouthEntity = [RefreshMouthDataEntity new];
    mouthEntity.shop_id = [UserLoginStateObject getCurrentShopId];
    NSMutableArray *addList = [NSMutableArray new];
    for (MyRestaurantMouthSelectEntity *selEnt in _operatorList)
    {
        if (selEnt.printerId != selEnt.nPrinterId)
        {
            if (selEnt.flag == 0)
            {
                RefreshMouthFoodEntity *ent = [RefreshMouthFoodEntity new];
                ent.pid = selEnt.printerId;
                ent.fid = selEnt.foodId;
                [addList addObject:ent];
            }
            else if (selEnt.nFlag == 0)
            {
                RefreshMouthFoodEntity *ent = [RefreshMouthFoodEntity new];
                ent.pid = selEnt.nPrinterId;
                ent.fid = selEnt.nFoodId;
                [addList addObject:ent];
            }
        }
    }
    
    if ([addList count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"您没有修改档口信息"];
        return;
    }
    
    mouthEntity.printers = addList;
    id dict = [mouthEntity modelToJSONObject];
    debugLog(@"dict=%@", [dict jsonPrettyStringEncoded]);
//    return;

    NSString *content = [mouthEntity modelToJSONString];
    //        debugLog(@"json=%@", [mouthEntity modelToJSONString]);
    [SVProgressHUD showWithStatus:@"提交中"];
    [HCSNetHttp requestWithShopPrinterSet:content completion:^(id result) {
        TYZRespondDataEntity *respond = result;
        if (respond.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"更新成功"];
            
            _isUpdate = NO;
            if (self.popResultBlock)
            {
                self.popResultBlock(_mouthList);
            }
            [self performSelector:@selector(clickedBack:) withObject:@"success" afterDelay:0.2];
        }
        else
        {
            [UtilityObject svProgressHUDError:respond viewContrller:self];
        }
    }];
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[MyRestaurantMouthEditBottomView alloc] initWithFrame:frame];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [weakSelf bottomWithClickedTitle:title tag:tag];
    };
}

- (void)bottomWithClickedTitle:(NSString *)title tag:(NSInteger)tag
{
//    if ([title isEqualToString:@"取消"])
//    {
//        [self clickedBack:nil];
//    }
//    else if ([title isEqualToString:@"保存"])
//    {
//        
//        
//    }
}

- (void)showWithChoiceMouthView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_choiceMouthView)
    {
        _choiceMouthView = [[MyRestaurantChoiceMouthBackgroundView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]) mouthList:_mouthList];
        _choiceMouthView.alpha = 0;
    }
    _choiceMouthView.choiceMouthBlock = ^(id data)
    {
        if (data)
        {
            ShopMouthDataEntity *mouthEntity = data;
            for (NSInteger i=0; i<[_mouthList count]; i++)
            {
                ShopMouthDataEntity *ent = weakSelf.mouthList[i];
                if (ent.id == mouthEntity.id)
                {
                    weakSelf.selectIndex = i;
                    [weakSelf.baseTableView reloadData];
                    break;
                }
            }
        }
        [weakSelf showWithChoiceMouthView:NO];
    };
    if (show)
    {
        [self.view.window addSubview:_choiceMouthView];
        
//        [_locationView updateWithLocation:ent];
        [UIView animateWithDuration:0.5 animations:^{
            _choiceMouthView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _choiceMouthView.alpha = 0;
        } completion:^(BOOL finished) {
            [_choiceMouthView removeFromSuperview];
        }];
    }
}


- (void)refreshMouthFood:(ShopMouthDataEntity *)rmouthEnt
{
    for (ShopMouthDataEntity *mouthEnt in _mouthList)
    {
        if (mouthEnt.id == rmouthEnt.id)
        {
            mouthEnt.foods = rmouthEnt.foods;
            break;
        }
    }
    
    _isUpdate = YES;
}

/**
 *  操作(只修改flag或者nflag为0的时候的档口id)
 *
 *  @param entity 参数
 *  @param type   1表示移到归档；2表示移到非归档
 */
- (void)mouthWithOperator:(ShopFoodDataEntity *)entity type:(int)type
{// MyRestaurantMouthSelectEntity
//    debugLog(@"entt=%@", [entity modelToJSONString]);
    
    ShopMouthDataEntity *mouthEnt = _mouthList[_selectIndex];
    MyRestaurantMouthSelectEntity *selectEntity = nil;
    BOOL bRet = NO;
    if (type == 1)
    {// 从非归档移动到归档
        for (MyRestaurantMouthSelectEntity *selEnt in _operatorList)
        {
            if (selEnt.foodId == entity.id)
            {// 菜品相等
                selectEntity = selEnt;
                bRet = YES;
                break;
            }
        }
        
        if (!bRet)
        {
            MyRestaurantMouthSelectEntity *addEnt = [MyRestaurantMouthSelectEntity new];
            addEnt.fixPrinterId = mouthEnt.id;
            addEnt.flag = 0;
            addEnt.foodId = entity.id;
            addEnt.printerId = mouthEnt.id;
            addEnt.nFlag = 1;
            addEnt.nFoodId = entity.id;
            addEnt.nPrinterId = 0;
            [_operatorList addObject:addEnt];
        }
        else
        {
            if (selectEntity.flag == 0)
            {
                selectEntity.printerId = mouthEnt.id;
            }
            else if (selectEntity.nFlag == 0)
            {
                selectEntity.nPrinterId = mouthEnt.id;
            }
//            selectEntity.nPrinterId = mouthEnt.id;
        }
    }
    else if (type == 2)
    {// 从归档移动到非归档
        for (MyRestaurantMouthSelectEntity *selEnt in _operatorList)
        {
            if (selEnt.foodId == entity.id)
            {// 菜品相等
                selectEntity = selEnt;
                bRet = YES;
                break;
            }
        }
        
        if (!bRet)
        {
            MyRestaurantMouthSelectEntity *addEnt = [MyRestaurantMouthSelectEntity new];
            addEnt.fixPrinterId = mouthEnt.id;
            addEnt.flag = 1;
            addEnt.foodId = entity.id;
            addEnt.printerId = mouthEnt.id;
            addEnt.nFlag = 0;
            addEnt.nFoodId = entity.id;
            addEnt.nPrinterId = 0;
            [_operatorList addObject:addEnt];
        }
        else
        {
            if (selectEntity.flag == 0)
            {
                selectEntity.printerId = 0;
            }
            else if (selectEntity.nFlag == 0)
            {
                selectEntity.nPrinterId = 0;
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_mouthList count] > 0)
    {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_mouthList count] > 0)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MyRestaurantMouthEditTopCell *cell = [MyRestaurantMouthEditTopCell cellForTableView:tableView];
        [cell updateCellData:_mouthList[_selectIndex]];
        return cell;
    }
    MyRestaurantMouthEditFoodCell *cell = [MyRestaurantMouthEditFoodCell cellForTableView:tableView];
    [cell updateCellData:_mouthList[_selectIndex] unarchiveFoodList:_freeFoodList];
    __weak typeof(self)weakSelf = self;
    cell.refreshMouthBlock = ^(id data)
    {// 更新归档菜品
        [weakSelf refreshMouthFood:data];
    };
    cell.mouthOperatorBlock = ^(id data, int type)
    {
        [weakSelf mouthWithOperator:data type:type];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kMyRestaurantMouthEditTopCellHeight;
    }
    
    return [MyRestaurantMouthEditFoodCell getWithCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
    {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        MyRestaurantMouthEditFoodSectionHeader *headerView = [[MyRestaurantMouthEditFoodSectionHeader alloc] initWithFrame:frame];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        [self showWithChoiceMouthView:YES];
    }
}


@end













