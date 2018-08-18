//
//  TYZBaseBottomView.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseBottomView.h"
#import "TYZKit.h"

@interface TYZBaseBottomView ()

@property (nonatomic, strong) CALayer *line;

@end

@implementation TYZBaseBottomView

- (void)dealloc
{
    
}

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
    
    [self initWithLine];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.5);
    line.left = 0;
    line.top = 0;
    line.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    [self.layer addSublayer:line];
    self.line = line;
}

- (void)topLineWithHidden:(BOOL)hidden
{
    _line.hidden = hidden;
}


- (void)updateBottomCancel:(NSString *)cancelTitle submitTitle:(NSString *)submitTitle
{
    
}

@end
