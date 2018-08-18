//
//  OMLocationSearchView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLocationSearchView.h"
#import "LocalCommon.h"
#import "OMLocationView.h" // 当前的地址
#import "OMSearchView.h" // 搜索

@interface OMLocationSearchView ()
{
//    OMLocationView *_locationView;
    
    OMSearchView *_searchView;
}

//- (void)initWithLocationView;

- (void)initWithSearchView;

@end

@implementation OMLocationSearchView

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
    
    self.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
    
//    [self initWithLocationView];
    
    [self initWithSearchView];
    
}

/*- (void)initWithLocationView
{
    if (!_locationView)
    {
        NSInteger leftSpace = ([[UIScreen mainScreen] screenWidth] - 30) / 4.43;
        
        _locationView = [[OMLocationView alloc] initWithFrame:CGRectMake(leftSpace, STATUSBAR_HEIGHT, [[UIScreen mainScreen] screenWidth] - leftSpace*2, NAVBAR_HEIGHT)];
        [self addSubview:_locationView];
    }
}*/

- (void)initWithSearchView
{
    if (!_searchView)
    {
        _searchView = [[OMSearchView alloc] initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] - 20, 30)];
        _searchView.bottom = self.height - 10;
        _searchView.layer.cornerRadius = 4;
        _searchView.layer.masksToBounds = YES;
        _searchView.centerY = self.height / 2;
        [self addSubview:_searchView];
    }
    __weak typeof(self)weakSelf = self;
    _searchView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(data);
        }
    };
}

- (void)updateViewData:(id)entity
{
//    [_locationView updateViewData:entity];
}

- (void)endSearchEdit
{
    [_searchView endSearchEdit];
}

@end













