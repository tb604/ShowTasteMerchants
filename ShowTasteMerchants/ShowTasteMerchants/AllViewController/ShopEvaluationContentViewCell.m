//
//  ShopEvaluationContentViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopEvaluationContentViewCell.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"
#import "CommentInputDataEntity.h"
#import "UIImageView+WebCache.h"
#import "RestaurantImageEntity.h"


@interface ShopEvaluationContentViewCell () <UITextViewDelegate>
{
    /**
     *  输入点评内容
     */
    TYZPlaceholderTextView *_recommentTxtView;
    
    UIImageView *_addImgView;
    
    NSMutableArray *_imageViewList;
}

@property (nonatomic, strong) CommentInputDataEntity *commentInputEntity;

// comment_icon_photo

- (void)initWithRecommentTxtView;

- (void)initWithImageViews;

- (void)initWithAddImgView;

- (void)tapGestureAddImg:(UITapGestureRecognizer *)tap;

@end

@implementation ShopEvaluationContentViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _imageViewList = [NSMutableArray new];
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithRecommentTxtView];
    
    [self initWithAddImgView];
    
    [self initWithImageViews];
    
}

- (void)initWithRecommentTxtView
{
    CGRect frame = CGRectMake(10, 10, [[UIScreen mainScreen] screenWidth] - 20, 65);
    _recommentTxtView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _recommentTxtView.delegate = self;
    _recommentTxtView.placeholder = @"写下您在本餐厅就餐的感受。";
    _recommentTxtView.font = FONTSIZE_15;
//    _recommentTxtView.text = objectNull(_foodImageEntity.desc);
    _recommentTxtView.textColor = [UIColor colorWithHexString:@"#323232"];
    _recommentTxtView.returnKeyType = UIReturnKeyDone;
    _recommentTxtView.keyboardType = UIKeyboardAppearanceDefault;
    [self.contentView addSubview:_recommentTxtView];
//    _recommentTxtView.backgroundColor = [UIColor lightGrayColor];
}

- (void)initWithAddImgView
{
    if (!_addImgView)
    {
        CGRect frame = CGRectMake(15, _recommentTxtView.bottom + 5, [[self class] getWithImageWidth], [[self class] getWithImageWidth]);
        _addImgView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:_addImgView];
        //    _addImgView.contentMode = UIViewContentModeScaleAspectFit
        _addImgView.layer.borderColor = [UIColor colorWithHexString:@"#cacaca"].CGColor;
        _addImgView.layer.borderWidth = 1;
        
        UIImage *image = [UIImage imageNamed:@"comment_icon_photo"];
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = image;
        [_addImgView addSubview:imgView];
        imgView.center = CGPointMake(_addImgView.width / 2, _addImgView.height / 2);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAddImg:)];
        [_addImgView addGestureRecognizer:tap];
        _addImgView.userInteractionEnabled = YES;
    }
}

- (void)initWithImageViews
{
    CGFloat width = [[self class] getWithImageWidth];
    CGRect frame = CGRectMake(15, _recommentTxtView.bottom + 5, width, width);
    for (NSInteger i=0; i<3; i++)
    {
        frame.origin.x = 15 + i * (10 + width);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.tag = 100 + i;
//        imgView.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:imgView];
        imgView.hidden = YES;
        [_imageViewList addObject:imgView];
    }
}

- (void)tapGestureAddImg:(UITapGestureRecognizer *)tap
{
    if (_addImageBlock)
    {
        _addImageBlock();
    }
    
}

+ (NSInteger)getWithImageWidth
{
//    NSInteger width = ceilf([[UIScreen mainScreen] screenWidth] / 4.8);
    NSInteger count = 3;
    NSInteger width = ([[UIScreen mainScreen] screenWidth] - 30 - 10 * (count - 1)) / count;
    return width;
}

+ (CGFloat)getWithCellHeight
{
    return (10 + 65 + 5 + [self getWithImageWidth] + 15);
}

- (void)updateCellData:(id)cellEntity
{
    self.commentInputEntity = cellEntity;
    _recommentTxtView.text = _commentInputEntity.content;
    
    for (UIImageView *imgView in _imageViewList)
    {
        imgView.hidden = YES;
    }
    
    NSInteger j = 0;
    
    for (RestaurantImageEntity *imgEnt in _commentInputEntity.images)
    {
        UIImageView *imgView = [_imageViewList objectOrNilAtIndex:j];
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgEnt.name] placeholderImage:nil];
        imgView.hidden = NO;
        j++;
    }
    
    _addImgView.hidden = YES;
    
    if ([_commentInputEntity.images count] != 3)
    {
        UIImageView *imgView = [_imageViewList objectOrNilAtIndex:j];
        _addImgView.frame = imgView.frame;
        _addImgView.hidden = NO;
    }
    
    /*if (j == 0)
    {
        UIImageView *imgView = nil;
        if ([_commentInputEntity.images count] != 0)
        {
            imgView = [_imageViewList objectOrNilAtIndex:j+1];
        }
        else
        {
            imgView = [_imageViewList objectOrNilAtIndex:j];
        }
        _addImgView.frame = imgView.frame;
        _addImgView.hidden = NO;
    }
    else if (j == 1)
    {
        UIImageView *imgView = [_imageViewList objectOrNilAtIndex:j+1];
        _addImgView.frame = imgView.frame;
        _addImgView.hidden = NO;
    }*/
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    debugMethod();
//    CGFloat cheight = _contentView.height;
//    CGFloat mut = cheight - _introTextView.bottom;
//    debugLog(@"mut=%.2f", mut);
//    if (mut < 216+40)
//    {
//        _contentView.contentOffset = CGPointMake(0, mut);
//    }
    if (_editStateBlock)
    {
        _editStateBlock(1);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //    debugMethod();
//    _contentView.contentOffset = CGPointMake(0, 0);
    if (_editStateBlock)
    {
        _editStateBlock(2);
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
        
        return YES;
    }
    return YES;
}



@end
