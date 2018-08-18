//
//  MyRestaurantMouthEditFoodCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantMouthEditFoodCell.h"
#import "LocalCommon.h"
#import "MyRestaurantMouthArchiveFoodView.h"
#import "MyRestaurantMouthUnrchiveFoodView.h"

@interface MyRestaurantMouthEditFoodCell ()
{
    /**
     *  归档视图
     */
    MyRestaurantMouthArchiveFoodView *_archiveFoodView;
    
    /**
     *  未归档视图
     */
    MyRestaurantMouthUnrchiveFoodView *_unarchiveFoodView;
}

/**
 *  归档视图
 */
@property (nonatomic, strong) MyRestaurantMouthArchiveFoodView *archiveFoodView;

/**
 *  未归档视图
 */
@property (nonatomic, strong) MyRestaurantMouthUnrchiveFoodView *unarchiveFoodView;

//@property (nonatomic,)

//@property (nonatomic, strong) NSMutableArray *unarchiveFoodList;

- (void)initWithArchiveFoodView;

- (void)initWithUnarchiveFoodView;

@end

@implementation MyRestaurantMouthEditFoodCell

- (void)initWithVarCell
{
    [super initWithVarCell];
//    _unarchiveFoodList = [NSMutableArray new];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    

    [self initWithArchiveFoodView];
    
    [self initWithUnarchiveFoodView];
    
}

- (void)initWithArchiveFoodView
{
    if (!_archiveFoodView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth] / 2, [[self class] getWithCellHeight]);
        _archiveFoodView = [[MyRestaurantMouthArchiveFoodView alloc] initWithFrame:frame];
        [self.contentView addSubview:_archiveFoodView];
    }
    __weak typeof(self)weakSelf = self;
    _archiveFoodView.viewCommonBlock = ^(id data)
    {// 把归档的菜品变成非归档的菜品
        debugLog(@"把归档的菜品变成非归档的菜品");
//        debugLog(@"clss=%@", NSStringFromClass([data class]));
//        debugLog(@"ent=%@", [data modelToJSONString]);
        [weakSelf.unarchiveFoodView addWithFood:data];
        if (weakSelf.mouthOperatorBlock)
        {
            weakSelf.mouthOperatorBlock(data, 2);
        }
    };
    _archiveFoodView.refreshMouthBlock = ^(id data)
    {
        if (weakSelf.refreshMouthBlock)
        {
            weakSelf.refreshMouthBlock(data);
        }
    };
}

- (void)initWithUnarchiveFoodView
{
    if (!_unarchiveFoodView)
    {
        CGRect frame = _archiveFoodView.frame;
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 2;
        _unarchiveFoodView = [[MyRestaurantMouthUnrchiveFoodView alloc] initWithFrame:frame];
        [self.contentView addSubview:_unarchiveFoodView];
    }
    __weak typeof(self)weakSelf = self;
    _unarchiveFoodView.viewCommonBlock = ^(id data)
    {// 把非归档的菜品变成归档的菜品
        debugLog(@"把非归档的菜品变成归档的菜品");
        [weakSelf.archiveFoodView addWithFood:data];
        if (weakSelf.mouthOperatorBlock)
        {
            weakSelf.mouthOperatorBlock(data, 1);
        }
    };
}

+ (NSInteger)getWithCellHeight
{
    AppDelegate *app = [UtilityObject appDelegate];
    NSInteger height = [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - 50 - 20 - 30;
    return height;
}

/**
 *  更新
 *
 *  @param cellEntity        归档的数据
 *  @param unarchiveFoodList 未归档的数据
 */
- (void)updateCellData:(id)cellEntity unarchiveFoodList:(NSArray *)unarchiveFoodList
{
    [_archiveFoodView updateViewData:cellEntity];
    
    [_unarchiveFoodView updateViewData:unarchiveFoodList];
}


@end


















