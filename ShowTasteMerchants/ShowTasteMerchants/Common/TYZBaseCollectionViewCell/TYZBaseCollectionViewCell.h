//
//  TYZBaseCollectionViewCell.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^baseCollectionCellBlock)(id data);

/*** 初始化本视图 */
+ (id)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)cellIdentifier;

/*** 初始化视图里面的变量 */
- (void)initWithVarCell;

/*** 初始化子视图 */
- (void)initWithSubViewCell;

- (void)updateViewCell:(id)cellEntity;



+ (NSInteger)getWithCellWidth;

+ (NSInteger)getWithCellHeight;

@end
