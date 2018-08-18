//
//  ResaurantAddFoodImageViewCell.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseTableViewCell.h"
#import "ResaurantAddFoodImageView.h"


#define kResaurantAddFoodImageViewCellHeight ([ResaurantAddFoodImageView getWithHeight] + 100)


@interface ResaurantAddFoodImageViewCell : TYZBaseTableViewCell

@property (nonatomic, copy) void (^touchUploadFoodImageBlock)();

@end
