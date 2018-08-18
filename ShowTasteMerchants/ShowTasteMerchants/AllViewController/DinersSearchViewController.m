//
//  DinersSearchViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchViewController.h"
#import "LocalCommon.h"
#import "DinersSearchHeaderView.h"
#import "DinersSearchViewCell.h"
#import "TestDropDownMenuViewController.h"

@interface DinersSearchViewController () <UITextFieldDelegate>
{
    UITextField *_searchTxtField;
    
    DinersSearchHeaderView *_headerView;
}

- (void)initWithSearchTxtField;

- (void)initWithHeaderView;

@end

@implementation DinersSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *array = [UtilityObject readCacheDataLocalKey:kCacheSearchKeyData saveFilename:kCacheSearchKeyFileName];
    [self.baseList removeAllObjects];
    [self.baseList addObjectsFromArray:array];
    [self.baseTableView reloadData];
}

- (void)initWithVar
{
    [super initWithVar];
    
    /*
     // 用户输入的搜索的关键字写入本地
     #define kCacheSearchKeyFileName @"CacheSearchKey.plist"
     #define n @"CacheSearchKey"

     */
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    [self initWithSearchTxtField];
    
    // 搜索
    NSString *str = @"搜索";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setTitle:str forState:UIControlStateNormal];
    btnSearch.titleLabel.font = FONTSIZE_16;
    btnSearch.frame = CGRectMake(0, 0, width, 30);
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(clickedWithSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemSearch = [[UIBarButtonItem alloc] initWithCustomView:btnSearch];
    self.navigationItem.rightBarButtonItem = itemSearch;
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithHeaderView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0)];
    self.baseTableView.tableFooterView = view;
    
}

- (void)initWithSearchTxtField
{
    if (!_searchTxtField)
    {
        
        CGRect frame = CGRectMake(50, 7, [[UIScreen mainScreen] screenWidth] - 50 * 2, 30);
        UIView *titleView = [[UIView alloc] initWithFrame:frame];
        titleView.backgroundColor = [UIColor colorWithHexString:@"#ff7832"];
        titleView.layer.masksToBounds = YES;
        titleView.layer.cornerRadius = 4;
        titleView.layer.borderColor = [UIColor colorWithHexString:@"#f95709"].CGColor;
        titleView.layer.borderWidth = 1;
        frame = CGRectMake(5, 0, titleView.width - 10, 30);
        _searchTxtField = [[UITextField alloc] initWithFrame:frame];
        _searchTxtField.font = FONTSIZE_15;
        _searchTxtField.delegate = self;
        _searchTxtField.textColor = [UIColor colorWithHexString:@"#999999"];
        _searchTxtField.keyboardType = UIKeyboardTypeDefault;
        _searchTxtField.returnKeyType = UIReturnKeySearch;
        _searchTxtField.borderStyle = UITextBorderStyleNone;
        _searchTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIColor *color = [UIColor colorWithHexString:@"#ffffff"];
        NSAttributedString *bTitle = [[NSAttributedString alloc] initWithString:@"请输入店名、菜系、商圈" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
//        _searchTxtField.placeholder = @"";
        _searchTxtField.attributedPlaceholder = bTitle;
        _searchTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTxtField.backgroundColor = [UIColor colorWithHexString:@"#ff7832"];
        [titleView addSubview:_searchTxtField];
        self.navigationItem.titleView = titleView;

    }
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
//        CGFloat space = 15;
        CGFloat bottomSpace = 10;
//        NSInteger col = 4; // 一行4个
        CGFloat row = ceil(_hotKeyList.count / 4.);
//        debugLog(@"count=%d; row=%d", (int)_hotKeyList.count, (int)row);
        CGFloat height = row * 30 + (row - 1) * bottomSpace;
//        debugLog(@"height=%.0f", height);
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kDinersSearchHeaderViewHeight - 30 + height);
        _headerView = [[DinersSearchHeaderView alloc] initWithFrame:frame];
//        _headerView.backgroundColor = [UIColor lightGrayColor];
        self.baseTableView.tableHeaderView = _headerView;
    }
    [_headerView updateViewData:_hotKeyList];
    __weak typeof(self)weakSelf = self;
    _headerView.viewCommonBlock = ^(id data)
    {
        [weakSelf searchWithContent:data];
    };
}


- (void)clickedWithSearch:(id)sender
{
    [_searchTxtField resignFirstResponder];
    NSString *strSearch = objectNull(_searchTxtField.text);
    if (![strSearch isEqualToString:@""])
    {
        for (NSString *str in self.baseList)
        {
            if ([str isEqualToString:strSearch])
            {
                [self.baseList removeObject:str];
                break;
            }
        }
        [self.baseList insertObject:strSearch atIndex:0];
        [UtilityObject saveCacheDataLocalKey:kCacheSearchKeyData saveFilename:kCacheSearchKeyFileName saveid:self.baseList];
    }
    
    [self searchWithContent:strSearch];
    
}

// 搜索
- (void)searchWithContent:(NSString *)strKey
{
//    debugLog(@"strKey=%@", strKey);
    
//    TestDropDownMenuViewController *testVC = [[TestDropDownMenuViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:testVC animated:YES];
//    return;
    
//    [MCYPushViewController showWithDinersSearchResultVC:self data:strKey completion:^(id data) {
//        
//    }];
    
    [MCYPushViewController showWithDinersNewSearchResultVC:self data:strKey type:1 completion:nil];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickedWithSearch:nil];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.baseList count];
    if (count > 10)
    {
        count = 10;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DinersSearchViewCell *cell = [DinersSearchViewCell cellForTableView:tableView];
    [cell updateCellData:self.baseList[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kDinersSearchViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    label.text = @"搜索历史";
    [CALayer drawLine:view frame:CGRectMake(0, view.height, view.width, 0.6) lineColor:[UIColor colorWithHexString:@"#999999"]];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *str = self.baseList[indexPath.row];
    [self searchWithContent:str];
}


@end























