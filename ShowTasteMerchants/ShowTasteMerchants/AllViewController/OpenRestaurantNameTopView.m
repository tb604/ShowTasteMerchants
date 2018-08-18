//
//  OpenRestaurantNameTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantNameTopView.h"
#import "LocalCommon.h"


@interface OpenRestaurantNameTopView () <UITextFieldDelegate>
{
    UILabel *_titleLabel;
    
    UIImageView *_thumalImgView;
    
    UIView *_txtBg;
    
    UITextField *_txtSearchField;
}

- (void)initWithTitleLabel;

- (void)initWithThumalImgView;

- (void)initWithTxtBg;

- (void)initWithTxtSearchField;


@end

@implementation OpenRestaurantNameTopView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithThumalImgView];
    
    [self initWithTxtBg];
    
    [self initWithTxtSearchField];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _titleLabel.centerY = self.height / 2;
    _titleLabel.text = @"餐厅的名字呢？";
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"kaicanting_icon_name"];
    CGRect frame = CGRectMake((self.width - image.size.width)/2, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    _thumalImgView.bottom = _titleLabel.top - 20;
    [self addSubview:_thumalImgView];
}

- (void)initWithTxtBg
{
    CGRect frame = CGRectMake(30, 0, [[UIScreen mainScreen] screenWidth] - 60, 40);
    _txtBg = [[UIView alloc] initWithFrame:frame];
    _txtBg.bottom = self.height - 25;
    _txtBg.layer.borderColor= [UIColor colorWithHexString:@"#cdcdcd"].CGColor;
    _txtBg.layer.borderWidth = 1;
    _txtBg.layer.masksToBounds = YES;
    _txtBg.layer.cornerRadius = 4;
    [self addSubview:_txtBg];
}

- (void)initWithTxtSearchField
{
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入餐厅名称" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
    CGRect frame = CGRectMake(15, 5, _txtBg.width - 30, 30);
    _txtSearchField = [[UITextField alloc] initWithFrame:frame];
    _txtSearchField.borderStyle = UITextBorderStyleNone;
    _txtSearchField.font = FONTSIZE_15;
    _txtSearchField.attributedPlaceholder = butedStr;
    _txtSearchField.textAlignment = NSTextAlignmentLeft;
    _txtSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtSearchField.keyboardType = UIKeyboardTypeDefault;
    _txtSearchField.returnKeyType = UIReturnKeyDone;
    _txtSearchField.delegate = self;
    [_txtBg addSubview:_txtSearchField];
    
}

- (void)clickedButton:(id)sender
{
    NSString *name = _txtSearchField.text;
    if (!name || [name isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入餐厅名称"];
        return;
    }
    [self endEditing:YES];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(name);
    }
}

- (NSString *)restaurantName
{
    return _txtSearchField.text;
}

#pragma mask UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
//    [self performSelector:@selector(clickedButton:) withObject:nil afterDelay:1];
    return YES;
}

@end
