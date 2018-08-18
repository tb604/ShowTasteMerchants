//
//  DinersSearchResultNewNearView.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersSearchResultNewNearView.h"
#import "LocalCommon.h"
#import "MallDataEntity.h"
#import "MallEditTableViewCell.h"
#import "MallSelectInfoView.h" // 选中的视图

@interface DinersSearchResultNewNearView () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _bottomHeight;
    
    UITableView *_mallTableView;
    
    // icon_xiala
    UIImageView *_xialaImgView;
    
    MallSelectInfoView *_selectInfoView;
    
    BOOL _isShow;
}

@property (nonatomic, strong) NSArray *mallList;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, strong) MallDataEntity *areaMallEntity;

@property (nonatomic, strong) MallListDataEntity *mallEntity;

@property (nonatomic, strong) CALayer *topLine;

- (void)initWithMallTableView;

- (void)initWithSelectInfoView;

- (void)initWithXialaImgView;



@end

@implementation DinersSearchResultNewNearView

- (id)initWithFrame:(CGRect)frame bottomHeight:(CGFloat)bottomHeight
{
    _bottomHeight = bottomHeight;
    return [self initWithFrame:frame];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _isShow = NO;
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    [self initWithMallTableView];
    
    [self initWithSelectInfoView];
    
    [self initWithXialaImgView];
    
    if (!_topLine)
    {
        CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, 0, _xialaImgView.left, 0.8) lineColor:[UIColor colorWithHexString:@"#ff5700"]];
        self.topLine = line;
        
        [CALayer drawLine:self frame:CGRectMake(_xialaImgView.right, 0, [[UIScreen mainScreen] screenWidth] - _xialaImgView.right, 0.8) lineColor:[UIColor colorWithHexString:@"#ff5700"]];
    }

    // 隐藏景点列表手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipe];

    
}

- (void)initWithMallTableView
{
    if (!_mallTableView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - NAVBAR_HEIGHT - _bottomHeight);
        _mallTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _mallTableView.dataSource = self;
        _mallTableView.delegate = self;
        _mallTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mallTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self addSubview:_mallTableView];
    }
}

- (void)initWithSelectInfoView
{
    CGRect frame = _mallTableView.frame;
    frame.origin.x = [[UIScreen mainScreen] screenWidth];
    _selectInfoView = [[MallSelectInfoView alloc] initWithFrame:frame];
    //    _sceneListView.backgroundColor = [UIColor orangeColor];
    //    _sceneListView.delegate = self;
    
    _selectInfoView.layer.shadowColor = [UIColor blackColor].CGColor;
    _selectInfoView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _selectInfoView.layer.shadowOpacity = 0.5;
    _selectInfoView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_selectInfoView.bounds].CGPath;
    _selectInfoView.layer.shadowRadius = 2;
    _selectInfoView.layer.masksToBounds = NO;
    
    [self addSubview:_selectInfoView];
    __weak typeof(self)weakSelf = self;
    _selectInfoView.viewCommonBlock = ^(id data)
    {
//        weakSelf.mallEntity = data;
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(data);
        }
    };
}

- (void)initWithXialaImgView
{
    if (!_xialaImgView)
    {
        UIImage *image = [UIImage imageNamed:@"icon_xiala"];
        CGFloat screenWidth = [[UIScreen mainScreen] screenWidth];
        CGRect frame = CGRectMake((screenWidth/2-image.size.width)/2, 0, image.size.width, image.size.height);
        _xialaImgView = [[UIImageView alloc] initWithFrame:frame];
        _xialaImgView.image = image;
        [self addSubview:_xialaImgView];
    }
}


/**
 *  景点列表视图显示或者隐藏
 *
 *  @param isShow <#isShow description#>
 */
- (void)mallTableViewAnimateShow:(BOOL)isShow data:(id)data
{
    CGRect frame = _selectInfoView.frame;
    if (isShow)
    {
        [_selectInfoView updateViewData:data];
        frame.origin.x = [[UIScreen mainScreen] screenWidth] / 3.0;
    }
    else
    {
        frame.origin.x = [[UIScreen mainScreen] screenWidth];
    }
    [UIView animateWithDuration:0.25 animations:^{
        _selectInfoView.frame = frame;
        //        _tableViewShadow.frame = frame;
    }];
}

/**
 *  处理隐藏景点列表手势
 *
 *  @param gesture <#gesture description#>
 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateRecognized)
    {
        return;
    }
    
    // 隐藏景点列表视图
    _isShow = NO;
    [self mallTableViewAnimateShow:_isShow data:nil];
}


- (void)updateViewData:(id)entity
{
    self.mallList = entity;
    [_mallTableView reloadData];
}


#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mallList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MallEditTableViewCell *cell = [MallEditTableViewCell cellForTableView:tableView];
    UIColor *color = nil;
    //    if (!_selectIndexPath && indexPath.row == 0)
    //    {
    //        color = [UIColor colorWithHexString:@"#ffffff"];
    //        self.selectIndexPath = indexPath;
    //    }
    //    else
    //    {
    color = [UIColor colorWithHexString:@"#f5f5f5"];
    //    }
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;
    
    //    debugLog(@"selc=%d", cell.selected);
    [cell updateCellData:_mallList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMallEditTableViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MallDataEntity *mallEntity = _mallList[indexPath.row];
    self.areaMallEntity = mallEntity;
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (_selectIndexPath?_selectIndexPath.row:-1);
    if (newRow != oldRow)
    {
        //        debugLog(@"if");
        MallEditTableViewCell *newCell = (MallEditTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        MallEditTableViewCell *oldCell = nil;
        if (_selectIndexPath)
        {
            oldCell = (MallEditTableViewCell *)[tableView cellForRowAtIndexPath:_selectIndexPath];
        }
        oldCell.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        oldCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        self.selectIndexPath = indexPath;
        
        _isShow = YES;
        [self mallTableViewAnimateShow:_isShow data:mallEntity.malls];
        
    }
    else
    {
        //        debugLog(@"else");
        TYZBaseTableViewCell *newCell = (TYZBaseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        newCell.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        if (!_isShow)
        {
            _isShow = YES;
            [self mallTableViewAnimateShow:_isShow data:mallEntity.malls];
        }
    }
    
    
//    debugLog(@"mallEnt=%@", [mallEntity modelToJSONString]);
    
}


@end













