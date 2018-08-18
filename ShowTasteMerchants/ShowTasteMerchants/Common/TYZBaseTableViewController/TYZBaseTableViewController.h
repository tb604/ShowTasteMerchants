//
//  TYZBaseTableViewController.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import "TYZBaseTableViewCell.h"
#import "TYZBaseTableView.h"

@interface TYZBaseTableViewController : TYZBaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *baseList;

@property (nonatomic, strong) TYZBaseTableView *baseTableView;

/**
 *  初始化
 *
 *  @param nibNameOrNil   nibNameOrNil
 *  @param nibBundleOrNil nibBundleOrNil
 *  @param isStylePlain   类型 UITableViewStylePlain/UITableViewStyleGrouped
 *
 *  @return id
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isStylePlain:(BOOL)isStylePlain;

- (void)initWithBaseTableView;

- (NSInteger)getBaseListCount;

- (void)initWithHeaderView;

- (void)initWithFooterView;

@end
