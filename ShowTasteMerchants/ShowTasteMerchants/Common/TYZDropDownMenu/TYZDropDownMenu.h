//
//  TYZDropDownMenu.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYZDropDownMenuIndexPath.h"


@interface TYZDropBackgroundCellView : UIView

@end

#pragma mark - data source protocol
@class TYZDropDownMenu;

@protocol TYZDropDownMenuDataSource <NSObject>

@required

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column;

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(TYZDropDownMenu *)menu titleForRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath;

@optional
/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(TYZDropDownMenu *)menu;


/** 新增
 *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
 *  如果都没有可以不实现该协议
 */
- (NSInteger)menu:(TYZDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;

/** 新增
 *  当有column列 row 行 item项 title
 *  如果都没有可以不实现该协议
 */
- (NSString *)menu:(TYZDropDownMenu *)menu titleForItemsInRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath;

/**
 *  是否需要显示为UICollectionView 默认为否
 *
 *  @param column <#column description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol TYZDropDownMenuDelegate <NSObject>
@optional
/**
 *  点击代理，点击了第column 第row 或者item项，如果 item >=0
 */
- (void)menu:(TYZDropDownMenu *)menu didSelectRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath;
@end


@interface TYZDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<TYZDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id<TYZDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor; ///< 三角指示器颜色
@property (nonatomic, strong) UIColor *textColor; ///< 文字title的颜色
@property (nonatomic, strong) UIColor *textSelectedColor; ///< 文字选中的颜色
@property (nonatomic, strong) UIColor *separatorColor; ///< 分割线的颜色(指的是菜单下面的横线和菜单之间的竖线)
@property (nonatomic, assign) CGFloat fontSize; ///<文字的大小

@property (nonatomic, assign) BOOL isClickHaveItemValid; ///< 当有二级列表item时，点解row是否调用点击代理方法


/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;

/**
 *  获取title
 *
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)titleForRowAtIndexPath:(TYZDropDownMenuIndexPath *)indexPath;

/**
 *  创建menu 第一次显示 不会调用点击代理，这个手动调用
 */
- (void)selectDefalutIndexPath;

@end



























