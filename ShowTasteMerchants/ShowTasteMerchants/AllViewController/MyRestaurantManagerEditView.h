//
//  MyRestaurantManagerEditView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "MyRestaurantManagerEditSingleView.h"
#import "ShopManageDataEntity.h"

@interface MyRestaurantManagerEditView : TYZBaseView

/**
 *  员工
 */
@property (nonatomic, strong) ShopManageDataEntity *staffEntity;

/**
 *  姓名视图
 */
//@property (nonatomic, strong) MyRestaurantManagerEditSingleView *nameView;

@property (nonatomic, strong) MyRestaurantManagerEditSingleView *mobileView;

- (void)updateWithData:(id)data title:(NSString *)title;

@end
