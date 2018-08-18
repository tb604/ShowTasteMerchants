//
//  ShopCommentViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/8/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ShopCommentViewCell.h"
#import "LocalCommon.h"
#import "ShopCommentDataEntity.h"
#import "CommentInfoDataEntity.h"
#import "UIImageView+WebCache.h"
#import "TYZStarRateView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "AlbsImageInfoEntity.h"

@interface ShopCommentViewCell ()
{
    /**
     *  头像
     */
    UIImageView *_headerImgView;
    
    /**
     *  姓名、昵称
     */
    UILabel *_nameLabel;
    
    UILabel *_createDateLabel;
    // TYZStarRateView.h
    
    TYZStarRateView *_starRateView;
    
    /**
     *  评论内容
     */
    UILabel *_commentContentLabel;
    
    NSMutableArray *_imgList;
}

@property (nonatomic, strong) CALayer *topLine;

@property (nonatomic, strong) CALayer *line;

@property (nonatomic, strong) ShopCommentDataEntity *commentEntity;
@property (nonatomic, strong) CommentInfoDataEntity *commentEnt;

- (void)initWithHeaderImgView;

- (void)initWithNameLabel;

- (void)initWithCreateDateLabel;

- (void)initWithStarRateView;

- (void)initWithCommentContentLabel;

- (void)touchImageTapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ShopCommentViewCell

- (void)initWithVarCell
{
    [super initWithVarCell];
    
    _imgList = [NSMutableArray new];
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    self.topLine = [CALayer drawLine:self.contentView frame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    
    [self initWithHeaderImgView];
    
    [self initWithNameLabel];
    
    [self initWithCreateDateLabel];
    
    [self initWithStarRateView];
    
    [self initWithCommentContentLabel];
    
    [self initWithReviewImgList];
    
    CALayer *line = [CALayer drawLine:self.contentView frame:CGRectMake(15, kShopCommentViewCellHeight, [[UIScreen mainScreen] screenWidth] - 30, 0.6) lineColor:[UIColor colorWithHexString:@"#e0e0e0"]];
    self.line = line;
}

- (void)initWithHeaderImgView
{
    if (!_headerImgView)
    {
        CGRect frame = CGRectMake(15, 15, 36, 36);
        _headerImgView = [[UIImageView alloc] initWithFrame:frame];
        _headerImgView.image = [UIImage imageNamed:@"head_default"];
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.layer.cornerRadius = frame.size.width / 2;
        _headerImgView.layer.borderColor = [UIColor colorWithHexString:@"#e0e0e0"].CGColor;
        _headerImgView.layer.borderWidth = 1;
        [self.contentView addSubview:_headerImgView];
    }
}

- (void)initWithNameLabel
{
    if (!_nameLabel)
    {
        CGRect frame = CGRectMake(_headerImgView.right + 10, 0, ([[UIScreen mainScreen] screenWidth] - _headerImgView.right) / 2 - 10 - 15, 20);
        _nameLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
//        _nameLabel.backgroundColor = [UIColor lightGrayColor];
        _nameLabel.centerY = _headerImgView.centerY;
    }
}

- (void)initWithCreateDateLabel
{
    if (!_createDateLabel)
    {
        NSString *str = @"2016-10-12";
        CGFloat width = [str widthForFont:FONTSIZE_13] + 3;
        CGRect frame = CGRectMake(0, 15, width, 16);
        _createDateLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentRight];
        _createDateLabel.right = [[UIScreen mainScreen] screenWidth] - 15;
    }
}

- (void)initWithStarRateView
{
    if (!_starRateView)
    {
        UIImage *image = [UIImage imageNamed:@"star_nor"];
        CGRect frame = CGRectMake(0, 0, (image.size.width*0.8)*5+2*(5-1), image.size.height*0.8);
        _starRateView = [[TYZStarRateView alloc] initWithFrame:frame numberOfStars:5 isRecognizer:NO];
        _starRateView.right = [[UIScreen mainScreen] screenWidth] - 15;
//        _starRateView.top = _createDateLabel.bottom + 5;
        _starRateView.bottom = _headerImgView.bottom;
        [self.contentView addSubview:_starRateView];
        _starRateView.scorePercent = 1;
//        _starRateView.centerY = _thumalImgView.centerY;
    }
}

- (void)initWithCommentContentLabel
{
    if (!_commentContentLabel)
    {
        CGRect frame = CGRectMake(_headerImgView.right + 10, _starRateView.bottom + 15, [[UIScreen mainScreen] screenWidth] - _headerImgView.right - 10 - 15, 20);
        _commentContentLabel = [TYZCreateCommonObject createWithLabel:self.contentView labelFrame:frame textColor:[UIColor colorWithHexString:@"#323232"] fontSize:FONTSIZE_15 labelTag:0 alignment:NSTextAlignmentLeft];
        _commentContentLabel.numberOfLines = 0;
    }
}

- (void)initWithReviewImgList
{
    CGFloat imgWidth = ([[UIScreen mainScreen] screenWidth] - _headerImgView.right - 10 - 15 - 8 *2) / 3.0;
    CGRect frame = CGRectMake(0, _commentContentLabel.bottom+5, imgWidth, imgWidth);
    for (NSInteger i=0; i<3; i++)
    {
        frame.origin.x = _nameLabel.left + i*(imgWidth+8);
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
    if (_commentEntity)
    {
        images = _commentEntity.images;
    }
    else if (_commentEnt)
    {
        images = _commentEnt.images;
    }
    
    if ([images count] == 0)
    {
        return;
    }
    
    for (NSInteger i=0; i<images.count; i++)
    {
        RestaurantImageEntity *comEnt = images[i];
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

- (void)hiddenWithLine:(BOOL)hidden
{
    self.line.hidden = hidden;
}

- (void)hiddenWithTopLine:(BOOL)hidden
{
    _topLine.hidden = hidden;
}

- (void)updateCellData:(id)cellEntity
{
    // CommentInfoDataEntity
    NSString *avatar = nil;
    NSString *name = nil;
    NSString *createDate = nil;
    NSInteger score = 0.0;
    NSString *content = nil;
    CGFloat contentHeight = 0;
    NSArray *images = nil;
//    debugLog(@"cell=%@", [cellEntity modelToJSONString]);
    if ([cellEntity isKindOfClass:[CommentInfoDataEntity class]])
    {
        self.commentEnt = cellEntity;
        avatar = _commentEnt.user_avatar;
        name = _commentEnt.user_name;
        createDate = _commentEnt.create_datetime;
        score = _commentEnt.score;
        content = _commentEnt.content;
        contentHeight = _commentEnt.contentHeight;
        images = _commentEnt.images;
    }
    else
    {
        self.commentEntity = cellEntity;
        avatar = _commentEntity.avatar;
        name = _commentEntity.name;
        createDate = _commentEntity.create_datetime;
        score = _commentEntity.score;
        content = _commentEntity.content;
        contentHeight = _commentEntity.contentHeight;
        images = _commentEntity.images;
    }
    
    NSString *headerUrl = [NSString stringWithFormat:@"%@?t=%@&imageView2/0/q/40", avatar, [NSDate stringWithCurrentTimeStamp]];
    
//    debugLog(@"ent=%@", [_commentEntity modelToJSONString]);
    
    // 头像
    [_headerImgView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];
    
    // 姓名
//    NSString *name = objectNull(name);
    if ([name isEqualToString:@""])
    {
        name = @"游客";
    }
    _nameLabel.text = name;
    
    // 评论时间
    NSString *date = [NSDate stringWithDateInOut:createDate inFormat:@"yyyy-MM-dd HH:mm:ss" outFormat:@"yyyy-MM-dd"];
    _createDateLabel.text = date;
    
    // 评分
    _starRateView.scorePercent = 0.2 * score;
    
    // 评论内容
    _commentContentLabel.text = content;
    _commentContentLabel.height = contentHeight;
    
    NSInteger count = images.count;
    if (count != 0)
    {
        for (NSInteger i=0; i<_imgList.count; i++)
        {
            UIImageView *imgView = _imgList[i];
            if (i < count)
            {
                RestaurantImageEntity *entity = images[i];
                debugLog(@"image=%@", entity.name);
                [imgView sd_setImageWithURL:[NSURL URLWithString:entity.name] placeholderImage:nil];
                imgView.top = _commentContentLabel.bottom + 5;
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
    
    
    
    CGFloat height = kShopCommentViewCellHeight - 20 + contentHeight;
    if ([images count] > 0)
    {
        CGFloat imgWidth = ([[UIScreen mainScreen] screenWidth] - _headerImgView.right - 10 - 15 - 8 *2) / 3.0;
        height = height + imgWidth + 5;
    }
    _line.bottom = height;
}

@end

































