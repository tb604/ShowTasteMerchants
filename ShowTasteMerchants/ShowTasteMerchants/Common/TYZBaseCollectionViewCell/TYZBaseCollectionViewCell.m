//
//  TYZBaseCollectionViewCell.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/14.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseCollectionViewCell.h"

@implementation TYZBaseCollectionViewCell
- (void)dealloc
{
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVarCell];
        
        [self initWithSubViewCell];
    }
    return self;
}

/*** 初始化本视图 */
+ (id)cellForCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [self cellIdentifier];
    //    PRPLog(@"cellID=%@", cellID);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    return cell;
}

+ (NSString *)cellIdentifier
{
    return NSStringFromClass([self class]);
}

/*** 初始化视图里面的变量 */
- (void)initWithVarCell
{
    //    PRPLog(@"%s", __FUNCTION__);
}

/*** 初始化子视图 */
- (void)initWithSubViewCell
{
    //    PRPLog(@"%s", __FUNCTION__);
}

- (void)updateViewCell:(id)cellEntity
{
    
}

+ (NSInteger)getWithCellWidth
{
    return 0;
}

+ (NSInteger)getWithCellHeight
{
    return 0;
}

@end
