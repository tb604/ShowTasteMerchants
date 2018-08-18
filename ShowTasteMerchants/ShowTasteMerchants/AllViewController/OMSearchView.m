//
//  OMSearchView.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OMSearchView.h"
#import "LocalCommon.h"
#import "OMLocationSearchViewCell.h"

@interface OMSearchView () <UITextFieldDelegate>
{
    UIImageView *_searchIconView;
    UITextField *_txtSearch;
}

- (void)initWithSearchIconView;

- (void)initWithTxtSearch;

- (void)resignResponderNote:(NSNotification *)note;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation OMSearchView

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kResignResponderNote object:nil];
}

// 80

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignResponderNote:) name:kResignResponderNote object:nil];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithSearchIconView];
    
    [self initWithTxtSearch];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithSearchIconView
{
    if (!_searchIconView)
    {
        NSInteger leftSpace = ([[UIScreen mainScreen] screenWidth] - 30) / 4.43;
        UIImage *image = [UIImage imageNamed:@"home_icon_sreach"];
        CGRect frame = CGRectMake(leftSpace + 15, 0, image.size.width, image.size.height);
        _searchIconView = [[UIImageView alloc] initWithFrame:frame];
        _searchIconView.image = image;
        _searchIconView.centerY = self.height / 2;
        [self addSubview:_searchIconView];
    }
}

- (void)initWithTxtSearch
{
    NSInteger leftSpace = [[UIScreen mainScreen] screenWidth] / 4.43;
    _txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(_searchIconView.right+5, 0, [[UIScreen mainScreen] screenWidth] - (leftSpace+10)*2 - _searchIconView.width - 5, 30)];
    _txtSearch.font = [UIFont systemFontOfSize:16];
    _txtSearch.delegate = self;
//    _txtSearch.textColor = [UIColor colorWithHexString:@"#999999"];
    _txtSearch.returnKeyType = UIReturnKeySearch;
    _txtSearch.borderStyle = UITextBorderStyleNone;
    _txtSearch.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _txtSearch.placeholder = @"";
    _txtSearch.enabled = NO;
    UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入商家或商品名称" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    _txtSearch.attributedPlaceholder = butedStr;
    _txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:_txtSearch];
    
}

- (void)searchContent
{
    [_txtSearch resignFirstResponder];
    NSString *str = _txtSearch.text;
    if (!str)
    {
        str = @"";
    }
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(str);
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
//    debugMethod();
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

//- (void)resignResponderNote:(NSNotification *)note
//{
//    [_txtSearch resignFirstResponder];
//}

- (void)endSearchEdit
{
//    [_txtSearch resignFirstResponder];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchContent];
    
    return YES;
}

@end















