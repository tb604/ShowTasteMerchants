/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCCustomersPayWayView.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/28 14:27
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCCustomersPayWayView.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"
#import "CTCCustomersPayWayCell.h"


@interface CTCCustomersPayWayView () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_payTableView;
    
    NSMutableArray *_payList;
    
}

- (void)initWithVar;

- (void)initWithSubView;

- (void)initWithPayTableView;

@end

@implementation CTCCustomersPayWayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVar];
        [self initWithSubView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithVar
{
    _payList = [NSMutableArray new];
    
    CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.title = @"支付宝支付";
    ent.thumalImgName = @"pay_icon_zhifubao.png";
    ent.tag = 0;
    [_payList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"微信支付";
    ent.thumalImgName = @"pay_icon_weixin.png";
    ent.tag = 1;
    [_payList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.title = @"现金支付";
    ent.thumalImgName = @"pay_cash_icon.png";
    ent.tag = 2;
    [_payList addObject:ent];
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithPayTableView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - _payTableView.height)];
    [self addSubview:topView];
    __weak typeof(self)weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        if (weakSelf.touchCancelBlock)
        {
            weakSelf.touchCancelBlock();
        }
    }];
    [topView addGestureRecognizer:tap];
}

- (void)initWithPayTableView
{
    if (!_payTableView)
    {
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - 45*3, [[UIScreen mainScreen] screenWidth], 45*3);
        _payTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _payTableView.backgroundColor = [UIColor whiteColor];
        _payTableView.showsVerticalScrollIndicator = NO;
        _payTableView.showsHorizontalScrollIndicator = NO;
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.scrollEnabled = NO;
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_payTableView];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_payList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CTCCustomersPayWayCell *cell = [CTCCustomersPayWayCell cellForTableView:tableView];
    [cell updateCellData:_payList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectPayWayBlock)
    {
        _selectPayWayBlock(_payList[indexPath.row]);
    }
    
}

@end










