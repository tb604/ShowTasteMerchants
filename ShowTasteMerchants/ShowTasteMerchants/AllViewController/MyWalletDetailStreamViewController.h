//
//  MyWalletDetailStreamViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "MyWalletConsumeEntity.h"


typedef NS_ENUM(NSInteger, EN_WALLET_STREAM_SECTIONS)
{
    EN_WALLET_STREAM_SECTION = 0,
    EN_WALLET_STREAM_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_WALLET_STREAM_ROWS)
{
    EN_WALLET_STREAM_AMOUNT_ROW = 0, ///< 出/入账金额
    EN_WALLET_STREAM_TYPE_ROW,  ///< 类型
    EN_WALLET_STREAM_DATETIME_ROW, ///< 时间
    EN_WALLET_STREAM_TRADENO_ROW, ///< 交易单号
    EN_WALLET_STREAM_BALANCE_ROW, ///< 余额
    EN_WALLET_STREAM_NOTE_ROW, ///< 备注
    EN_WALLET_STREAM_MAX_ROW
};// balance

/**
 *  流水号详情视图控制器
 */
@interface MyWalletDetailStreamViewController : TYZBaseTableViewController

@property (nonatomic, strong) MyWalletConsumeEntity *consumeEntity;

@end

















