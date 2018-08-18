/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingChangeTableNoView.h
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/24 11:41
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZBaseView.h"

@class ShopSeatInfoEntity;

@interface CTCRestaurantMealingChangeTableNoView : TYZBaseView

// seatEnt 大厅；tableNo桌号；number人数
@property (nonatomic, copy) void (^touchChangeSubmitBlock)(ShopSeatInfoEntity *seatEnt, NSString *tableNo, NSInteger number);

@property (nonatomic, copy) void (^touchChangeCancelBlock)();


@property (nonatomic, copy) void (^textFieldDidBeginEditBlock)();

@property (nonatomic, copy) void (^textFieldDidEndEditBlock)();

/**
 *  更新信息
 *
 *  @param seatList 大厅、、、
 *  @param tableNo 桌号
 *  @param number 人数
 *  @param seatLocId 餐位编号
 *
 */
- (void)updateWithSeat:(NSArray *)seatList tableNo:(NSString *)tableNo number:(NSInteger)number seatLocId:(NSInteger)seatLocId;

@end
