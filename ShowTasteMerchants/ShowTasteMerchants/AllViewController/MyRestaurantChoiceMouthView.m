//
//  MyRestaurantChoiceMouthView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/5.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyRestaurantChoiceMouthView.h"
#import "LocalCommon.h"
#import "MyRestaurantChoiceMouthCell.h"
#import "ShopFoodDataEntity.h"
#import "ShopMouthDataEntity.h"

@interface MyRestaurantChoiceMouthView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_choiceTableView;
}

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSArray *mouthList;

- (void)initWithChoiceTableView;

@end

@implementation MyRestaurantChoiceMouthView

- (void)initWithVar
{
    [super initWithVar];
    
    _mouthList = @[@"1", @"1", @"2", @"2", @"3", @"3"];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithChoiceTableView];
    
}

- (void)initWithChoiceTableView
{
    CGRect frame = self.bounds;
    _choiceTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _choiceTableView.dataSource = self;
    _choiceTableView.delegate = self;
    _choiceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _choiceTableView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_choiceTableView];
}

- (void)updateViewData:(id)entity
{
    self.mouthList = entity;
    [_choiceTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mouthList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRestaurantChoiceMouthCell *cell = [MyRestaurantChoiceMouthCell cellForTableView:tableView];
    ShopMouthDataEntity *mouthEnt = _mouthList[indexPath.row];
    [cell updateCellData:mouthEnt];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopMouthDataEntity *mouthEnt = _mouthList[indexPath.row];
    
    for (ShopMouthDataEntity *ent in _mouthList)
    {
        ent.isSelected = NO;
    }
    mouthEnt.isSelected = YES;
    
    [tableView reloadData];
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(mouthEnt);
    }
}


@end
