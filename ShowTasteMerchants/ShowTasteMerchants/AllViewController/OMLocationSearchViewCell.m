//
//  OMLocationSearchViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLocationSearchViewCell.h"
#import "LocalCommon.h"


@interface OMLocationSearchViewCell ()
{
    OMLocationSearchView *_locationSearchView;
}

- (void)initWithLocationSearchView;

@end

@implementation OMLocationSearchViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    [self initWithLocationSearchView];
}

- (void)initWithLocationSearchView
{
    if (!_locationSearchView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOMLocationSearchViewHeight);
        _locationSearchView = [[OMLocationSearchView alloc] initWithFrame:frame];
        [self.contentView addSubview:_locationSearchView];
    }
    __weak typeof(self)weakSelf = self;
    _locationSearchView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}

- (void)updateCellData:(id)cellEntity
{
    [_locationSearchView endSearchEdit];
//    [_locationSearchView updateViewData:cellEntity];
}

@end
