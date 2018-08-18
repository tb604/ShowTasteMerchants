//
//  ShopEvaluationContentViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"

//#define kShopEvaluationContentViewCellHeight (168.0)

@interface ShopEvaluationContentViewCell : TYZBaseTableViewCell

/**
 *  type 1表示编辑开始；2表示编辑结束
 */
@property (nonatomic, copy) void (^editStateBlock)(NSInteger type);

@property (nonatomic, copy) void (^addImageBlock)();


+ (NSInteger)getWithImageWidth;

+ (CGFloat)getWithCellHeight;

@end
