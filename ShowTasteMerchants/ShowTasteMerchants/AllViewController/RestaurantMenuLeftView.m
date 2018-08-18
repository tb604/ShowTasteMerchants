//
//  RestaurantMenuLeftView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantMenuLeftView.h"
#import "LocalCommon.h"
#import "RestaurantMenuLeftRecommendCell.h"
#import "RestaurantMenuLeftViewCell.h"
#import "ShopFoodCategoryDataEntity.h"
#import "ShopingCartEntity.h"

@interface RestaurantMenuLeftView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_leftTableView;
    
    
}

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSIndexPath *longPressIndexPath;

@property (nonatomic, strong) NSMutableArray *leftList;

- (void)initWithLeftTableView;

- (void)addWithShopingCartNote:(NSNotification *)note;

@end

@implementation RestaurantMenuLeftView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddShopingCartMenuNote object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
    _leftList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addWithShopingCartNote:) name:kAddShopingCartMenuNote object:nil];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithLeftTableView];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(1.0, self.height);
    line.left = 0;
    line.right = self.width;
    line.backgroundColor = [UIColor colorWithHexString:@"#cbcbcb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithLeftTableView
{
    CGRect frame = CGRectMake(0, 0, self.width-1, self.height);
    _leftTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_leftTableView];
}


+ (NSInteger)getMenuLeftViewWidth
{
    return (int)([[UIScreen mainScreen] screenWidth] / 4.16);
}


- (void)longPress:(NSIndexPath *)indexPath
{
    self.longPressIndexPath = indexPath;
    
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(_leftList[indexPath.row]);
    }
}

- (void)addWithShopingCartNote:(NSNotification *)note
{
    RestaurantMenuLeftShopingCartEntity *ent = (RestaurantMenuLeftShopingCartEntity *)[note object];
    if (ent.isAdd)
    {
        debugLog(@"加菜");
    }
    else
    {
        debugLog(@"减菜");
    }
    for (ShopFoodCategoryDataEntity *categoryEnt in _leftList)
    {
        if (categoryEnt.id == ent.categoryId)
        {
            if (ent.isAdd)
            {
                categoryEnt.selectNum += 1;
            }
            else
            {
                categoryEnt.selectNum -= 1;
            }
            [MCYPushViewController reloadWithTableView:_leftTableView indexPath:_selectIndexPath reloadType:3];
            break;
        }
    }
}

#pragma mark public
- (void)updateViewData:(id)entity
{
    [_leftList removeAllObjects];
    [_leftList addObjectsFromArray:entity];
    [_leftTableView reloadData];
}

- (void)updateViewData:(id)entity isReset:(BOOL)isReset
{
    if (isReset)
    {
        self.selectIndexPath = nil;
    }
    [self updateViewData:entity];
}

- (void)updateWithSelectedFoodNum:(NSArray *)cartList
{
    for (ShopFoodCategoryDataEntity *categoryEnt in _leftList)
    {// 分类数据
        for (ShopingCartEntity *cartEnt in cartList)
        {
            if (categoryEnt.id == cartEnt.category_id)
            {
                categoryEnt.selectNum += 1;
            }
        }
    }
    [_leftTableView reloadData];
}


#pragma mark UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    ShopFoodCategoryDataEntity *category = _leftList[indexPath.row];
    if (category.type == 0 || category.type == 1)
    {// 0：掌柜推荐  1：名厨推荐
        RestaurantMenuLeftRecommendCell *cell = [RestaurantMenuLeftRecommendCell cellForTableView:tableView];
        debugLog(@"0：掌柜推荐  1：名厨推荐");
        [cell updateCellData:category cellWidth:self.width];
        if (!_selectIndexPath || indexPath.row == 0)
        {
            self.selectIndexPath = indexPath;
            [cell hiddenWithVerticalLine:NO];
        }
        else
        {
            [cell hiddenWithVerticalLine:YES];
        }
        cell.baseTableViewCellBlock = ^(id data)
        {// 长按
            [weakSelf longPress:indexPath];
        };
        return cell;
    }
    
    RestaurantMenuLeftViewCell *cell = [RestaurantMenuLeftViewCell cellForTableView:tableView];
    [cell updateCellData:category cellWidth:self.width];
    if (!_selectIndexPath && indexPath.row == 0)
    {
        self.selectIndexPath = indexPath;
        [cell hiddenWithVerticalLine:NO];
    }
    else if (_selectIndexPath.row == indexPath.row)
    {
        [cell hiddenWithVerticalLine:NO];
    }
    else
    {
        [cell hiddenWithVerticalLine:YES];
    }
    cell.baseTableViewCellBlock = ^(id data)
    {
        [weakSelf longPress:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopFoodCategoryDataEntity *category = _leftList[indexPath.row];
    CGFloat height = 46.0;
    if (category.type == 0 || category.type == 1)
    {
        height = self.width / 1.2;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopFoodCategoryDataEntity *category = _leftList[indexPath.row];
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
//        debugLog(@"if");
//        RestaurantMenuLeftRecommendCell *newCellOne = nil;
//        RestaurantMenuLeftRecommendCell *oldCellOne = nil;
//        RestaurantMenuLeftViewCell *newCellTwo = nil;
//        RestaurantMenuLeftViewCell *oldCellTwo = nil;
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        
        UITableViewCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = [tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        
        if ([newCell isKindOfClass:[RestaurantMenuLeftRecommendCell class]])
        {
            RestaurantMenuLeftRecommendCell *rNewCell = (RestaurantMenuLeftRecommendCell *)newCell;
            [rNewCell hiddenWithVerticalLine:NO];
        }
        else if ([newCell isKindOfClass:[RestaurantMenuLeftViewCell class]])
        {
            RestaurantMenuLeftViewCell *lNewCell = (RestaurantMenuLeftViewCell *)newCell;
            [lNewCell hiddenWithVerticalLine:NO];
        }
        
        if ([oldCell isKindOfClass:[RestaurantMenuLeftRecommendCell class]])
        {
            RestaurantMenuLeftRecommendCell *rOldCell = (RestaurantMenuLeftRecommendCell *)oldCell;
            [rOldCell hiddenWithVerticalLine:YES];
        }
        else if ([oldCell isKindOfClass:[RestaurantMenuLeftViewCell class]])
        {
            RestaurantMenuLeftViewCell *lOldCell = (RestaurantMenuLeftViewCell *)oldCell;
            [lOldCell hiddenWithVerticalLine:YES];
        }
        
        /*if (indexPath.row == 0)
        {
            newCellOne = (RestaurantMenuLeftRecommendCell *)[tableView cellForRowAtIndexPath:indexPath];
            [newCellOne hiddenWithVerticalLine:NO];
        }
        else
        {
            newCellTwo =  (RestaurantMenuLeftViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            [newCellTwo hiddenWithVerticalLine:NO];
        }
        
        if (_selectIndexPath.row == 0)
        {
            oldCellOne = (RestaurantMenuLeftRecommendCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
            [oldCellOne hiddenWithVerticalLine:YES];
        }
        else
        {
            oldCellTwo = (RestaurantMenuLeftViewCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
            [oldCellTwo hiddenWithVerticalLine:YES];
        }*/
        self.selectIndexPath = indexPath;
    }
    else
    {
//                debugLog(@"else");
//        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (self.selectCategoryBlock)
    {
        _selectCategoryBlock(category);
    }
    
}

@end
