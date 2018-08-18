/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCRestaurantMealingOrderLeftView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/17 16:11
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCRestaurantMealingOrderLeftView.h"
#import "LocalCommon.h"
#import "CTCRestaurantMealingOrderLeftCell.h"
#import "OrderDiningSeatEntity.h"


@interface CTCRestaurantMealingOrderLeftView () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *leftTableView;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) NSMutableArray *leftList;

- (void)initWithLeftTableView;


@end

@implementation CTCRestaurantMealingOrderLeftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark override methods

- (void)initWithVar
{
    [super initWithVar];
    
    _leftList = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    
    [self initWithLeftTableView];
    
}


- (void)updateViewData:(id)entity
{
//    NSArray *array = entity;
//    debugLog(@"count=%d", (int)array.count);
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

#pragma mark -
#pragma mark private methods
- (void)initWithLeftTableView
{
    CGRect frame = CGRectMake(0, 0, self.width, self.height);
    _leftTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _leftTableView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_leftTableView];
}

#pragma mark -
#pragma mark public methods
+ (NSInteger)getWithViewWidth
{
    return [[UIScreen mainScreen] screenWidth] / 4.6875;
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_leftList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCRestaurantMealingOrderLeftCell *cell = [CTCRestaurantMealingOrderLeftCell cellForTableView:tableView];
    [cell updateCellData:_leftList[indexPath.row]];
    if (!_selectIndexPath && indexPath.row == 0)
    {
//        debugLog(@"ififif");
        self.selectIndexPath = indexPath;
        [cell selectedWithCell:YES];
    }
    else if (_selectIndexPath.row == indexPath.row)
    {
//        debugLog(@"else if else if");
        [cell selectedWithCell:YES];
    }
    else
    {
        [cell selectedWithCell:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self class] getWithViewWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OrderDiningSeatEntity *ent = _leftList[indexPath.row];
    
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
//        debugLog(@"eerere");
        CTCRestaurantMealingOrderLeftCell *newCell = (CTCRestaurantMealingOrderLeftCell *)[tableView cellForRowAtIndexPath:indexPath];
        [newCell selectedWithCell:YES];
        CTCRestaurantMealingOrderLeftCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (CTCRestaurantMealingOrderLeftCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
            [oldCell selectedWithCell:NO];
        }
        
        self.selectIndexPath = indexPath;
    }
    
    if (self.selectOrderSeatBlock)
    {
        self.selectOrderSeatBlock(ent);
    }
    
}

@end




















