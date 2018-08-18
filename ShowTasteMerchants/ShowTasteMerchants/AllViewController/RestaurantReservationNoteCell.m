//
//  RestaurantReservationNoteCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantReservationNoteCell.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"


@interface RestaurantReservationNoteCell () <UITextViewDelegate>
{
    TYZPlaceholderTextView *_noteTextView;
}

- (void)initWithNoteTextView;

@end

@implementation RestaurantReservationNoteCell

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithNoteTextView];
    
}

- (void)initWithNoteTextView
{
    CGRect frame = CGRectMake(10, 0, [[UIScreen mainScreen] screenWidth] - 20, kRestaurantReservationNoteCellHeight);
    _noteTextView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _noteTextView.delegate = self;
    _noteTextView.placeholder = @"添加备注信息，以便我们匹配合适的餐位。";
    _noteTextView.font = FONTSIZE_15;
//    _noteTextView.text = objectNull(_foodImageEntity.desc);
    _noteTextView.textColor = [UIColor colorWithHexString:@"#323232"];
    _noteTextView.returnKeyType = UIReturnKeyDone;
    _noteTextView.keyboardType = UIKeyboardAppearanceDefault;
    [self.contentView addSubview:_noteTextView];
//    _noteTextView.backgroundColor = [UIColor redColor];
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
    
}

@end
