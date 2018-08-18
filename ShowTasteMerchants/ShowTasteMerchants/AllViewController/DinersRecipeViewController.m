//
//  DinersRecipeViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeViewController.h"
#import "LocalCommon.h"
#import "ShopFoodCategoryDataEntity.h"
#import "RestaurantMenuLeftView.h"
#import "DinersRecipeTopView.h"
#import "DinersRecipeBottomView.h"
#import "DinersRecipeViewCell.h"
#import "ParabolaTool.h"
#import "SYFireworksView.h"
#import "SYFireworksButton.h"
#import "DinersRecipeCollectionViewCell.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类
#import "DinersShopingCartView.h"
#import "UserLoginStateObject.h"
#import "OrderDataEntity.h"



@interface DinersRecipeViewController () <ParabolaToolDelegate>
{
    RestaurantMenuLeftView *_leftView;
    
    DinersRecipeTopView *_topView;
    
    DinersRecipeBottomView *_bottomView;
    
    /**
     *  显示购物车视图
     */
    DinersShopingCartView *_shopingCartView;
    
    /**
     *  是否显示购物车视图
     */
    BOOL _isShowCartView;
    
    /**
     *  是否允许加入购物车。YES表示可以。NO不可以
     */
    BOOL _isAddSub;
}

@property (nonatomic, strong) SYFireworksButton *shoppingCar;

@property (nonatomic, strong) UIImageView *redView;

/**
 *  当前选择的菜品分类数据
 */
@property (nonatomic, strong) ShopFoodCategoryDataEntity *selectedCategoryEntity;

/**
 *  当前添加的菜品
 */
@property (nonatomic, strong) ShopFoodDataEntity *currentSelectFoodEntity;

/**
 *  当前从购物车中添加的
 */
@property (nonatomic, strong) ShopingCartEntity *currentSelectCartEntity;

/**
 *  1表示从菜品中添加的；2表示从购物车中添加的
 */
@property (nonatomic, assign) NSInteger addorSubType;

- (void)initWithLeftView;

- (void)initWithTopView;

- (void)initWithBottomView;

- (void)initWithShoppingCar;

/**
 *  点击购物车
 *
 *  @param sender sender
 */
- (void)clickedShopCart:(id)sender;

/**
 *  显示购物车的视图
 *
 *  @param show YES表示；NO隐藏
 */
- (void)showWithShopingCartView:(BOOL)show;

@end

@implementation DinersRecipeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ParabolaTool sharedTool].delegate = self;
}

- (void)initWithVar
{
    [super initWithVar];
    
    self.selectedCategoryEntity = [self.cateList objectOrNilAtIndex:0];
    
    _isShowCartView = YES;
    
    _isAddSub = YES;
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"点菜";
    
//    UIImage *image = [UIImage imageNamed:@"book_btn_phone"];
//    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    UIButton *btnPhone = [TYZCreateCommonObject createWithButton:self imgNameNor:@"book_btn_phone" imgNameSel:@"book_btn_phone" targetSel:@selector(clickedCallPhone:)];
//    btnPhone.frame = frame;
//    UIBarButtonItem *itemPhone = [[UIBarButtonItem alloc] initWithCustomView:btnPhone];
//    self.navigationItem.rightBarButtonItem = itemPhone;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    [self hiddenHeaderView:YES];
    
    [self initWithLeftView];
    
    [self initWithTopView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(_topView.left, _topView.bottom, _topView.width, [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - kDinersRecipeBottomViewHeight - _topView.height);
    self.baseCollectionView.frame = frame;
//    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.baseCollectionView registerClass:[DinersRecipeCollectionViewCell class] forCellWithReuseIdentifier:[DinersRecipeCollectionViewCell cellIdentifier]];
    
    [self initWithBottomView];
    
    [self.view addSubview:self.redView];
    
    [self initWithShoppingCar];
    
    [ParabolaTool sharedTool].delegate = self;
    
    [self choiceWithFoodCategory:_selectedCategoryEntity];
    
    // 显示购物车的数量
    [self shopingCartCount];
    
    // 显示购物车的总金额
    [_bottomView updateViewData:_shopingCartList];
}

- (void)clickedBack:(id)sender
{
    if (_reservationInputEntity.addType == 1 && _reservationInputEntity.userType == 0)
    {// 点菜、食客
        debugLog(@"点菜、食客");
        if (_reservationInputEntity.type == 1)
        {// 预订就餐
            [UtilityObject saveCacheDataLocalKey:kCacheBookingShopingCartData saveFilename:kCacheBookingShopingCartFileName saveid:_shopingCartList];
        }
        else if (_reservationInputEntity.type == 2)
        {// 即时就餐
            [UtilityObject saveCacheDataLocalKey:kCacheInstantShopingCartData saveFilename:kCacheInstantShopingCartFileName saveid:_shopingCartList];
        }
    }
    [super clickedBack:sender];
}

- (void)initWithLeftView
{
    if (!_leftView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [RestaurantMenuLeftView getMenuLeftViewWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - kDinersRecipeBottomViewHeight);
        _leftView = [[RestaurantMenuLeftView alloc] initWithFrame:frame];
        _leftView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_leftView];
    }
    [_leftView updateViewData:self.cateList];
    [_leftView updateWithSelectedFoodNum:_shopingCartList];
    __weak typeof(self)weakSelf = self;
    _leftView.selectCategoryBlock = ^(id data)
    {
        [weakSelf choiceWithFoodCategory:data];
    };
}

// 左边分类视图
- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(_leftView.right, 0, [[UIScreen mainScreen] screenWidth] - _leftView.width, kDinersRecipeTopViewHeight);
        _topView = [[DinersRecipeTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
}

- (void)initWithBottomView
{
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(0, self.baseCollectionView.bottom, [[UIScreen mainScreen] screenWidth], kDinersRecipeBottomViewHeight);
    _bottomView = [[DinersRecipeBottomView alloc] initWithFrame:frame];
    [self.view addSubview:_bottomView];
    _bottomView.viewCommonBlock = ^(id data)
    {// 选好了
        // 1表示购物车；2表示选好了
        [weakSelf touchWithBottom:2];
    };
//    _bottomView.TouchShopingCartBlock = ^()
//    {// 点击购物车
//        [weakSelf touchWithBottom:1];
//    };
    [_bottomView updateViewData:_shopingCartList];
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
        CGRect frame = CGRectMake((_leftView.width - width) / 2, _leftView.height + (_bottomView.height - height)/2, width, height);
        _shoppingCar = [SYFireworksButton buttonWithType:UIButtonTypeCustom];
        _shoppingCar.backgroundColor = [UIColor clearColor];
        _shoppingCar.frame = frame;
        _shoppingCar.alpha = 1;
//        _shoppingCar.backgroundColor = [UIColor purpleColor];
        //    cart_count
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 1002;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.frame = CGRectMake((_shoppingCar.width - 20) / 2 + +4, (_shoppingCar.height - 20) / 2 - 2, 20, 20);
//        numLabel.text = @"99";
//        numLabel.backgroundColor = [UIColor lightGrayColor];
        //        numLabel.text = [UserInfo shareUserInfo].userInfoModel.cart_count;
//        if (numLabel.text.length ==2)
//        {
            //            numLabel.frame.origin.x = (38-24)/2;
            //            numLabel.width = 24;
//        }
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
 *  拨打餐厅电话
 *
 *  @param sender <#sender description#>
 */
- (void)clickedCallPhone:(id)sender
{
    [MCYPushViewController callWithPhone:self phone:_reservationInputEntity.shopMobile];
}

/**
 *  点击购物车
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
            _shopingCartView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _leftView.height);
//            [_shopingCartView showWithSubView:YES];
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
    [self.baseCollectionView reloadData];
}

/**
 *  抛物线小红点
 *
 *  @return uiimageview
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
 *  加入，或者删除购物车
 */
- (void)addOrSubShopCart
{
    _currentSelectFoodEntity.category_name = _selectedCategoryEntity.name;
    if (self.addorSubType == 1)
    {//   1表示从菜品中添加的
//        debugLog(@"cateId=%d; catname=%@", (int)_currentSelectFoodEntity.category_id, _currentSelectFoodEntity.category_name);
        ShopingCartEntity *cartEnt = [ShopingCartEntity new];
        cartEnt.id = _currentSelectFoodEntity.id;
        cartEnt.category_id = _currentSelectFoodEntity.category_id;
        cartEnt.categoryName = _currentSelectFoodEntity.category_name;
        cartEnt.price = _currentSelectFoodEntity.price;
        cartEnt.activityPrice = _currentSelectFoodEntity.activity_price;
        cartEnt.name = _currentSelectFoodEntity.name;
        cartEnt.number = 1;
        cartEnt.mode = @"";
        cartEnt.taste = @"";
        cartEnt.unit = _currentSelectFoodEntity.unit;
        if (_currentSelectFoodEntity.isAdd)
        {// 加入购物车
            [self addWithShopingCart:cartEnt];
        }
        else
        {// 从购物车删除菜品
            [self removeWithShopingCart:cartEnt];
            _isAddSub = YES;
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
            _isAddSub = YES;
        }
    }
    
    // bottom显示总价
    [_bottomView updateViewData:_shopingCartList];
    // 跟新购物车的数据
    [_shopingCartView updateViewData:_shopingCartList];
    // 刷新
    [self.baseCollectionView reloadData];
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
    
    _isAddSub = YES;
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
        if (ent.id == cartEntity.id && ent.category_id == cartEntity.category_id && [ent.mode isEqualToString:cartEntity.mode] && [ent.taste isEqualToString:cartEntity.taste] && [ent.unit isEqualToString:cartEntity.unit])
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


// 点击选择菜品类型
- (void)choiceWithFoodCategory:(id)data
{
    if (!data)
    {
        return;
    }
    ShopFoodCategoryDataEntity *categoryEnt = data;
    self.selectedCategoryEntity = categoryEnt;
    [_topView updateViewData:categoryEnt];
    [self.baseList removeAllObjects];
    [self.baseList addObjectsFromArray:categoryEnt.foods];
//    [self.baseTableView reloadData];
    [self.baseCollectionView reloadData];
    /*if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
    else
    {
        _emptyView.hidden = YES;
    }*/
}

/**
 *  点解bottom上的按钮
 *
 *  @param type 1表示购物车；2表示选好了
 */
- (void)touchWithBottom:(NSInteger)type
{
    // 完成
    if ([_shopingCartList count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"您还没有点菜！"];
        return;
    }
    if (_reservationInputEntity.addType == 1) // 1表示点餐；2表示加菜
    {
        _reservationInputEntity.orderState = -1;
    }
    _reservationInputEntity.content = [_shopingCartList modelToJSONString];
    _reservationInputEntity.foodList = _shopingCartList;
    
    
    // 进入提交视图控制器
    [MCYPushViewController showWithDinersCreateOrderVC:self data:_reservationInputEntity completion:nil];
}

// 进入菜品详情视图控制器
- (void)showWithFoodDetailVC:(ShopFoodDataEntity *)foodEntity
{
    foodEntity.category_name = _selectedCategoryEntity.name;
    NSMutableArray *addList = [NSMutableArray new];
    for (ShopingCartEntity *cartEnt in _shopingCartList)
    {
        if (cartEnt.id == foodEntity.id)
        {
            [addList addObject:cartEnt];
        }
    }
    [_shopingCartList removeObjectsInArray:addList];
    
    [MCYPushViewController showWithDinersRecipeFoodDetailVC:self data:@(foodEntity.id) shopCartList:foodEntity.shopCartList isBrowse:NO completion:^(id data) {
        [self foodDetailAdd:data];
    }];
}

/**
 *  从菜品详情里面返回来后，更新购物车
 *
 *  @param list <#list description#>
 */
- (void)foodDetailAdd:(NSArray *)list
{
    NSMutableArray *addList = [NSMutableArray new];
    debugLog(@"ent=%d", (int)list.count);
    for (ShopingCartEntity *ent in list)
    {
        for (ShopingCartEntity *entity in _shopingCartList)
        {
            if (ent.id == entity.id && ent.category_id == entity.category_id && [ent.mode isEqualToString:entity.mode] && [ent.taste isEqualToString:entity.taste] && [ent.unit isEqualToString:entity.unit])
            {
                [addList addObject:entity];
            }
        }
        
    }
    [_shopingCartList removeObjectsInArray:addList];
    
    [_shopingCartList addObjectsFromArray:list];
    
    // 显示购物车里的菜品数量
    [self shopingCartCount];
    
    // bottom显示总价
    [_bottomView updateViewData:_shopingCartList];
    
    // 跟新购物车的数据
    [_shopingCartView updateViewData:_shopingCartList];
    
    // 刷新
    [self.baseCollectionView reloadData];
}

// 从购物车视图里面直接添加或者减少
- (void)addOrSubFood:(NSInteger)type button:(id)button cartEnt:(ShopingCartEntity *)cartEnt
{
    self.addorSubType = 2;
    self.currentSelectCartEntity = cartEnt;
//    debugLog(@"type=%d", (int)type);
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
}

/**
 *  添加菜品，删除菜品
 *
 *  @param type   1表示减法；2表示加法；3选择规格；4添加
 *  @param button 按钮
 *  @param food   当前加入购物的菜品
 */
- (void)touchAddSub:(NSInteger)type button:(id)button food:(ShopFoodDataEntity *)food
{
    if (!_isAddSub)
    {
        return;
    }
    self.currentSelectFoodEntity = food;
//    debugLog(@"ent=%@", [food modelToJSONString]);
    self.addorSubType = 1;
    if ([button isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)button;
        if (btn.tag == 100)
        {// 减少
            
            // 食客在就餐过程中是不能减菜的，但是可以减少刚才增加的，尚未提交到服务端的
            _isAddSub = NO; // 加或者减，需要时间。只有YES才可以。
            _currentSelectFoodEntity.isAdd = NO;
            
            // 删除指定的购物车里面的菜品
            [self addOrSubShopCart];
            
        }
        else if (btn.tag == 101 || (btn.tag == 102 && [btn.titleLabel.text isEqualToString:@"添加"]))
        {// 增加
            _isAddSub = NO; // 加或者减，需要时间。只有YES才可以。
            _currentSelectFoodEntity.isAdd = YES;
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
        else if (btn.tag == 102 && [btn.titleLabel.text isEqualToString:@"可选规格"])
        {
            [self showWithFoodDetailVC:food];
            self.currentSelectFoodEntity = nil;
        }
    }
}

/**
 *  得到这个菜品在购物车中的数量
 *
 *  @param foodEnt 菜品
 *
 *  @return <#return value description#>
 */
- (NSArray *)getWithFoodNum:(ShopFoodDataEntity *)foodEnt
{
    NSMutableArray *addList = [NSMutableArray new];
    for (ShopingCartEntity *cartEnt in _shopingCartList)
    {
        if (cartEnt.id == foodEnt.id && cartEnt.category_id == foodEnt.category_id)
        {
            [addList addObject:cartEnt];
        }
    }
    return addList;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    DinersRecipeCollectionViewCell *cell = [DinersRecipeCollectionViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    ShopFoodDataEntity *foodEnt = self.baseList[indexPath.row];
    if (!foodEnt.shopCartList)
    {
        foodEnt.shopCartList = [NSMutableArray array];
    }
    [foodEnt.shopCartList removeAllObjects];
    [foodEnt.shopCartList addObjectsFromArray:[self getWithFoodNum:foodEnt]];
    [cell updateViewCell:foodEnt];
    cell.touchAddSubBlock = ^(NSInteger type, id button, id data)
    {// 1表示减法；2表示加法；3选择规格；4添加
        [weakSelf touchAddSub:type button:button food:data];
    };
    return cell;
}

/** 设置元素的大小框  定义每个UICollectionView 的 margin */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    UIEdgeInsets top = UIEdgeInsetsMake(10, 5, 10, 5);
    return top;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

/** 设置元素大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake([DinersRecipeCollectionViewCell getWithCellWidth], [DinersRecipeCollectionViewCell getWithCellHeight]);
    return size;
}

/** 设置顶部的大小 */
/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
 {
 CGSize size = CGSizeMake(SCREEN_WIDTH, 30);
 if (section == 0)
 {
 size = CGSizeMake(SCREEN_WIDTH, 170);
 }
 return size;
 }*/

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(0, 0);
//}

/** item是否高亮显示 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/** 返回item是否可以被选择 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/** 点击元素出发事件 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ShopFoodDataEntity *foodEnt = self.baseList[indexPath.row];
    
    if (foodEnt.state != 0)
    {
        return;
    }
    
    [self showWithFoodDetailVC:foodEnt];
}


@end























