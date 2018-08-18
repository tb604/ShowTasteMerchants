//
//  ShopOrderOfflinePayChannelBackgroundView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/26.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopOrderOfflinePayChannelBackgroundView.h"
#import "LocalCommon.h"


@interface ShopOrderOfflinePayChannelBackgroundView ()
{
    ShopOrderOfflinePayChannelView *_offlinePayChannelView;
}


- (void)initWithSubView;

- (void)initWithOfflinePayChannelView;


@end

@implementation ShopOrderOfflinePayChannelBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self initWithOfflinePayChannelView];
    
    
}

- (void)initWithOfflinePayChannelView
{
    if (!_offlinePayChannelView)
    {
        CGRect frame = CGRectMake(0, 0, 300, 362);
        _offlinePayChannelView = [[ShopOrderOfflinePayChannelView alloc] initWithFrame:frame];
        _offlinePayChannelView.layer.cornerRadius = 4;
        _offlinePayChannelView.layer.masksToBounds = YES;
        _offlinePayChannelView.centerX = self.width / 2;
        _offlinePayChannelView.centerY = self.height / 2;
        [self addSubview:_offlinePayChannelView];
    }
    __weak typeof(self)weakSelf = self;
    _offlinePayChannelView.touchWithButtonBlock = ^(id data)
    {
        if (weakSelf.touchWithButtonBlock)
        {
            weakSelf.touchWithButtonBlock(data);
        }
    };
}

- (void)updateWithPayChannelList:(NSArray *)channelList
{
    [_offlinePayChannelView updateViewData:channelList];
}

// ShopOrderOfflinePayChannelView

@end











