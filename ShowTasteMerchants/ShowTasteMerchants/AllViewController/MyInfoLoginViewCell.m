//
//  MyInfoLoginViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoLoginViewCell.h"
#import "LocalCommon.h"
#import "MyInfoLoginCommonButtonView.h"
#import "CellCommonDataEntity.h"

@interface MyInfoLoginViewCell ()
{
    /**
     *  设置按钮
     */
    MyInfoLoginCommonButtonView *_btnSettings;
    
    /**
     *  帮助按钮
     */
    MyInfoLoginCommonButtonView *_btnAbout;
    
}

- (void)initWithBtnSettings;

- (void)initWithBtnAbout;

@end

@implementation MyInfoLoginViewCell

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
    
//    self.contentView.backgroundColor = [UIColor purpleColor];
    
    [self initWithBtnSettings];
    
    [self initWithBtnAbout];
}

- (void)initWithBtnSettings
{
    __weak typeof(self)weakSelf = self;
    if (!_btnSettings)
    {
        CellCommonDataEntity *ent = [CellCommonDataEntity new];
        ent.thumalImgName = nil;
        ent.title = @"设置";
        
        CGFloat width = [[UIScreen mainScreen] screenWidth];
        CGFloat btnWidth = width / 3 * 2 + 30;
        _btnSettings = [[MyInfoLoginCommonButtonView alloc] initWithFrame:CGRectMake(15, 25, btnWidth - 15 * 2, 30)];
        _btnSettings.layer.borderWidth = 0.8;
        _btnSettings.layer.borderColor = [UIColor colorWithHexString:@"#1b1b1b"].CGColor;
        [self.contentView addSubview:_btnSettings];
        [_btnSettings updateViewData:ent];
        _btnSettings.viewCommonBlock = ^(id data)
        {
            if (weakSelf.baseTableViewCellBlock)
            {
                weakSelf.baseTableViewCellBlock(data);
            }
        };
    }
}

- (void)initWithBtnAbout
{
    __weak typeof(self)weakSelf = self;
    if (!_btnAbout)
    {
        CellCommonDataEntity *ent = [CellCommonDataEntity new];
        ent.thumalImgName = nil;
        ent.title = @"帮助";
        CGRect frame = _btnSettings.frame;
        _btnAbout = [[MyInfoLoginCommonButtonView alloc] initWithFrame:frame];
        _btnAbout.top = _btnSettings.bottom + 15;
        _btnAbout.layer.borderWidth = 0.8;
        _btnAbout.layer.borderColor = [UIColor colorWithHexString:@"#1b1b1b"].CGColor;
        [_btnAbout updateViewData:ent];
        [self.contentView addSubview:_btnAbout];
    }
    _btnSettings.viewCommonBlock = ^(id data)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            weakSelf.baseTableViewCellBlock(data);
        }
    };
}



@end




























