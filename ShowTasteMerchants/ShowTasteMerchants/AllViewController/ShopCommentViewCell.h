//
//  ShopCommentViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

#define kShopCommentViewCellHeight (104.0)

/**
 *  评论
 */
@interface ShopCommentViewCell : TYZBaseTableViewCell


- (void)hiddenWithLine:(BOOL)hidden;

- (void)hiddenWithTopLine:(BOOL)hidden;

@end
