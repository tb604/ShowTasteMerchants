//
//  OMNearShopViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMNearShopViewController.h"
#import "LocalCommon.h"
#import "OMNearShopViewCell.h"
#import "OrderMealContentEntity.h"

@interface OMNearShopViewController ()

- (void)getWithNearShopList;

@end

@implementation OMNearShopViewController

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
    
    [self.baseList addObjectsFromArray:_list];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"附近精选";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.baseCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.baseCollectionView registerClass:[OMNearShopViewCell class] forCellWithReuseIdentifier:[OMNearShopViewCell cellIdentifier]];
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getWithNearShopList];
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    
    [self getWithNearShopList];
}


- (void)getWithNearShopList
{
    [self endAllRefreshing];
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
    OMNearShopViewCell *cell = [OMNearShopViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    [cell updateViewCell:self.baseList[indexPath.row]];
    return cell;
}

/** 设置元素的大小框  定义每个UICollectionView 的 margin */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    UIEdgeInsets top = UIEdgeInsetsMake(15, 15, 10, 15);
    // UIEdgeInsetsMake(10, 5, 10, 5);
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
    CGSize size = CGSizeMake([OMNearShopViewCell getWithCellWidth], [OMNearShopViewCell getWithCellHeight]);
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
    OrderMealContentEntity *entity = self.baseList[indexPath.row];
    [MCYPushViewController showWithShopDetailVC:self data:entity completion:nil];
    
}


@end











