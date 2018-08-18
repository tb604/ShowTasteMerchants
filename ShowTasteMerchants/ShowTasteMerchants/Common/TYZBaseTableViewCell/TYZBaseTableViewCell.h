//
//  TYZBaseTableViewCell.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZBaseTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^baseTableViewCellBlock)(id data);


/**
 *  初始化本视图
 *
 *  @param tableView 传进来的UITableView实例
 *
 *  @return id
 */
+ (id)cellForTableView:(UITableView *)tableView;

/**
 *  初始化本视图
 *
 *  @param tableView          传进来的UITableView实例
 *  @param tableViewCellStyle UITableViewCellStyle 类型
 *
 *  @return id
 */
+ (id)cellForTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle;

/**
 *  得到类的名字
 *
 *  @return 返回当前类的名字
 */
+ (NSString *)cellIdentifier;

/**
 *  初始化视图里面的变量
 */
- (void)initWithVarCell;

/**
 *  初始化子视图
 */
- (void)initWithSubViewCell;

- (void)updateCellData:(id)cellEntity;


+ (NSInteger)getWithCellHeight;

@end
