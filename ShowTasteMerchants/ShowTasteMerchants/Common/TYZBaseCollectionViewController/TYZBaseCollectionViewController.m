//
//  TYZBaseCollectionViewController.m
//  51tourGuide
//
//  Created by 唐斌 on 16/3/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseCollectionViewController.h"


@interface TYZBaseCollectionViewController ()

@end

@implementation TYZBaseCollectionViewController

- (void)dealloc
{
    _baseCollectionView.delegate = nil;
    _baseCollectionView.dataSource = nil;
#if !__has_feature(objc_arc)
    [_baseList release], _baseList = nil;
    [_baseCollectionView release], _baseCollectionView = nil;
    [super dealloc];
#endif
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

- (void)initWithVar
{
    [super initWithVar];
    
    _baseList = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBasicCollectionView];
}


- (void)initWithBasicCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5.0;
    flowLayout.minimumLineSpacing = 5.0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    static CGFloat statusHeight;
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [[UIScreen mainScreen] bounds];
        statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    });
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    //    NSLog(@"statusHeight=%.2f; navBarHeight=%.2f", statusHeight, navBarHeight);
    CGRect frame = CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height - statusHeight - navBarHeight);
    
    _baseCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _baseCollectionView.backgroundView = nil;
    _baseCollectionView.backgroundColor = [UIColor clearColor];
    _baseCollectionView.alwaysBounceVertical = YES;
    _baseCollectionView.delegate = self;
    _baseCollectionView.dataSource = self;
    [self.view addSubview:_baseCollectionView];
#if !__has_feature(objc_arc)
    [flowLayout release], flowLayout = nil;
#endif
}

#pragma mark start UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [_baseList count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TYZBaseCollectionViewCell *cell = [TYZBaseCollectionViewCell cellForCollectionView:collectionView forIndexPath:indexPath];
    return cell;
}
#pragma mark end UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

@end





























