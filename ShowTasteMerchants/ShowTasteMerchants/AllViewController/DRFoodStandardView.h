//
//  DRFoodStandardView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface DRFoodStandardView : TYZBaseView

/**
 *  type 1表示工艺；2表示口味
 */
@property (nonatomic, copy) void (^touchStandardBlock)(NSInteger type, NSString *title);

- (void)updateViewData:(id)entity isBrowse:(BOOL)isBrowse;

@end
