//
//  TestRefreshCollectionViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TestRefreshCollectionViewController.h"
#import "TYZKit.h"

/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@implementation TestRefreshCollectionViewController

- (void)dealloc
{
    debugMethod();
}

- (void)initWithSubView
{
    [super initWithSubView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.baseCollectionView registerClass:[TYZBaseCollectionViewCell class] forCellWithReuseIdentifier:[TYZBaseCollectionViewCell cellIdentifier]];
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (void)doMoreRefreshData
{
    [super doMoreRefreshData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
    
}

- (void)reloadData
{
    for (int i = 0; i<10; i++)
    {
        [self.baseList insertObject:MJRandomColor atIndex:0];
    }
    [self.baseCollectionView reloadData];
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
    TYZBaseCollectionViewCell *cell = [TYZBaseCollectionViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    cell.backgroundColor = self.baseList[indexPath.row];
    return cell;
}
/** 设置元素的大小框  定义每个UICollectionView 的 margin */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = UIEdgeInsetsMake(8, 8, 8, 8);
    return top;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

/** 设置元素大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = ([[UIScreen mainScreen] screenWidth] - 10 *2 - 12*2)/3;
    CGSize size = CGSizeMake(width, ([[UIScreen mainScreen] screenHeight]-64)/3);
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

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
}





@end
