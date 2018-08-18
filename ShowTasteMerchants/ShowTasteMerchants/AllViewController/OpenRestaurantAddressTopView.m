//
//  OpenRestaurantAddressTopView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantAddressTopView.h"
#import "LocalCommon.h"


@interface OpenRestaurantAddressTopView () <UITextFieldDelegate>
{
    UILabel *_titleLabel;
    
    UIImageView *_thumalImgView;
    
    UIView *_txtBg;
    
    UIButton *_btnSearch;
    
    UITextField *_txtSearchField;
}

- (void)initWithTitleLabel;

- (void)initWithThumalImgView;

- (void)initWithTxtBg;

- (void)initWithBtnSearch;

- (void)initWithTxtSearchField;

@end

@implementation OpenRestaurantAddressTopView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithTitleLabel];
    
    [self initWithThumalImgView];
    
    [self initWithTxtBg];
    
    [self initWithBtnSearch];
    
    [self initWithTxtSearchField];
}

- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(15, 0, [[UIScreen mainScreen] screenWidth] - 30, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentCenter];
    _titleLabel.centerY = self.height / 2;
    _titleLabel.text = @"餐厅在哪个城市呢？";
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"kaicanting_icon_add"];
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

- (void)initWithBtnSearch
{
//    UIImage *image = [UIImage imageNamed:@"kaicanting_btn_positioning"];
    CGRect frame = CGRectMake(0, 0, _txtBg.height, _txtBg.height);
    _btnSearch = [TYZCreateCommonObject createWithButton:self imgNameNor:@"kaicanting_btn_positioning" imgNameSel:@"kaicanting_btn_positioning" targetSel:@selector(clickedButton:)];
    _btnSearch.frame = frame;
    _btnSearch.right = _txtBg.width;
    [_txtBg addSubview:_btnSearch];
}

- (void)initWithTxtSearchField
{
    NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:@"请输入城市名称" attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#cccccc"]}];
    CGRect frame = CGRectMake(15, 5, _btnSearch.left - 15 - 10, 30);
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
    NSString *address = _txtSearchField.text;
    if (!address || [address isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入城市名称"];
        return;
    }
    [self endEditing:YES];
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(address);
    }
}

#pragma mask UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickedButton:nil];
    return YES;
}

@end






















