//
//  MyWalletDetailStreamViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyWalletDetailStreamViewController.h"
#import "LocalCommon.h"
#import "MyWalletDetailStreamViewCell.h"
#import "MyWalletDetailStreamAmountViewCell.h"
#import "MyWalletConsumeEntity.h"

@interface MyWalletDetailStreamViewController ()

@end

@implementation MyWalletDetailStreamViewController

- (void)initWithVar
{
    [super initWithVar];
        
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"流水详情";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_WALLET_STREAM_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_WALLET_STREAM_MAX_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EN_WALLET_STREAM_SECTION)
    {
        if (indexPath.row == EN_WALLET_STREAM_AMOUNT_ROW)
        {// 出/入账金额
            MyWalletDetailStreamAmountViewCell *cell = [MyWalletDetailStreamAmountViewCell cellForTableView:tableView];
            
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"出账金额" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", _consumeEntity.money] attributes:@{NSFontAttributeName: FONTSIZE(24), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
            
        }
        else if (indexPath.row == EN_WALLET_STREAM_TYPE_ROW)
        {// 类型
            MyWalletDetailStreamViewCell *cell = [MyWalletDetailStreamViewCell cellForTableView:tableView];
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"类型" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:objectNull(_consumeEntity.category_desc) attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
        }
        else if (indexPath.row == EN_WALLET_STREAM_DATETIME_ROW)
        {// 时间
            MyWalletDetailStreamViewCell *cell = [MyWalletDetailStreamViewCell cellForTableView:tableView];
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"时间" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSString *date = [NSDate stringWithDateInOut:_consumeEntity.create_datetime inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd HH:mm"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:date attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
        }
        else if (indexPath.row == EN_WALLET_STREAM_TRADENO_ROW)
        {// 交易单号
            MyWalletDetailStreamViewCell *cell = [MyWalletDetailStreamViewCell cellForTableView:tableView];
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"交易单号" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:objectNull(_consumeEntity.order_id) attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
        }
        else if (indexPath.row == EN_WALLET_STREAM_BALANCE_ROW)
        {// 余额
            MyWalletDetailStreamViewCell *cell = [MyWalletDetailStreamViewCell cellForTableView:tableView];
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"余额" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", _consumeEntity.balance] attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
        }
        else if (indexPath.row == EN_WALLET_STREAM_NOTE_ROW)
        {// 备注
            MyWalletDetailStreamViewCell *cell = [MyWalletDetailStreamViewCell cellForTableView:tableView];
            UIColor *color = [UIColor colorWithHexString:@"#999999"];
            NSAttributedString *atitle = [[NSAttributedString alloc] initWithString:@"备注" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *avalue = [[NSAttributedString alloc] initWithString:objectNull(_consumeEntity.remark) attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            
            [cell updateCellData:atitle value:avalue];
            return cell;
        }
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    return cell;
}

/*
 EN_WALLET_STREAM_AMOUNT_ROW = 0, ///< 出/入账金额
 EN_WALLET_STREAM_TYPE_ROW,  ///< 类型
 EN_WALLET_STREAM_DATETIME_ROW, ///< 时间
 EN_WALLET_STREAM_TRADENO_ROW, ///< 交易单号
 EN_WALLET_STREAM_BALANCE_ROW, ///< 余额
 EN_WALLET_STREAM_NOTE_ROW, ///< 备注
 EN_WALLET_STREAM_MAX_ROW
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == EN_WALLET_STREAM_AMOUNT_ROW)
    {
        return kMyWalletDetailStreamAmountViewCellHeight;
    }
    return kMyWalletDetailStreamViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
