//
//  DinersShopingCartView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersShopingCartView.h"
#import "LocalCommon.h"
#import "DinersShopingCartTopView.h"
#import "DinersShopingCartViewCell.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类
#import "DinersRecipeBottomView.h"

@interface DinersShopingCartView () <UITableViewDelegate, UITableViewDataSource>
{
    
    
    
    NSMutableArray *_shopCartList;
    
    CGRect _tShowFrame;
    CGRect _tHiddenFrame;
}

- (void)initWithTopView;

- (void)initWithShopCartTableView;

@end

@implementation DinersShopingCartView

- (void)initWithVar
{
    [super initWithVar];
    
    _shopCartList = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTopView];
    
    [self initWithShopCartTableView];
    
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersShopingCartTopViewHeight);
        _topView = [[DinersShopingCartTopView alloc] initWithFrame:frame];
        [self addSubview:_topView];
    }
    __weak typeof(self)weakSelf = self;
    _topView.clearShoppingCartBlock = ^()
    {
        if (weakSelf.clearShoppingCartBlock)
        {
            weakSelf.clearShoppingCartBlock();
        }
    };
}

- (void)initWithShopCartTableView
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGFloat height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - kDinersRecipeBottomViewHeight - _topView.height;
    CGRect frame = CGRectMake(0, _topView.bottom, [[UIScreen mainScreen] screenWidth], height);
    _tShowFrame = frame;
    frame.size.height = 0;
    _tHiddenFrame = frame;
    _tHiddenFrame.origin.y = _tShowFrame.origin.y + _tShowFrame.size.height;
    _shopCartTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _shopCartTableView.delegate = self;
    _shopCartTableView.dataSource = self;
    _shopCartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_shopCartTableView];
}

- (void)showWithSubView:(BOOL)show
{
    if (show)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersShopingCartTopViewHeight);
        _topView.frame = frame;
        _shopCartTableView.frame = _tShowFrame;
        _topView.hidden = NO;
        _shopCartTableView.hidden = NO;
    }
    else
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
        _topView.frame = frame;
        _shopCartTableView.frame = _tHiddenFrame;
        _topView.hidden = YES;
        _shopCartTableView.hidden = YES;
    }
    [_topView showWithSubView:show];
}

- (void)updateViewData:(id)entity
{
    [_shopCartList removeAllObjects];
    [_shopCartList addObjectsFromArray:entity];
    [_shopCartTableView reloadData];
}


#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_shopCartList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DinersShopingCartViewCell *cell = [DinersShopingCartViewCell cellForTableView:tableView];
    [cell updateCellData:_shopCartList[indexPath.row]];
    __weak typeof(self)weakSelf = self;
    cell.touchAddSubBlock = ^(NSInteger type, id button,  ShopingCartEntity *cartEntity)
    {
        if (weakSelf.touchAddSubBlock)
        {
            weakSelf.touchAddSubBlock(type, button, cartEntity);
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopingCartEntity *cartEnt = _shopCartList[indexPath.row];
    return [DinersShopingCartViewCell getWithCellHeight:cartEnt];
}


@end
















