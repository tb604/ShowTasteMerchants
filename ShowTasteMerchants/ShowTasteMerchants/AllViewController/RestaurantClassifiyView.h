//
//  RestaurantClassifiyView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "RestaurantClassifiyBottomView.h"
#import "CuisineContentDataEntity.h"

@interface RestaurantClassifiyView : TYZBaseView

// CuisineContentDataEntity
//@property (nonatomic, copy) void (^cuisineChoiceBlock)(CuisineContentDataEntity *cuisineEntity, NSInteger typeId);

- (id)initWithFrame:(CGRect)frame bottomHeight:(CGFloat)bottomHeight;

/**
 *  传统菜系id
 */
@property (nonatomic, assign) NSInteger ctId;

/**
 *  特色菜系id
 */
@property (nonatomic, assign) NSInteger tsId;

/**
 *  国际菜系id
 */
@property (nonatomic, assign) NSInteger gjId;


- (void)updateWithHiddenFrame;
- (void)updateWithShowFrame;
- (void)updateHidden:(BOOL)hidden;

@end
