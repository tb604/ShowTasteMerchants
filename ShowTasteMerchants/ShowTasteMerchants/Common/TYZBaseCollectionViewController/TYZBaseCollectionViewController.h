//
//  TYZBaseCollectionViewController.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseViewController.h"
#import "TYZBaseCollectionViewCell.h"

@interface TYZBaseCollectionViewController : TYZBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *baseList;
@property (nonatomic, strong) UICollectionView *baseCollectionView;

- (void)initWithBasicCollectionView;

@end




























