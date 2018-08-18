//
//  DinersRecipeFoodDetailViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeFoodDetailViewController.h"
#import "LocalCommon.h"
#import "UINavigationBar+Awesome.h"
#import "TYZBaseTableViewCell.h"
#import "DinersRecipeFoodDetailHeaderView.h"
#import "DinersRecipeBottomView.h"
#import "ParabolaTool.h"
#import "SYFireworksView.h"
#import "SYFireworksButton.h" // 购物车按钮
#import "RestaurantMenuLeftView.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类
#import "DinersShopingCartView.h" // 显示购物车的视图
#import "DRFoodDetailBaseViewCell.h" // 菜品基本信息
#import "DRFoodDetailStandardViewCell.h" // 规格cell
#import "DRFoodDetailIntroViewCell.h" // 简介cell
#import "DRFoodDetailContentViewCell.h"

@interface DinersRecipeFoodDetailViewController () <ParabolaToolDelegate>
{
    DinersRecipeFoodDetailHeaderView *_headerView;
    
    DinersRecipeBottomView *_bottomView;
    
    /**
     *  显示购物车视图
     */
    DinersShopingCartView *_shopingCartView;
    
    /**
     *  是否显示购物车视图
     */
    BOOL _isShowCartView;
    
    BOOL _isTest;
}

/**
 *   购物车按钮
 */
@property (nonatomic, strong) SYFireworksButton *shoppingCar;

/**
 *  放入购物车的动画视图
 */
@property (nonatomic, strong) UIImageView *redView;

/**
 *  选中的工艺
 */
@property (nonatomic, copy) NSString *selectMode;

/**
 *  选中的口味
 */
@property (nonatomic, copy) NSString *selectTaste;

/**
 *  当前从购物车中添加的
 */
@property (nonatomic, strong) ShopingCartEntity *currentSelectCartEntity;

/**
 *  1表示从菜品中添加的；2表示从购物车中添加的
 */
@property (nonatomic, assign) NSInteger addorSubType;


@property (nonatomic, strong) UIBarButtonItem *itemShare;

- (void)initWithHeaderView;

- (void)initWithBottomView;

- (void)initWithShoppingCar;

/**
 *  显示购物车的视图
 *
 *  @param show YES表示；NO隐藏
 */
- (void)showWithShopingCartView:(BOOL)show;


@end

@implementation DinersRecipeFoodDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.baseTableView];
    
    UIImage *image = [[UIImage alloc] init];
    [self.navigationController.navigationBar setShadowImage:image];
    _isTest = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    [self.navigationController.navigationBar wyx_reset:color];
    
    _isTest = YES;
    
    [super viewWillDisappear:animated];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _isShowCartView = YES;
    
    if (_foodDetailEntity.standard.state == 1)
    {
        // 进来，默认选中第一个
        self.selectMode = objectNull([_foodDetailEntity.standard.mode objectOrNilAtIndex:0]);
        self.selectTaste = objectNull([_foodDetailEntity.standard.taste objectOrNilAtIndex:0]);;
    }
    else
    {
        self.selectMode = @"";
        self.selectTaste = @"";
    }
    
    [self.navigationController.navigationBar wyx_setBackgroundColor:[UIColor clearColor]];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
//    self.title = _mealEntity.name;
    
    // nav_btn_collect_nor
    // nav_btn_share_nor
    if (!_itemShare)
    {
        UIImage *image = nil;
        CGRect frame = CGRectZero;
        image = [UIImage imageNamed:@"nav_btn_share_nor"];
        frame = CGRectMake(0, 0, image.size.width+10, image.size.height);
        UIButton *btnShare = [TYZCreateCommonObject createWithButton:self imgNameNor:@"nav_btn_share_nor" imgNameSel:@"nav_btn_share_nor" targetSel:@selector(clickedButton:)];
        btnShare.frame = frame;
        btnShare.tag = 101;// 分享
        UIBarButtonItem *itemShare = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
        self.itemShare = itemShare;
    }
    
    self.navigationItem.rightBarButtonItem = _itemShare;
//    self.navigationItem.rightBarButtonItems = @[itemShare];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    [self hiddenHeaderView:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
//    AppDelegate * app = [UtilityObject appDelegate];
    CGRect frame = self.baseTableView.frame;
    if (!_isBrowse)
    {
        frame.size.height = [[UIScreen mainScreen] screenHeight] - kDinersRecipeBottomViewHeight;
    }
    else
    {
        frame.size.height = [[UIScreen mainScreen] screenHeight];
    }
    self.baseTableView.frame = frame;
    [self hiddenFooterView:YES];
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithHeaderView];
    
    if (!_isBrowse)
    {
        [self initWithBottomView];
        
        [self.view addSubview:self.redView];
        
        
        [self initWithShoppingCar];
        
        [ParabolaTool sharedTool].delegate = self;
        
        // 显示购物车的数量
        [self shopingCartCount];
        
        // 显示购物车的总金额
        [_bottomView updateViewData:_shopingCartList];

    }
    
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_shopingCartList);
    }
    [super clickedBack:sender];
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [DinersRecipeFoodDetailHeaderView getHeadViewHeight]);
        _headerView = [[DinersRecipeFoodDetailHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:_foodDetailEntity];
}

- (void)initWithBottomView
{
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(0, self.baseTableView.bottom, [[UIScreen mainScreen] screenWidth], kDinersRecipeBottomViewHeight);
    _bottomView = [[DinersRecipeBottomView alloc] initWithFrame:frame];
    [self.view addSubview:_bottomView];
    [_bottomView updateWithBtnTitle:@"继续"];
    _bottomView.viewCommonBlock = ^(id data)
    {// 完成
        [weakSelf clickedWithBottom];
    };
}

/**
 *  初始化购物车视图
 */
- (void)initWithShoppingCar
{
    if(!_shoppingCar)
    {
        UIImage *image = [UIImage imageNamed:@"order_cart_clickable"];
        CGFloat width = image.size.width * 1.5;
        CGFloat height = image.size.height * 1.5;
        CGRect frame = CGRectMake(([RestaurantMenuLeftView getMenuLeftViewWidth] - width) / 2, self.baseTableView.height + (_bottomView.height - height)/2, width, height);
        _shoppingCar = [SYFireworksButton buttonWithType:UIButtonTypeCustom];
        _shoppingCar.backgroundColor = [UIColor clearColor];
        _shoppingCar.frame = frame;
        _shoppingCar.alpha = 1;
        //    cart_count
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 1002;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.frame = CGRectMake((_shoppingCar.width - 20) / 2 + +4, (_shoppingCar.height - 20) / 2 - 2, 20, 20);
        [numLabel setFont:FONTSIZE_10];
        [self.shoppingCar addSubview:numLabel];
        //        _shoppingCar.particleImage = [UIImage imageNamed:@"Sparkle"];
        _shoppingCar.particleScale = 0.05;
        _shoppingCar.particleScaleRange = 0.02;
        [_shoppingCar setImage:image forState:UIControlStateNormal];
        [_shoppingCar addTarget:self action:@selector(clickedShopCart:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shoppingCar];
    }
}


/**
 *  显示购物车的视图
 *
 *  @param show YES表示；NO隐藏
 */
- (void)showWithShopingCartView:(BOOL)show
{
    if (!_shopingCartView)
    {
        CGRect frame = CGRectMake(0, _bottomView.top, [[UIScreen mainScreen] screenWidth], 0);
        _shopingCartView = [[DinersShopingCartView alloc] initWithFrame:frame];
        [self.view addSubview:_shopingCartView];
    }
    __weak typeof(self)weakSelf = self;
    _shopingCartView.clearShoppingCartBlock = ^()
    {// 清除购物车
        [weakSelf clearWithShopingCart];
    };
    _shopingCartView.touchAddSubBlock = ^(NSInteger type, id button,  ShopingCartEntity *cartEntity)
    {// 减菜、加菜
        [weakSelf addOrSubFood:type button:button cartEnt:cartEntity];
    };
    if (show)
    {
        [UIView animateWithDuration:.25 animations:^{
            _shopingCartView.frame = CGRectMake(0, STATUSBAR_HEIGHT + NAVBAR_HEIGHT, [[UIScreen mainScreen] screenWidth], self.baseTableView.height - STATUSBAR_HEIGHT - NAVBAR_HEIGHT);
            [_shopingCartView updateViewData:_shopingCartList];
        } completion:^(BOOL finished) {
            [_shopingCartView showWithSubView:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:.25 animations:^{
            _shopingCartView.frame = CGRectMake(0, _bottomView.top, [[UIScreen mainScreen] screenWidth], 0);
            [_shopingCartView showWithSubView:NO];
        } completion:^(BOOL finished) {
            
        }];
    }
    _isShowCartView = !_isShowCartView;
}

/**
 *  清除购物车
 */
- (void)clearWithShopingCart
{
    [_shopingCartList removeAllObjects];
    
    // 显示购物车的数量
    [self shopingCartCount];
    
    // bottom显示总价
    [_bottomView updateViewData:_shopingCartList];
    // 跟新购物车的数据
    [_shopingCartView updateViewData:_shopingCartList];
    // 刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:EN_DRFD_BASE_ROW inSection:0];
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
}


// 从购物车视图里面直接添加或者减少
- (void)addOrSubFood:(NSInteger)type button:(id)button cartEnt:(ShopingCartEntity *)cartEnt
{
    self.addorSubType = 2;
    self.currentSelectCartEntity = cartEnt;
    debugLog(@"type=%d", (int)type);
    if (type == 1)
    {// 减菜
        _currentSelectCartEntity.addOrSub = 2;
        // 删除指定的购物车里面的菜品
        [self addOrSubShopCart];
    }
    else if (type == 2)
    {// 加菜
        _currentSelectCartEntity.addOrSub = 1;
        UIButton *btn = (UIButton *)button;
        [self addCartAnimation:btn];
    }
}

- (void)addCartAnimation:(UIButton *)btn
{
    CGRect parentRectA = [btn convertRect:btn.bounds toView:self.view];//btn.frame;
    CGRect parentRectB = [self.view convertRect:_shoppingCar.frame toView:self.view];
    parentRectB.origin.x = parentRectB.origin.x - 10;
    self.redView.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    self.redView.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, _redView.frame.size.width, _redView.frame.size.height);
    [self.view addSubview:self.redView];
    UIBezierPath *path= [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(parentRectA.origin.x, parentRectA.origin.y)];
    [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+25,  parentRectB.origin.y+10) controlPoint:CGPointMake((parentRectB.origin.x -parentRectA.origin.x )/2 +parentRectA.origin.x, parentRectA.origin.y - 200)];
    
    [[ParabolaTool sharedTool] throwObject:self.redView  path:path isRotation:NO endScale:0.1];
}

/**
 *  点击购物车按钮
 *
 *  @param sender sender
 */
- (void)clickedShopCart:(id)sender
{
    if ([_shopingCartList count] == 0 && _isShowCartView)
    {
        [SVProgressHUD showErrorWithStatus:@"购物车暂无菜品！"];
        return;
    }
    [self showWithShopingCartView:_isShowCartView];
}

/**
 *  点解bottom视图里面的按钮
 */
- (void)clickedWithBottom
{
    // 点击“完成”
    if (self.popResultBlock)
    {
        self.popResultBlock(_shopingCartList);
    }
    [self clickedBack:nil];
}

/**
 *  抛物线小红点
 *
 *  @return UIImageView
 */
- (UIImageView *)redView
{
    if (!_redView)
    {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] screenWidth]/2 -20, [[UIScreen mainScreen] screenWidth]/2-20, 40, 40)];
        //        _redView.image = [UIImage imageNamed:@"order_cart_clickable"];
        _redView.backgroundColor = [UIColor clearColor];
        _redView.layer.cornerRadius = 40.0/2;
    }
    return _redView;
}

/**
 *  得到购物车的菜品数量
 */
- (void)shopingCartCount
{
    NSInteger num = 0;
    for (ShopingCartEntity *cartEnt in _shopingCartList)
    {
        num += cartEnt.number;
    }
    
    UILabel *numLabel = [self.shoppingCar viewWithTag:1002];
    if (num != 0)
    {
        numLabel.text = [NSString stringWithFormat:@"%d", (int)num];
    }
    else
    {
        numLabel.text = nil;
    }
}

- (void)clickedButton:(id)sender
{
    // 分享菜品详情
    NSInteger shopid = _foodDetailEntity.shop_id;
    NSInteger foodId = _foodDetailEntity.id;
    NSString *url = kShopFoodDetailShareUrl((int)shopid, (int)foodId);
//    debugLog(@"imageurl=%@", _foodDetailEntity.image);
    
    NSString *shareMsg = [NSString stringWithFormat:@"%@ %.0f元/%@ %@", kShopFoodDetailShareMsg, _foodDetailEntity.price, _foodDetailEntity.unit, _foodDetailEntity.intro];
    [UtilityObject showWithShareView:self.view shareImage:_headerView.foodImgView.image shareTitle:_foodDetailEntity.name shareContent:shareMsg shareUrl:url];
}

// 加入购物车
- (void)addWithFoodShopingCart:(UIButton *)btn
{
    self.addorSubType = 1;
    if (btn.tag == 100)
    {// 减菜
        _foodDetailEntity.isAdd = NO;
        
        // 删除指定的购物车里面的菜品
        [self addOrSubShopCart];
    }
    else if (btn.tag == 101 || btn.tag == 102)
    {// 加菜
        _foodDetailEntity.isAdd = YES;
        [self addCartAnimation:btn];
    }
}

/**
 *  加入，或者删除购物车
 */
- (void)addOrSubShopCart
{
    if (self.addorSubType == 1)
    {//   1表示从菜品中添加的
        ShopingCartEntity *cartEnt = [ShopingCartEntity new];
        cartEnt.id = _foodDetailEntity.id;
        cartEnt.category_id = _foodDetailEntity.category_id;
        cartEnt.categoryName = _foodDetailEntity.category_name;
        cartEnt.price = _foodDetailEntity.price;
        cartEnt.activityPrice = _foodDetailEntity.activity_price;
        cartEnt.name = _foodDetailEntity.name;
        cartEnt.number = 1;
        cartEnt.mode = objectNull(_selectMode);
        cartEnt.taste = objectNull(_selectTaste);
        cartEnt.unit = _foodDetailEntity.unit;
        if (_foodDetailEntity.isAdd)
        {// 加入购物车
            [self addWithShopingCart:cartEnt];
        }
        else
        {// 从购物车删除菜品
            [self removeWithShopingCart:cartEnt];
        }
    }
    else if (self.addorSubType == 2)
    {// 2表示从购物车中添加的
        if (_currentSelectCartEntity.addOrSub == 1)
        {// 加入购物车
            [self addWithShopingCart:_currentSelectCartEntity];
        }
        else
        {// 从购物车删除菜品
            [self removeWithShopingCart:_currentSelectCartEntity];
        }
    }
    
    // bottom显示总价
    [_bottomView updateViewData:_shopingCartList];
    // 跟新购物车的数据
    [_shopingCartView updateViewData:_shopingCartList];
    // 刷新
    [self.baseTableView reloadData];
}

// 菜品加入购物车
- (void)addWithShopingCart:(ShopingCartEntity *)cartEntity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_shopingCartList count]; i++)
    {
        ShopingCartEntity *ent = _shopingCartList[i];
        if (ent.id == cartEntity.id && ent.category_id == ent.category_id && [ent.mode isEqualToString:cartEntity.mode] && [ent.taste isEqualToString:cartEntity.taste] && [ent.unit isEqualToString:cartEntity.unit])
        {
            ent.number += 1;
            index = i;
            break;
        }
    }
    if (index == -1)
    {
        [_shopingCartList addObject:cartEntity];
    }
    
    // 发送通知
    RestaurantMenuLeftShopingCartEntity *noteEnt = [RestaurantMenuLeftShopingCartEntity new];
    noteEnt.categoryId = cartEntity.category_id;
    noteEnt.isAdd = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddShopingCartMenuNote object:noteEnt];
}

// 从购物车中删除
- (void)removeWithShopingCart:(ShopingCartEntity *)cartEntity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<[_shopingCartList count]; i++)
    {
        ShopingCartEntity *ent = _shopingCartList[i];
        if (ent.id == cartEntity.id && ent.category_id == ent.category_id && [ent.mode isEqualToString:cartEntity.mode] && [ent.taste isEqualToString:cartEntity.taste] && [ent.unit isEqualToString:cartEntity.unit])
        {
            if (ent.number > 1)
            {
                ent.number -= 1;
            }
            else
            {
                index = i;
            }
            break;
        }
    }
    if (index != -1)
    {
        [_shopingCartList removeObjectAtIndex:index];
    }
    // 显示购物车里的菜品数量
    [self shopingCartCount];
    
    // 发送通知
    RestaurantMenuLeftShopingCartEntity *noteEnt = [RestaurantMenuLeftShopingCartEntity new];
    noteEnt.categoryId = cartEntity.category_id;
    noteEnt.isAdd = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddShopingCartMenuNote object:noteEnt];
}


/**
 *  点解工艺、口味，后调用
 *
 *  @param type  1表示工艺；2表示口味
 *  @param title <#title description#>
 */
- (void)touchStandardType:(NSInteger)type title:(NSString *)title
{
    if (type == 1)
    {// 工艺
        self.selectMode = title;
    }
    else if (type == 2)
    {// 口味
        self.selectTaste = title;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:EN_DRFD_BASE_ROW inSection:0];
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:indexPath reloadType:3];
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithHexString:@"#393b40"];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT)
    {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        if (!_isTest)
        {
            [self initWithNavBar];
        }
        else
        {
            [self performSelector:@selector(initWithNavBar) withObject:nil afterDelay:0.0];
        }
    }
    else
    {
        [self.navigationController.navigationBar wyx_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}


#pragma mark ParabolaToolDelegate
- (void)animationDidFinish
{
    [self.redView removeFromSuperview];
    
    // 加入到购物车
    [self addOrSubShopCart];
    
    // 显示购物车的数量
    [self shopingCartCount];
    
    [self.shoppingCar popOutsideWithDuration:0.5];
    [self.shoppingCar animate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = EN_DRFD_MAX_ROW + [_foodDetailEntity.content count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == EN_DRFD_BASE_ROW)
    {// 基本信息
        DRFoodDetailBaseViewCell *cell = [DRFoodDetailBaseViewCell cellForTableView:tableView];
        [cell updateCellData:_foodDetailEntity shopingCarts:_shopingCartList selMode:_selectMode selTaste:_selectTaste isBrowse:_isBrowse];
        cell.addFoodBlock = ^(UIButton *btn)
        {// “-”、“+”、“加入购物车”
            [weakSelf addWithFoodShopingCart:btn];
        };
        return cell;
    }
    else if (indexPath.row == EN_DRFD_STANDARD_ACTIVITY_ROW)
    {// 规格
        DRFoodDetailStandardViewCell *cell = [DRFoodDetailStandardViewCell cellForTableView:tableView];
        [cell updateCellData:_foodDetailEntity isBrowse:_isBrowse];
        cell.touchStandardBlock = ^(NSInteger type, NSString *title)
        {// type 1表示工艺；2表示口味
            [weakSelf touchStandardType:type title:title];
        };
        return cell;
    }
    else if (indexPath.row == EN_DRFD_INTRO_ROW)
    {// 简介
        DRFoodDetailIntroViewCell *cell = [DRFoodDetailIntroViewCell cellForTableView:tableView];
        [cell updateCellData:_foodDetailEntity];
        return cell;
    }
    else
    {
        NSInteger row = indexPath.row - EN_DRFD_MAX_ROW;
//        debugLog(@"row=%d", (int)row);
        DRFoodDetailContentViewCell *cell = [DRFoodDetailContentViewCell cellForTableView:tableView];
        [cell updateCellData:[_foodDetailEntity.content objectOrNilAtIndex:row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
    if (indexPath.row == EN_DRFD_BASE_ROW)
    {// 基本信息
        height = kDRFoodDetailBaseViewCellHeight;
    }
    else if (indexPath.row == EN_DRFD_STANDARD_ACTIVITY_ROW)
    {// 规格
        if (_foodDetailEntity.standard.state == 1)
        {
            height = 15 + 16 + 10 + _foodDetailEntity.standard.modeHeight + 15 + _foodDetailEntity.standard.tasteHeight + kDRFoodStandardActivityViewHeight - 20 + _foodDetailEntity.remarkHeight;
            if (_foodDetailEntity.standard.mode.count == 0 || _foodDetailEntity.standard.taste.count == 0)
            {
                height = height - 15;
            }
        }
        else
        {
            height = kDRFoodStandardActivityViewHeight - 20 + _foodDetailEntity.remarkHeight;
        }
        _foodDetailEntity.standard.totalHeight = height;
    }
    else if (indexPath.row == EN_DRFD_INTRO_ROW)
    {// 简介
        height = kDRFoodDetailIntroViewCellHeight - 20 + _foodDetailEntity.introHeight;
    }
    else
    {
        height = [DRFoodDetailContentViewCell getWithCellHeight];
    }
    return height;
}


@end












