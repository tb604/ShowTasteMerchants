//
//  TYZPlaceholderTextView.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/29.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZPlaceholderTextView.h"

@interface TYZPlaceholderTextView () <UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeHolderLabel;

/**
 *  是否第一次进入编辑
 */
@property (nonatomic, assign) BOOL isFirstBeganEdit;

- (void)initWithVar;

- (void)initWithSubView;

- (void)initWithPlaceHolderLabel;


- (void)DidChange:(NSNotification *)note;

- (void)DidBeginEditing:(NSNotification *)note;
@end

@implementation TYZPlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_placeHolderLabel removeFromSuperview];
    
#if !__has_feature(objc_arc)
    self.placeholder = nil;
    self.placeholderColor = nil;
    self.placeholderFont = nil;
    [_placeHolderLabel release], _placeHolderLabel = nil;
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithVar];
        
        [self initWithSubView];
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)initWithVar
{
    self.isFirstBeganEdit = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    self.placeholderColor = [UIColor lightGrayColor];
}

- (void)initWithSubView
{
    [self initWithPlaceHolderLabel];
}

- (void)initWithPlaceHolderLabel
{
    float left = 5;
    float top = 2;
    float height = 30;
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, CGRectGetWidth(self.frame)-left*2, height)];
    _placeHolderLabel.font = self.placeholderFont ? self.placeholderFont:self.font;
    _placeHolderLabel.textColor = self.placeholderColor;
    [self addSubview:_placeHolderLabel];
    _placeHolderLabel.text = self.placeholder;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont_
{
    if (_placeholderFont != placeholderFont_)
    {
#if !__has_feature(objc_arc)
        [_placeholderFont release];
        _placeholderFont = [placeholderFont_ retain];
#else
        _placeholderFont = placeholderFont_;
#endif
    }
    _placeHolderLabel.font = _placeholderFont;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeholderFont = font;
    _placeHolderLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self DidChange:nil];
}

- (void)setPlaceholder:(NSString *)placeholder_
{
    if (placeholder_.length == 0 || [placeholder_ isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
    }
    else
    {
        _placeHolderLabel.text = placeholder_;
    }
    
    _placeholder = placeholder_;
}

- (void)DidBeginEditing:(NSNotification *)note
{
    self.isFirstBeganEdit = YES;
}

- (void)DidChange:(NSNotification *)note
{
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
    }
    
    if (self.text.length > 0)
    {
        
        NSString *str = [self.text substringFromIndex:self.text.length-1];
        if ([str isEqualToString:@"\n"] && self.isFirstBeganEdit)
        {
            self.text = [self.text substringToIndex:self.text.length - 1];
            self.isFirstBeganEdit = NO;
        }
        _placeHolderLabel.hidden = YES;
    }
    else
    {
        _placeHolderLabel.hidden = NO;
    }
}

@end
