//
//  MyWalletViewController.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewController.h"
#import "UserInfoDataEntity.h"

typedef NS_ENUM(NSInteger, EN_WALLET_SECTIONS)
{
    //NS_WALLET_THIRD_SECTION = 0, ///<第三方支持
    // NS_WALLET_TOPDEPOST_SECTION, ///< 重置、提现
    EN_WALLET_MAX_SECTION
};

typedef NS_ENUM(NSInteger, EN_WALLET_TOPDEPOST_ROWS)
{
    EN_WALLET_TOPUP_ROW = 0, ///< 充值
    EN_WALLET_WITHDRAWAL_ROW, ///< 提现
    EN_WALLET_TOPDEPOST_MAX_ROW
};// withdrawal

/**
 *  我的钱包视图控制器
 */
@interface MyWalletViewController : TYZBaseTableViewController


@property (nonatomic, strong) UserInfoDataEntity *walletEntity;

@end














