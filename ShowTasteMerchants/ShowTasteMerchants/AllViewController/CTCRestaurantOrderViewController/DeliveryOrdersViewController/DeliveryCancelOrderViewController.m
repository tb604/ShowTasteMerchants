//
//  DeliveryCancelOrderViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryCancelOrderViewController.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "DeliveryCancelOrderCell.h"
#import "DeliveryCancelOrderOtherCell.h"
#import "DeliveryCancelOrderFooterView.h"
#import "DeliveryCancelOrderOtherReasonCell.h"
//#import "CancelReservationEntity.h"

@interface DeliveryCancelOrderViewController () <UITextViewDelegate>
{
    DeliveryCancelOrderFooterView *_footerView;
    
    /// 取消传入参数
//    CancelReservationEntity *_cancelReasonEntity;
    
}
//@property (nonatomic, strong) NSMutableArray *selectList;

@property (nonatomic, strong) CellCommonDataEntity *selectEntity;

@property (nonatomic, strong) CellCommonDataEntity *otherEntity;

@end

@implementation DeliveryCancelOrderViewController

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
    
//    _cancelReasonEntity = [CancelReservationEntity new];
//    _cancelReasonEntity.orderId = [NSString stringWithFormat:@"%lld", (long long)_orderDetailEntity.order_id];
    
    CellCommonDataEntity *ent = nil;
    if (_type == 2)
    {
        [self.baseList addObjectsFromArray:_reasonList];
        
    }
    else
    {
        ent = [CellCommonDataEntity new];
        ent.title = @"商品已卖完";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"商品已打烊";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"不满足起送要求";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"超出配送范围";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"配送出现问题";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"用户申请取消";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"联系不上用户";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"用户信息不符";
        [self.baseList addObject:ent];
        
        ent = [CellCommonDataEntity new];
        ent.title = @"其它原因";
        ent.isCheck = NO;
        self.otherEntity = ent;
    }
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_type == 2)
    {
        self.title = @"取消达达";
    }
    else
    {
        self.title = @"拒单";
    }
    
    CGRect frame = CGRectMake(0, 0, 40, 40);
    UIButton *btnChange = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"确认" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_16 targetSel:@selector(clickedSubmit:)];
    btnChange.frame = frame;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnChange];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)initWithFooterView
{
    if (!_footerView && _type == 1)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDeliveryCancelOrderFooterViewHeight);
        _footerView = [[DeliveryCancelOrderFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
}

/// 确认取消
- (void)clickedSubmit:(id)sender
{
    [SVProgressHUD showWithStatus:@"取消中..."];
    NSString *orderId = [NSString stringWithFormat:@"%lld", (long long)_orderDetailEntity.order_id];
    
    
    if (_type == 2)
    {// 取消达达
        [HCSNetHttp requestWithDadaCancelOrder:@"73753" orderId:orderId cancelReasonId:(int)_selectEntity.tag cancelReason:_selectEntity.title completion:^(TYZRespondDataEntity *result) {
            if (result.errcode == respond_success)
            {
                [SVProgressHUD showSuccessWithStatus:@"取消达达成功"];
                if (self.popResultBlock)
                {
                    self.popResultBlock(@"cancelDADASuccess");
                }
                [self clickedBack:nil];
            }
            else
            {
                [UtilityObject svProgressHUDError:result viewContrller:self];
            }
        }];
        return;
    }
    
    
    [HCSNetHttp requestWithWaimaiCancelOrder:orderId reason:_selectEntity.title completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
            if (self.popResultBlock)
            {
                self.popResultBlock(@"cancelSuccess");
            }
            [self clickedBack:nil];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
}

 #pragma mark UITextViewDelegate
 - (void)textViewDidBeginEditing:(UITextView *)textView
 {
     debugMethod();
     if (kiPhone4)
     {
         self.baseTableView.contentInset = UIEdgeInsetsMake(-440, 0, 0, 0);
     }
     else if (kiPhone5)
     {
         self.baseTableView.contentInset = UIEdgeInsetsMake(-300, 0, 0, 0);
     }
     else if (kiPhone6)
     {
         self.baseTableView.contentInset = UIEdgeInsetsMake(-260, 0, 0, 0);
     }
     else
     {
         self.baseTableView.contentInset = UIEdgeInsetsMake(-220, 0, 0, 0);
     }
 }

 - (void)textViewDidEndEditing:(UITextView *)textView
 {
     debugMethod();
     self.baseTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
 }
 
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
 {
     debugMethod();
     if ([text isEqualToString:@"\n"])
     {
         [textView resignFirstResponder];
//         _foodImageEntity.desc = textView.text;
         _selectEntity.subTitle = textView.text;
         return YES;
     }
     return YES;
 }


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_type == 1)
    {
        return 2;
    }
    else if (_type == 2)
    {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.baseList count];
    }
    else
    {
        if (_otherEntity.isCheck)
        {
            return 2;
        }
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        DeliveryCancelOrderCell *cell = [DeliveryCancelOrderCell cellForTableView:tableView];
        CellCommonDataEntity *ent = self.baseList[indexPath.row];
        [cell updateCellData:ent];
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            DeliveryCancelOrderOtherCell *cell = [DeliveryCancelOrderOtherCell cellForTableView:tableView];
            [cell updateCellData:_otherEntity];
            return cell;
        }
        else
        {
            if (_otherEntity.isCheck)
            {
                DeliveryCancelOrderOtherReasonCell *cell = [DeliveryCancelOrderOtherReasonCell cellForTableView:tableView];
                [cell updateCellData:_orderDetailEntity];
                cell.reasonTxtView.delegate = self;
                return cell;
            }
            else
            {
                return nil;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kDeliveryCancelOrderCellHeight;
    }
    else
    {
        if (indexPath.row == 0)
        {
            return kDeliveryCancelOrderCellHeight;
        }
        else
        {
            return kDeliveryCancelOrderOtherReasonCellHeight;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 30;
    }
    else
    {
        return 0.001;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(10, 0, view.width - 20, view.height) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"选择取消原因";
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        CellCommonDataEntity *ent = self.baseList[indexPath.row];
        
        for (CellCommonDataEntity *cellEnt in self.baseList)
        {
            cellEnt.isCheck = NO;
        }
        ent.isCheck = YES;
        self.selectEntity = ent;
        [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:2];
    }
    else
    {
        _otherEntity.isCheck = !_otherEntity.isCheck;
        DeliveryCancelOrderOtherCell *cell = (DeliveryCancelOrderOtherCell *)[self.baseTableView cellForRowAtIndexPath:indexPath];
        [cell updateCellData:_otherEntity];
        
        if (_otherEntity.isCheck)
        {
            NSMutableArray *addList = [NSMutableArray new];
            [addList addObject:[NSIndexPath indexPathForRow:1+indexPath.row inSection:indexPath.section]];
            
            [tableView insertRowsAtIndexPaths:addList withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            NSMutableArray *addList = [NSMutableArray new];
            [addList addObject:[NSIndexPath indexPathForRow:1+indexPath.row inSection:indexPath.section]];
            [self.baseTableView deleteRowsAtIndexPaths:addList withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    scrollView.contentOffset
    //    debugMethod();
    //    if (_fpsLabel.alpha == 0)
    //    {
    //        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    //            _fpsLabel.alpha = 1;
    //        } completion:NULL];
    //    }
}

/*
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    debugMethod();
    //    self.point = scrollView.contentOffset;
    if (!decelerate)
    {
        //        debugLog(@"dfdfd");
        //        if (_fpsLabel.alpha != 0)
        //        {
        //            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        //                _fpsLabel.alpha = 0;
        //            } completion:NULL];
        //        }
//        [self.view endEditing:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    debugMethod();
//    [self.view endEditing:YES];
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
*/

@end















