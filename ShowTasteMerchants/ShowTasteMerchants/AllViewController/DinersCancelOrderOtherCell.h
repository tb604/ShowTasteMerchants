//
//  DinersCancelOrderOtherCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kDinersCancelOrderOtherCellHeight (70.0+44)

@interface DinersCancelOrderOtherCell : TYZBaseTableViewCell

/**
 *  type 1表示编辑开始；2表示编辑结束
 */
@property (nonatomic, copy) void (^textViewEditBlock)(NSInteger type);

@end
