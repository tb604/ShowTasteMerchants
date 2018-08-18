//
//  RestaurantReservationNoteCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kRestaurantReservationNoteCellHeight (70.0)

@interface RestaurantReservationNoteCell : TYZBaseTableViewCell

/**
 *  type 1表示编辑开始；2表示编辑结束
 */
@property (nonatomic, copy) void (^textViewEditBlock)(NSInteger type);

@end
