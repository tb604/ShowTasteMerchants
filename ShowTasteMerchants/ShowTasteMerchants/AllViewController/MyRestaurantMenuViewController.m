//
//  MyRestaurantMenuViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMenuViewController.h"
#import "LocalCommon.h"
#import "RestaurantMenuLeftView.h"
#import "MyRestaurantMenuTopView.h"
#import "RestaurantMenuContentCell.h"
#import "MyRestaurantMenuNoBgView.h"
#import "UserLoginStateObject.h"
#import "ShopFoodCategoryDataEntity.h"
#import "MyRestaurantMenuFoodViewCell.h"


@interface MyRestaurantMenuViewController ()
{
    RestaurantMenuLeftView *_leftView;
    
    MyRestaurantMenuTopView *_topView;
    
    /**
     *  当没有数据的时候，显示的视图
     */
    MyRestaurantMenuNoBgView *_emptyView;
    
    /**
     *  0表示我的餐厅的菜单；1表示餐厅详情里面的推荐的更多菜品
     */
    NSInteger _type;
}

@property (nonatomic, strong) ShopFoodCategoryDataEntity *selectedCategoryEntity;


- (void)initWithLeftView;

- (void)initWithTopView;

- (void)initWithEmptyView;

- (void)getShopMenuData;

/**
 *  切换餐厅后的通知
 *
 *  @param note note
 */
- (void)changeWithShopNote:(NSNotification *)note;

@end

@implementation MyRestaurantMenuViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCHANGE_SHOP_NOTE object:nil];
}

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
    
    _type = 1;
    if (!_menuList)
    {
        _type = 0;
        _menuList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWithShopNote:) name:kCHANGE_SHOP_NOTE object:nil];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    UIImage *image = [UIImage imageNamed:@"data_btn_edit"];
    UIButton *btnEdit = [TYZCreateCommonObject createWithButton:self imgNameNor:@"data_btn_edit" imgNameSel:@"data_btn_edit" targetSel:@selector(clickedWithEdit:)];
    btnEdit.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBarButtonItem *itemEdit = [[UIBarButtonItem alloc] initWithCustomView:btnEdit];
    self.navigationItem.rightBarButtonItem = itemEdit;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithLeftView];
    
    [self initWithTopView];
    
    CGRect frame = CGRectMake(_leftView.right, _topView.bottom, _topView.width, _leftView.height - _topView.height);
    self.baseCollectionView.frame = frame;
    [self.baseCollectionView registerClass:[MyRestaurantMenuFoodViewCell class] forCellWithReuseIdentifier:[MyRestaurantMenuFoodViewCell cellIdentifier]];
    
    [self initWithEmptyView];
    
    if ([_menuList count] != 0)
    {
        
        [_leftView updateViewData:_menuList];
        ShopFoodCategoryDataEntity *categoryEnt = [_menuList objectOrNilAtIndex:0];
        if (!categoryEnt.foods)
        {
            categoryEnt.foods = [NSMutableArray array];
        }
        
        [self choiceWithFoodCategory:categoryEnt];
        
        _emptyView.hidden = YES;
    }
    else
    {
        _emptyView.hidden = NO;
    }
}

- (void)initWithLeftView
{
    if (!_leftView)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, 0, [RestaurantMenuLeftView getMenuLeftViewWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight]*2 - STATUSBAR_HEIGHT);
        if (_type == 1)
        {
            frame.size.height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT;
        }
        _leftView = [[RestaurantMenuLeftView alloc] initWithFrame:frame];
        _leftView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_leftView];
    }
    __weak typeof(self)weakSelf = self;
    _leftView.selectCategoryBlock = ^(id data)
    {
        [weakSelf choiceWithFoodCategory:data];
    };
}

- (void)initWithTopView
{
    if (!_topView)
    {
        CGRect frame = CGRectMake(_leftView.right, 0, [[UIScreen mainScreen] screenWidth] - _leftView.width, kMyRestaurantMenuTopViewHeight);
        _topView = [[MyRestaurantMenuTopView alloc] initWithFrame:frame];
        [self.view addSubview:_topView];
        [_topView updateViewData:nil];
    }
}

- (void)initWithEmptyView
{
    CGFloat width = [[UIScreen mainScreen] screenWidth] - _leftView.width;
    CGFloat height = self.baseCollectionView.height;
    CGRect frame = CGRectMake((width - [MyRestaurantMenuNoBgView getWithMenuNoBgViewWidth])/2 + _leftView.right, (height-[MyRestaurantMenuNoBgView getWithMenuNoBgViewHeight])/2 + _topView.bottom, [MyRestaurantMenuNoBgView getWithMenuNoBgViewWidth], [MyRestaurantMenuNoBgView getWithMenuNoBgViewHeight]);
    _emptyView = [[MyRestaurantMenuNoBgView alloc] initWithFrame:frame];
    [self.view addSubview:_emptyView];
}

- (void)doRefreshData
{
    if ([_menuList count] == 0)
    {
        [self getShopMenuData];
    }
}

/// 编辑
- (void)clickedWithEdit:(id)sender
{
    [MCYPushViewController showWithResaurantMenuEditVC:self data:self.menuList completion:^(id data) {
        [self addEditMenu:data];
    }];
}

- (void)changeWithShopNote:(NSNotification *)note
{
    [self getShopMenuData];
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
        ShopFoodCategoryDataEntity *categoryEnt = [_menuList objectOrNilAtIndex:0];
        if (!categoryEnt.foods)
        {
            categoryEnt.foods = [NSMutableArray array];
        }
        
        [self choiceWithFoodCategory:categoryEnt];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
        if ([self.menuList count] != 0)
        {
            _emptyView.hidden = YES;
        }
        else
        {
            _emptyView.hidden = NO;
        }

    }
}


- (void)addEditMenu:(NSArray *)list
{
    [self.menuList removeAllObjects];
    [self.menuList addObjectsFromArray:list];
    [_leftView updateViewData:_menuList];
    
    for (ShopFoodCategoryDataEntity *ent in _menuList)
    {
        if (ent.id == _selectedCategoryEntity.id)
        {
            [_topView updateViewData:ent];
            [self choiceWithFoodCategory:ent];
            break;
        }
    }
    
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
//    __weak typeof(self)weakSelf = self;
    MyRestaurantMenuFoodViewCell *cell = [MyRestaurantMenuFoodViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    [cell updateViewCell:self.baseList[indexPath.row]];
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
    RestaurantMenuContentCell *cell = [RestaurantMenuContentCell cellForTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateCellData:self.baseList[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [RestaurantMenuContentCell getWithMenuContentCellHeight];
    return height;
}*/


@end
