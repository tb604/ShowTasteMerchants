//
//  DinersCancelOrderOtherCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/20.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersCancelOrderOtherCell.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"
#import "CellCommonDataEntity.h"

@interface DinersCancelOrderOtherCell () <UITextViewDelegate>
{
    UIImageView *_chcekImgView;
    
    UILabel *_titleLabel;
    
    UIView *_bgView;
    
    TYZPlaceholderTextView *_noteTextView;
}

@property (nonatomic, strong) CellCommonDataEntity *commonEntity;

- (void)initWithCheckImgView;

- (void)initWithTitleLabel;

- (void)initWithBgView;


- (void)initWithNoteTextView;

@end

@implementation DinersCancelOrderOtherCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithCheckImgView];
    
    [self initWithTitleLabel];
    
    [self initWithBgView];
    
    [self initWithNoteTextView];
    
}

- (void)initWithCheckImgView
{
    UIImage *image = [UIImage imageNamed:@"btn_diners_check_nor"];
    CGSize size = image.size;
    _chcekImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44/2-size.height/2, size.width, size.height)];
    [self.contentView addSubview:_chcekImgView];
}


- (void)initWithTitleLabel
{
    CGRect frame = CGRectMake(_chcekImgView.right + 10, (44 - 20)/2, [[UIScreen mainScreen] screenWidth] - _chcekImgView.right - 15 - 10, 20);
    _titleLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
}

- (void)initWithBgView
{
//    CGRect frame = CGRectMake(15, _chcekImgView.bottom + 10, [[UIScreen mainScreen] screenWidth] - 30, kCancelTripAgencyOtherViewCellHeight - _chcekImgView.bottom - 10 - 10);
//    _bgView = [[UIView alloc] initWithFrame:frame];
//    _bgView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    [self.contentView addSubview:_bgView];
}


- (void)initWithNoteTextView
{
    CGRect frame = CGRectMake(10, 44, [[UIScreen mainScreen] screenWidth] - 20, kDinersCancelOrderOtherCellHeight - 45);
    _noteTextView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _noteTextView.delegate = self;
    _noteTextView.placeholder = @"请输入其它原因";
    _noteTextView.font = FONTSIZE_15;
    //    _noteTextView.text = objectNull(_foodImageEntity.desc);
    _noteTextView.textColor = [UIColor colorWithHexString:@"#323232"];
    _noteTextView.returnKeyType = UIReturnKeyDone;
    _noteTextView.keyboardType = UIKeyboardAppearanceDefault;
    [self.contentView addSubview:_noteTextView];
    _noteTextView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    debugMethod();
    if (_textViewEditBlock)
    {
        _textViewEditBlock(1);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //    debugMethod();
    if (_textViewEditBlock)
    {
        _textViewEditBlock(2);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if (self.baseTableViewCellBlock)
        {
            self.baseTableViewCellBlock(textView.text);
        }
        return NO;
    }
    return YES;
}





- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *commonEntity = cellEntity;
    self.commonEntity = commonEntity;
    _titleLabel.text = commonEntity.title;
    
    if (commonEntity.isCheck)
    {
        _chcekImgView.image = [UIImage imageNamed:commonEntity.checkImgName];
        [_noteTextView setEditable:YES];
    }
    else
    {
        _chcekImgView.image = [UIImage imageNamed:commonEntity.uncheckImgName];
        [_noteTextView setEditable:NO];
    }

}


@end
