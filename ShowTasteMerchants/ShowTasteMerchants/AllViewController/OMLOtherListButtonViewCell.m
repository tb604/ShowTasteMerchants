//
//  OMLOtherListButtonViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMLOtherListButtonViewCell.h"
#import "OMLOtherListButtonView.h"
#import "LocalCommon.h"


@interface OMLOtherListButtonViewCell ()
{
    OMLOtherListButtonView *_otherButtonView;
}

- (void)initWithOtherButtonView;

@end

@implementation OMLOtherListButtonViewCell

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
    
    [self initWithOtherButtonView];
}

- (void)initWithOtherButtonView
{
    if (!_otherButtonView)
    {
        __weak typeof(self)weakSelf = self;
        _otherButtonView = [[OMLOtherListButtonView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kOMLOtherListButtonViewHeight)];
        [self.contentView addSubview:_otherButtonView];
        _otherButtonView.viewCommonBlock = ^(id data)
        {
            if (weakSelf.baseTableViewCellBlock)
            {
                weakSelf.baseTableViewCellBlock(data);
            }
        };
    }
}

- (void)updateCellData:(id)cellEntity
{
    [_otherButtonView updateViewData:cellEntity];
}

@end
