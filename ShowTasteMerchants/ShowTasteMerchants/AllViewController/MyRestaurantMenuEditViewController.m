//
//  MyRestaurantMenuEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMenuEditViewController.h"
#import "LocalCommon.h"
#import "RestaurantMenuLeftView.h"
#import "RestaurantMenuTopView.h"
#import "RestaurantMenuBottomView.h"
#import "EmptyDishesView.h"
#import "RestaurantMenuContentCell.h"
#import "UserLoginStateObject.h"
#import "ShopFoodCategoryDataEntity.h"
#import "MyRestaurantMenuFoodViewCell.h"

@interface MyRestaurantMenuEditViewController () <UIActionSheetDelegate>
{
    RestaurantMenuLeftView *_leftView;
    
    /**
     *  菜品类型的编辑
     */
    UIActionSheet *_leftActionSheet;
    
    UIActionSheet *_foodActionSheet;
    
    RestaurantMenuTopView *_topView;
    
    RestaurantMenuBottomView *_bottomView;
    
    /**
     *  当没有数据的时候，显示的视图
     */
    EmptyDishesView *_emptyView;
}

@property (nonatomic, strong) UIActionSheet *leftActionSheet;

/**
 *  是否左边编辑
 */
//@property (nonatomic, assign) BOOL isLeftEdit;

/**
 *  当前选择中分类
 */
@property (nonatomic, strong) ShopFoodCategoryDataEntity *selectedCategoryEntity;

/**
 *  长按的分类
 */
@property (nonatomic, strong) ShopFoodCategoryDataEntity *longPressCategoryEnt;

/**
 *  长按菜品
 */
@property (nonatomic, strong) ShopFoodDataEntity *longPressFoodEntity;

- (void)initWithLeftView;

- (void)initWithLeftActionSheet;

- (void)initWithFoodActionSheet:(BOOL)onLine;

- (void)initWithTopView;

- (void)initWithBottomView;

- (void)initWithEmptyView;

@end

@implementation MyRestaurantMenuEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"菜单菜品";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLeftView];
    
//    [self initWithLeftActionSheet];
    
//    [self initWithFoodActionSheet];
    
    [self initWithTopView];
    
    [self initWithBottomView];
    
    CGRect frame = CGRectZero;
    frame.origin.x = _leftView.right;
    frame.origin.y = _topView.bottom;
    frame.size.width = [[UIScreen mainScreen] screenWidth] - _leftView.width;
    frame.size.height = _leftView.height - _topView.height;
    self.baseCollectionView.frame = frame;
    
    [self.baseCollectionView registerClass:[MyRestaurantMenuFoodViewCell class] forCellWithReuseIdentifier:[MyRestaurantMenuFoodViewCell cellIdentifier]];
    
    [self initWithEmptyView];
    
    if ([_menuList count] == 0)
    {
//        debugLog(@"if");
        [self getShopMenuData];
    }
    else
    {
//        debugLog(@"else");
        TYZRespondDataEntity *result = [TYZRespondDataEntity new];
        result.errcode = respond_success;
        result.data = [NSArray arrayWithArray:_menuList];
        [self responseWithFoodCategoryDetails:result];
    }
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_menuList);
    }
    [super clickedBack:sender];
}

- (void)initWithLeftView
{
    if (!_leftView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [RestaurantMenuLeftView getMenuLeftViewWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT);
        _leftView = [[RestaurantMenuLeftView alloc] initWithFrame:frame];
        [self.view addSubview:_leftView];
        __weak typeof(self)weakSelf = self;
        _leftView.viewCommonBlock = ^(id data)
        {// 长按钮
            [weakSelf leftViewLongPressGesture:data];
        };
        _leftView.selectCategoryBlock = ^(id data)
        {// 选择菜品类型
            [weakSelf choiceWithFoodCategory:data];
        };
    }
}

// 点击选择菜品类型
- (void)choiceWithFoodCategory:(id)data
{
    debugMethod();
    if (!data)
    {
        return;
    }
    ShopFoodCategoryDataEntity *categoryEnt = data;
    self.selectedCategoryEntity = categoryEnt;
    debugLog(@"state=%d", (int)categoryEnt.state);
    [_topView updateViewData:categoryEnt];
    [self.baseList removeAllObjects];
    [self.baseList addObjectsFromArray:categoryEnt.foods];
    [self.baseCollectionView reloadData];
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
    else
    {
        _emptyView.hidden = YES;
    }
}

// 菜品分类
- (void)initWithLeftActionSheet
{
    _leftActionSheet.delegate = nil;
    self.leftActionSheet = nil;
    if (_selectedCategoryEntity.state == 0)
    {// 有效
        _leftActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"下架", nil];
    }
    else
    {
        _leftActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"上架", nil];
    }
    
    _leftActionSheet.tag = 100;
    
    [_leftActionSheet showInView:self.view];
}

- (void)initWithFoodActionSheet:(BOOL)onLine
{
    if (onLine)
    {//在线上
        _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"菜品下架", nil];
    }
    else
    {
        _foodActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑", @"菜品上架", nil];
    }
    _foodActionSheet.tag = 101;
}

/**
 *  菜品类型
 *
 *  @param buttonIdex <#buttonIdex description#>
 */
- (void)footTypeSheet:(NSInteger)buttonIdex title:(NSString *)title
{
    
    if ([title isEqualToString:@"编辑"])
    {// 编辑
        ShopFoodCategoryInputEntity *editCategoryEnt = [ShopFoodCategoryInputEntity new];
        editCategoryEnt.shopid = _longPressCategoryEnt.shop_id;
        editCategoryEnt.name = _longPressCategoryEnt.name;
        editCategoryEnt.categoryId = _longPressCategoryEnt.id;
        editCategoryEnt.remark = _longPressCategoryEnt.remark;
        editCategoryEnt.isAdd = NO;
        [MCYPushViewController showWithRestaurantAddFoodCategoryVC:self data:editCategoryEnt completion:^(id data) {
            [self addEditCategory:data];
        }];
    }
    else if ([title isEqualToString:@"排序"])
    {// 排序
        
    }
    else if ([title isEqualToString:@"上架"])
    {// longPressCategoryEnt
        [SVProgressHUD showWithStatus:@"提交中"];
        [HCSNetHttp requestWithFoodCategoryPublish:_longPressCategoryEnt.id shopId:_longPressCategoryEnt.shop_id completion:^(id result) {
            
        }];
    }
    else if ([title isEqualToString:@"下架"])
    {
        [SVProgressHUD showWithStatus:@"提交中"];
        [HCSNetHttp requestWithFoodCategoryOffline:_longPressCategoryEnt.id shopId:_longPressCategoryEnt.shop_id completion:^(id result) {
            
        }];
    }
    
    /*if (buttonIdex == 0)
    {// 菜品类型编辑
        
    }
    else if (buttonIdex == 1)
    {// 编辑
        
    }
    else if (buttonIdex == 2)
    {// 删除
        NSInteger count = 0;//[_longPressCategoryEnt.foods count];
        // 0在线；1下架；2删除
//        ShopFoodDataEntity
        for (ShopFoodDataEntity *foodEnt in _longPressCategoryEnt.foods)
        {
            if (foodEnt.state == 0)
            {
                count += 1;
                break;
            }
        }
        
        if (count != 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请先下架对应的菜品！"];
            return;
        }
        
        // 删除菜品分类
        [SVProgressHUD showWithStatus:@"删除中"];
        [HCSNetHttp requestWithFoodCategoryDelete:_longPressCategoryEnt.id shopId:_longPressCategoryEnt.shop_id completion:^(id result) {
            [self responseWithFoodCategoryDelete:result];
        }];
     
    }*/
}

/**
 *  菜品分类上架后，返回结果
 *
 *  @param respond <#respond description#>
 */
- (void)responseWithFoodCategoryPublish:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"上架成功"];
        
        for (ShopFoodCategoryDataEntity *categoryEnt in _menuList)
        {
            if (categoryEnt.id == _longPressCategoryEnt.id)
            {
                categoryEnt.state = 1;
                break;
            }
        }
        [_leftView updateViewData:_menuList];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  菜品分类下架后，返回结果
 *
 *  @param respond <#respond description#>
 */
- (void)requestWithFoodCategoryOffline:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"下架成功"];
        for (ShopFoodCategoryDataEntity *categoryEnt in _menuList)
        {
            if (categoryEnt.id == _longPressCategoryEnt.id)
            {
                categoryEnt.state = 1;
                for (ShopFoodDataEntity *foodEnt in categoryEnt.foods)
                {
                    foodEnt.state = 1;
                }
                
                break;
            }
        }
        [_leftView updateViewData:_menuList];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  删除菜品分类，返回结果
 *
 *  @param respond <#respond description#>
 */
/*- (void)responseWithFoodCategoryDelete:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        
        NSInteger index = -1;
        for (NSInteger i=0; i<[_menuList count]; i++)
        {
            ShopFoodCategoryDataEntity *categoryEnt = _menuList[i];
            if (_longPressCategoryEnt.id == categoryEnt.id)
            {
                index = i;
                break;
            }
        }
        if (index != -1)
        {
            [_menuList removeObjectAtIndex:index];
        }
        BOOL isReset = NO; // 是否重置，如果删除的菜品类型，是当前选择的，删除后，默认显示第一个。
        if (_longPressCategoryEnt.id == _selectedCategoryEntity.id)
        {
            isReset = YES;
            ShopFoodCategoryDataEntity *ent = [_menuList objectOrNilAtIndex:0];
            [self choiceWithFoodCategory:ent];
        }
        [_leftView updateViewData:_menuList isReset:isReset];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}*/

/**
 *  菜品
 *
 *  @param buttonIndex button description
 */
- (void)footSheet:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        // 右边菜品编辑
        [MCYPushViewController showWithRestaurantAddFoodVC:self data:_menuList type:2 foodEntity:_longPressFoodEntity completion:^(id data) {
            [self addWithFoodInfo:data type:2];
        }];
    }
    else if (buttonIndex == 1)
    {// 上架、下架
        if (_longPressFoodEntity.state == 0)
        {// 原来线上，现在下架
            [SVProgressHUD showWithStatus:@"下架中"];
            [HCSNetHttp requestWithFoodOffline:_longPressFoodEntity.id shopId:_longPressFoodEntity.shop_id completion:^(id result) {
                [self responseWithFoodOffline:result];
            }];
        }
        else if (_longPressFoodEntity.state == 1)
        {// 原来是下架，现在要上架
            [SVProgressHUD showWithStatus:@"上架中"];
            [HCSNetHttp requestWithFoodPublish:_longPressFoodEntity.id shopId:_longPressFoodEntity.shop_id completion:^(id result) {
                [self responseWithFoodPublish:result];
            }];
        }
    }
}

// 下架返回结果
- (void)responseWithFoodOffline:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"下架成功"];
        _longPressFoodEntity.state = 1;
        [self onOrOffLine];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 上架返回结果
- (void)responseWithFoodPublish:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"上架成功"];
        _longPressFoodEntity.state = 0;
        [self onOrOffLine];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)onOrOffLine
{
    for (ShopFoodDataEntity *foodEnt in _selectedCategoryEntity.foods)
    {
        if (foodEnt.id == _longPressFoodEntity.id)
        {
            foodEnt.state = _longPressFoodEntity.state;
            break;
        }
    }
    [self choiceWithFoodCategory:_selectedCategoryEntity];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (actionSheet.tag == 100)
        {// 菜品类型
            NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
            debugLog(@"title=%@", title);
            [self footTypeSheet:buttonIndex title:title];
        }
        else if (actionSheet.tag == 101)
        {// 菜品
            [self footSheet:buttonIndex];
        }
    }
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(_leftView.right, 0, [[UIScreen mainScreen] screenWidth] - _leftView.width, 30);
        _topView = [[RestaurantMenuTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
    }
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, _leftView.bottom, [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[RestaurantMenuBottomView alloc] initWithFrame:frame];
        [self.view addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        [weakSelf clickedBottom:data];
    };
}

// 添加类别、菜品
- (void)clickedBottom:(id)data
{
    NSInteger tag = [data integerValue];
    if (tag == 100)
    {// 添加类别
        ShopFoodCategoryInputEntity *addCategoryEnt = [ShopFoodCategoryInputEntity new];
        addCategoryEnt.shopid = [UserLoginStateObject getCurrentShopId];
        addCategoryEnt.isAdd = YES;
        [MCYPushViewController showWithRestaurantAddFoodCategoryVC:self data:addCategoryEnt completion:^(id data) {
            [self addEditCategory:data];
        }];
    }
    else if (tag == 101)
    {// 添加菜品
        // type 1表示添加；2表示修改
        [MCYPushViewController showWithRestaurantAddFoodVC:self data:_menuList type:1 foodEntity:nil completion:^(id data) {
            [self addWithFoodInfo:data type:1];
        }];
    }
}

/**
 *  添加或者修改类型
 *
 *  @param categoryEnt <#categoryEnt description#>
 */
- (void)addEditCategory:(ShopFoodCategoryDataEntity *)categoryEnt
{
    if (categoryEnt.isAdd)
    {// 添加
        categoryEnt.foods = [NSMutableArray array];
        [_menuList addObject:categoryEnt];
    }
    else
    {// 修改
        for (ShopFoodCategoryDataEntity *oldCategoryEnt in _menuList)
        {
            if (oldCategoryEnt.id == categoryEnt.id)
            {
                oldCategoryEnt.name = categoryEnt.name;
                oldCategoryEnt.remark = categoryEnt.remark;
                break;
            }
        }
    }
    [_leftView updateViewData:_menuList];
    for (ShopFoodCategoryDataEntity *ent in _menuList)
    {
        if (ent.id == _selectedCategoryEntity.id)
        {
            self.selectedCategoryEntity = ent;
            [_topView updateViewData:ent];
            break;
        }
    }
}

/**
 *  添加菜品后，返回
 *
 *  @param data 添加的菜品信息
 *  @param type 1表示添加；2表示编辑
 */
- (void)addWithFoodInfo:(id)data type:(NSInteger)type
{
    ShopFoodDataEntity *foodEntity = data;
//    debugLog(@"foodEnt=%@", [foodEntity modelToJSONString]);
    
    for (ShopFoodCategoryDataEntity *categoryEnt in _menuList)
    {
        if (categoryEnt.id == foodEntity.category_id)
        {
//            debugLog(@"分类相同");
            if (type == 1)
            {// 添加
//                debugLog(@"添加");
                if (!categoryEnt.foods)
                {
                    categoryEnt.foods = [NSMutableArray array];
                }
                [categoryEnt.foods addObject:foodEntity];
            }
            else
            {// 修改
                NSInteger index = -1;
                for (NSInteger i=0; i<[categoryEnt.foods count]; i++)
                {
                    ShopFoodDataEntity *oldEnt = categoryEnt.foods[i];
                    if (oldEnt.id == foodEntity.id)
                    {
                        index = i;
                        break;
                    }
                }
                if (index != -1)
                {
                    [categoryEnt.foods removeObjectAtIndex:index];
                    [categoryEnt.foods insertObject:foodEntity atIndex:index];
                }
            }
            
            if (categoryEnt.id == _selectedCategoryEntity.id)
            {
//                debugLog(@"跟当前的相同");
                [self choiceWithFoodCategory:categoryEnt];
            }
            
            break;
        }
    }
    
    [self.baseCollectionView reloadData];
}

- (void)initWithEmptyView
{
    CGFloat width = [[UIScreen mainScreen] screenWidth] - _leftView.width;
    CGFloat height = _bottomView.top - _topView.bottom;
    CGRect frame = CGRectMake((width - [EmptyDishesView getWithViewWidth])/2 + _leftView.right, (height-[EmptyDishesView getWithViewHeight])/2 + _topView.bottom, [EmptyDishesView getWithViewWidth], [EmptyDishesView getWithViewHeight]);
    _emptyView = [[EmptyDishesView alloc] initWithFrame:frame];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = YES;
}

// 长按，菜品类型
- (void)leftViewLongPressGesture:(id)foodCagegory
{
//    _isLeftEdit = YES;
    
    ShopFoodCategoryDataEntity *categoryEnt = foodCagegory;
    if (categoryEnt.type == 2)
    {
        self.longPressCategoryEnt = foodCagegory;
//        [_leftActionSheet showInView:self.view];
        [self initWithLeftActionSheet];
    }
}

// 长按，菜品信息
- (void)longPressFoodInfo:(id)foodEntity
{
    self.longPressFoodEntity = foodEntity;
    
//    ShopFoodDataEntity
    if (_longPressFoodEntity.state == 0)
    {// 线上
        [self initWithFoodActionSheet:YES];
    }
    else if (_longPressFoodEntity.state == 1)
    {// 下架了
        [self initWithFoodActionSheet:NO];
    }
    [_foodActionSheet showInView:self.view];
}

- (void)getShopMenuData
{
    [HCSNetHttp requestWithFoodCategoryGetFoodCategoryDetails:[UserLoginStateObject getCurrentShopId] completion:^(id result) {
        [self responseWithFoodCategoryDetails:result];
    }];
}

- (void)responseWithFoodCategoryDetails:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [_menuList removeAllObjects];
        [_menuList addObjectsFromArray:respond.data];
        [_leftView updateViewData:_menuList];
        
        [self choiceWithFoodCategory:[_menuList objectOrNilAtIndex:0]];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
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
    MyRestaurantMenuFoodViewCell *cell = [MyRestaurantMenuFoodViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    [cell updateViewCell:self.baseList[indexPath.row]];
    cell.baseCollectionCellBlock = ^(id data)
    {
        [weakSelf longPressFoodInfo:data];
    };
    return cell;
}

/** 设置元素的大小框  定义每个UICollectionView 的 margin */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
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
    CGSize size = CGSizeMake([MyRestaurantMenuFoodViewCell getWithCellWidth], [MyRestaurantMenuFoodViewCell getWithCellHeight]);
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
    
    //    ShopFoodDataEntity *foodEnt = self.baseList[indexPath.row];
    //    [self showWithFoodDetailVC:foodEnt];
}


/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.baseList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    RestaurantMenuContentCell *cell = [RestaurantMenuContentCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.row]];
    cell.baseTableViewCellBlock = ^(id data)
    {// 长按
        [weakSelf longPressFoodInfo:data];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [RestaurantMenuContentCell getWithMenuContentCellHeight];
    return height;
}*/

@end
