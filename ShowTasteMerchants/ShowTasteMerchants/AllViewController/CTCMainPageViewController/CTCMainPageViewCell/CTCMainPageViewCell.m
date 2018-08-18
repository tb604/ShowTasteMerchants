/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCMainPageViewCell.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/14 14:14
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCMainPageViewCell.h"
#import "LocalCommon.h"
#import "CTCMainPageView.h"
#import "CellCommonDataEntity.h"

@interface CTCMainPageViewCell ()

@property (nonatomic, strong) NSArray *opList;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSMutableArray *allViews;

- (void)initWithAddAllView;

@end

@implementation CTCMainPageViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _allViews = [NSMutableArray new];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)initWithAddAllView
{
    __weak typeof(self)weakSelf =self;
    NSInteger count = [_allViews count];
    NSInteger col = ceilf(_opList.count / 3.);
    for (CTCMainPageView *view in _allViews)
    {
        view.hidden = YES;
    }
    CGRect frame = CGRectMake(0, 0, [CTCMainPageView getWithWidth], [CTCMainPageView getWithHeight]);
    CTCMainPageView *singleView = nil;
//    debugLog(@"count=%d", (int)_opList.count);
    for (NSInteger i=0; i<[_opList count]; i++)
    {
//        debugLog(@"%ld", i);
        if (i % 3 == 0)
        {
//            debugLog(@"if");
            frame.origin.x = 0;
            if (i == 0)
            {
                frame.origin.y = 0;
            }
            else
            {
                CTCMainPageView *empView = _allViews[i-1];
                frame.origin.y = empView.bottom;
            }
        }
        else
        {
//            debugLog(@"else");
            frame.origin.x = frame.origin.x + frame.size.width;
//            frame.origin.x = frame.size.width * i;
//            CTCMainPageView *empView = _allViews[i-1];
//            frame.origin.y = empView.bottom;
        }
        
        CellCommonDataEntity *entity = _opList[i];
//        debugLog(@"title=%@", entity.title);
        if (i < count)
        {
//            debugLog(@"if");
            singleView = _allViews[i];
            [singleView updateViewData:entity];
            singleView.hidden = NO;
        }
        else
        {
//            debugLog(@"else");
            singleView = [[CTCMainPageView alloc] initWithFrame:frame];
            [singleView updateViewData:entity];
            [self.contentView addSubview:singleView];
            [_allViews addObject:singleView];
        }
//        singleView.backgroundColor = [UIColor redColor];
        
        singleView.viewCommonBlock = ^(id data)
        {
            if (weakSelf.baseTableViewCellBlock)
            {
                weakSelf.baseTableViewCellBlock(data);
            }
        };
        
        NSInteger empCol = ceilf(i / 3.);
//        debugLog(@"empCol=%d; col=%d", (int)empCol, (int)col);
        if (empCol == col)
        {// 最后一行
            CTCMainPageView *empView = _allViews[i-1];
            [empView hiddenWithBottomLine:YES];
            [singleView hiddenWithBottomLine:YES];
        }
        else
        {
            [singleView hiddenWithBottomLine:NO];
        }
        
        [singleView hiddenWithLeftLine:NO];
        if (i + 1 == [_opList count])
        {// 最后一个
            [singleView hiddenWithBottomLine:YES];
            [singleView hiddenWithRightLine:NO];
        }
        else
        {
            [singleView hiddenWithRightLine:YES];
        }
        
        
    }

}

- (void)updateCellData:(id)cellEntity
{
    self.opList = cellEntity;
    
//    NSInteger col = ceilf(_opList.count / 3.);
//    self.cellHeight = col * [[UIScreen mainScreen] screenWidth] / 3.;
    
    [self initWithAddAllView];
}

@end
