//
//  ShopPlacePrinterView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopPlacePrinterView.h"
#import "LocalCommon.h"
#import "ShopPlacePrinterViewCell.h"
#import "ShopMouthDataEntity.h"

@interface ShopPlacePrinterView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *printerTableView;

@property (nonatomic, strong) NSArray *printerList;

/**
 *  选中的
 */
@property (nonatomic, strong) ShopMouthDataEntity *selPrintEntity;


- (void)initWithPrinterTableView;

@end

@implementation ShopPlacePrinterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithPrinterTableView];
}

- (void)initWithPrinterTableView
{
    if (!_printerTableView)
    {
        CGRect frame = self.bounds;
        _printerTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _printerTableView.dataSource = self;
        _printerTableView.delegate = self;
        _printerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_printerTableView];
    }
}

- (void)updateViewData:(id)entity
{
    debugLog(@"erererer");
    self.printerList = entity;
    debugLog(@"count=%d", (int)[_printerList count]);
    if (!_selPrintEntity)
    {
        self.selPrintEntity = [_printerList objectOrNilAtIndex:0];
    }
    [_printerTableView reloadData];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_printerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopPlacePrinterViewCell *cell = [ShopPlacePrinterViewCell cellForTableView:tableView];
    [cell updateCellData:_printerList[indexPath.row] selPrintEnt:_selPrintEntity];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kShopPlacePrinterViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShopMouthDataEntity *printEnt = _printerList[indexPath.row];
    self.selPrintEntity = printEnt;
    [MCYPushViewController reloadWithTableView:tableView indexPath:indexPath reloadType:0];
//    if (self.viewCommonBlock)
//    {
//        self.viewCommonBlock(printEnt);
//    }
    if (self.choicePrinterInfoBlock)
    {
        self.choicePrinterInfoBlock(printEnt, indexPath.row);
    }
}

@end




























