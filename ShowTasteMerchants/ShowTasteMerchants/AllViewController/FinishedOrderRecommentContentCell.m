//
//  FinishedOrderRecommentContentCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "FinishedOrderRecommentContentCell.h"
#import "LocalCommon.h"
#import "CommentDetailEntity.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AlbsImageInfoEntity.h"
#import "UIImageView+WebCache.h"

@interface FinishedOrderRecommentContentCell ()
{
    UILabel *_contentLabel;
    
    NSMutableArray *_imgList;
}

- (void)initWithContentLabel;

@property (nonatomic, strong) CommentDetailEntity *commentEntity;

@end

@implementation FinishedOrderRecommentContentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _imgList = [NSMutableArray new];
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.contentView.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
    self.backgroundColor =  [UIColor colorWithHexString:@"#ffffff"];
}

- (void)initWithContentLabel
{
    if (!_contentLabel)
    {
        CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, 20);
        _contentLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
    }
    _contentLabel.height = _commentEntity.contentHeight;
    _contentLabel.text = _commentEntity.content;
}

- (void)initWithReviewImgList
{
    if ([_imgList count] > 0)
    {
        return;
    }
    CGFloat imgWidth = _commentEntity.imgWidth;
    CGRect frame = CGRectMake(0, _contentLabel.bottom+5, imgWidth, imgWidth);
    for (NSInteger i=0; i<3; i++)
    {
        frame.origin.x = 15 + i*(imgWidth+8);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        //        imgView.backgroundColor = [UIColor lightGrayColor];
        imgView.userInteractionEnabled = YES;
        imgView.hidden = YES;
        imgView.tag = 100 + i;
        [_imgList addObject:imgView];
        [self.contentView addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImageTapGesture:)];
        [imgView addGestureRecognizer:tap];
    }
}

- (void)touchImageTapGesture:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *images = nil;
    images = _commentEntity.images;
    
    if ([images count] == 0)
    {
        return;
    }
    
    for (NSInteger i=0; i<images.count; i++)
    {
        CommentImageDataEntity *comEnt = images[i];
        //        AlbsImageInfoEntity *entity = images[i];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:comEnt.name];
        //        photo.imageInfoContent = entity.albsDesc;
        photo.srcImageView = imgView;
        [photos addObject:photo];
    }
    
    // 显示相册
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时候，显示第几张图片
    photoBrowser.currentPhotoIndex = imgView.tag - 100;
    photoBrowser.photos = photos;
    [photoBrowser show];
}


- (void)updateCellData:(id)cellEntity
{
    self.commentEntity = cellEntity;
    
    [self initWithContentLabel];
    
    [self initWithReviewImgList];
    
    
    NSInteger count = _commentEntity.images.count;
    if (count != 0)
    {
        for (NSInteger i=0; i<_imgList.count; i++)
        {
            UIImageView *imgView = _imgList[i];
            if (i < count)
            {
                CommentImageDataEntity *entity = _commentEntity.images[i];
//                debugLog(@"image=%@", entity.name);
                NSString *imgUrl = [NSString stringWithFormat:@"%@?imageView2/0/q/50", entity.name];
                [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
                imgView.top = _contentLabel.bottom + 5;
                imgView.hidden = NO;
            }
            else
            {
                imgView.hidden = YES;
            }
        }
    }
    else
    {
        for (NSInteger i=0; i<_imgList.count; i++)
        {
            ((UIImageView *)_imgList[i]).hidden = YES;
        }
    }
}


@end
