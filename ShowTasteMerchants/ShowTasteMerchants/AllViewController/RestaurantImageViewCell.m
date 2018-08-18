//
//  RestaurantImageViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/13.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantImageViewCell.h"
#import "LocalCommon.h"
#import "RestaurantImageView.h"
#import "RestaurantImageEntity.h"
#import "UIImageView+WebCache.h"
#import "RestaurantDetailDataEntity.h"
#import "RestaurantImageEntity.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface RestaurantImageViewCell ()
{
    /**
     *  添加图片按钮
     */
    UIButton *_btnAddImage;
    
    NSMutableArray *_addImageList;
    
    /**
     *  首图
     */
    RestaurantImageView *_mainImgView;
    
    /**
     *  大堂照片1
     */
    RestaurantImageView *_hallOneImgView;
    
    /**
     *  大堂照片2
     */
    RestaurantImageView *_hallTwoImgView;
    
    /**
     *  大包间照片
     */
    RestaurantImageView *_roomBigImgView;
    
    /**
     *  小包间照片
     */
    RestaurantImageView *_roomSmallImgView;
    
    /**
     *  景观照片
     */
    RestaurantImageView *_landscapeImgView;
}

/**
 *  首图
 */
@property (nonatomic, strong) RestaurantImageView *mainImgView;

/**
 *  大堂照片1
 */
@property (nonatomic, strong) RestaurantImageView *hallOneImgView;

/**
 *  大堂照片2
 */
@property (nonatomic, strong) RestaurantImageView *hallTwoImgView;

/**
 *  大包间照片
 */
@property (nonatomic, strong) RestaurantImageView *roomBigImgView;

/**
 *  小包间照片
 */
@property (nonatomic, strong) RestaurantImageView *roomSmallImgView;

/**
 *  景观照片
 */
@property (nonatomic, strong) RestaurantImageView *landscapeImgView;

@property (nonatomic, strong) RestaurantDetailDataEntity *detailEntity;

/**
 *  图片信息数组
 */
@property (nonatomic, strong) NSMutableArray *imageInfoList;

/**
 *  首图
 */
- (void)initWithMainImgView;

/**
 *  大堂照片1
 */
- (void)initWithHallOneImgView;

/**
 *  大堂照片2
 */
- (void)initWithHallTwoImgView;

/**
 *  大包间
 */
- (void)initWithRoomBigImgView;

/**
 *  小包间
 */
- (void)initWithRoomSmallImgView;

/**
 *  景观照片
 */
- (void)initWithLandscapeImgView;


- (void)initWithBtnAddImage;

- (void)addAllImgView;

@end

@implementation RestaurantImageViewCell

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
    
//    _addImageList = [NSMutableArray new];
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    self.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
//    [self initWithBtnAddImage];
    
    // 首图
    [self initWithMainImgView];
    
    // 大堂照片1
    [self initWithHallOneImgView];
    
    // 大堂照片2
    [self initWithHallTwoImgView];
    
    // 大包间
    [self initWithRoomBigImgView];
    
    // 小包间
    [self initWithRoomSmallImgView];
    
    // 景观照片
    [self initWithLandscapeImgView];

}

- (void)initWithMainImgView
{
    CGRect frame = CGRectMake(0, 5, [[self class] getRestaurantImgViewHeight], [[self class] getRestaurantImgViewHeight]);
    _mainImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _mainImgView.backgroundColor = [UIColor whiteColor];
    _mainImgView.tag = 100;
    [self.contentView addSubview:_mainImgView];
    [_mainImgView updateWithTitle:@"形象照片" desc:@"（门头或背景墙等）"];
    __weak typeof(self)weakSelf = self;
    _mainImgView.touchImageViewBlock = ^(id data, int type)
    {
        if (![objectNull(weakSelf.detailEntity.mainImageEntity.name) isEqualToString:@""])
        {
            [weakSelf touchImageView:weakSelf.mainImgView type:type];
        }
    };
}

/**
 *  大堂照片1
 */
- (void)initWithHallOneImgView
{
    CGRect frame = _mainImgView.frame;
    frame.origin.x = _mainImgView.right + 3;
    _hallOneImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _hallOneImgView.backgroundColor = [UIColor whiteColor];
    _hallOneImgView.tag = 101;
    [self.contentView addSubview:_hallOneImgView];
    [_hallOneImgView updateWithTitle:@"大堂照片1" desc:@"（如果没有，可不传）"];
    __weak typeof(self)weakSelf = self;
    _hallOneImgView.touchImageViewBlock = ^(id data, int type)
    {
        if (weakSelf.detailEntity.hallImageList.count >= 1)
        {
            RestaurantImageEntity *imageOne = weakSelf.detailEntity.hallImageList[0];
            if (![objectNull(imageOne.name) isEqualToString:@""])
            {
                [weakSelf touchImageView:weakSelf.hallOneImgView type:type];
            }
        }
    };
}

/**
 *  大堂照片2
 */
- (void)initWithHallTwoImgView
{
    CGRect frame = _mainImgView.frame;
    frame.origin.x = _hallOneImgView.right + 3;
    _hallTwoImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _hallTwoImgView.backgroundColor = [UIColor whiteColor];
    _hallTwoImgView.tag = 102;
    [self.contentView addSubview:_hallTwoImgView];
    [_hallTwoImgView updateWithTitle:@"大堂照片2" desc:@"（如果没有，可不传）"];
    __weak typeof(self)weakSelf = self;
    _hallTwoImgView.touchImageViewBlock = ^(id data, int type)
    {
        if (weakSelf.detailEntity.hallImageList.count >= 2)
        {
            RestaurantImageEntity *imageOne = weakSelf.detailEntity.hallImageList[1];
            if (![objectNull(imageOne.name) isEqualToString:@""])
            {
                [weakSelf touchImageView:weakSelf.hallTwoImgView type:type];
            }
        }
    };
}

/**
 *  大包间
 */
- (void)initWithRoomBigImgView
{
    CGRect frame = _mainImgView.frame;
    frame.origin.y = _mainImgView.bottom + 3;
    _roomBigImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _roomBigImgView.backgroundColor = [UIColor whiteColor];
    _roomBigImgView.tag = 103;
    [self.contentView addSubview:_roomBigImgView];
    [_roomBigImgView updateWithTitle:@"大包间照片" desc:@"（如果没有，可不传）"];
    __weak typeof(self)weakSelf = self;
    _roomBigImgView.touchImageViewBlock = ^(id data, int type)
    {
        if (weakSelf.detailEntity.roomImageList.count >= 1)
        {
            RestaurantImageEntity *imageOne = weakSelf.detailEntity.roomImageList[0];
            if (![objectNull(imageOne.name) isEqualToString:@""])
            {
                [weakSelf touchImageView:weakSelf.roomBigImgView type:type];
            }
        }
    };
}

/**
 *  小包间
 */
- (void)initWithRoomSmallImgView
{
    CGRect frame = _roomBigImgView.frame;
    frame.origin.x = _roomBigImgView.right + 3;
    _roomSmallImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _roomSmallImgView.backgroundColor = [UIColor whiteColor];
    _roomSmallImgView.tag = 104;
    [self.contentView addSubview:_roomSmallImgView];
    [_roomSmallImgView updateWithTitle:@"小包间照片" desc:@"（如果没有，可不传）"];
    __weak typeof(self)weakSelf = self;
    _roomSmallImgView.touchImageViewBlock = ^(id data, int type)
    {
        debugLog(@"小包间.count=%d", (int)weakSelf.detailEntity.roomImageList.count);
        if (weakSelf.detailEntity.roomImageList.count >= 2)
        {
            RestaurantImageEntity *imageOne = weakSelf.detailEntity.roomImageList[1];
            if (![objectNull(imageOne.name) isEqualToString:@""])
            {
                [weakSelf touchImageView:weakSelf.roomSmallImgView type:type];
            }
        }
    };
}

/**
 *  景观照片
 */
- (void)initWithLandscapeImgView
{
    CGRect frame = _roomSmallImgView.frame;
    frame.origin.x = _roomSmallImgView.right + 3;
    _landscapeImgView = [[RestaurantImageView alloc] initWithFrame:frame];
    _landscapeImgView.backgroundColor = [UIColor whiteColor];
    _landscapeImgView.tag = 105;
    [self.contentView addSubview:_landscapeImgView];
    [_landscapeImgView updateWithTitle:@"餐厅景观" desc:@"（如果没有，可不传）"];
    __weak typeof(self)weakSelf = self;
    _landscapeImgView.touchImageViewBlock = ^(id data, int type)
    {
        if (![objectNull(weakSelf.detailEntity.landscapeImageEntity.name) isEqualToString:@""])
        {
            [weakSelf touchImageView:weakSelf.landscapeImgView type:type];
        }
        
    };
}


- (void)initWithBtnAddImage
{
    if (!_btnAddImage)
    {
        CGRect frame = CGRectMake(0, 3, [[self class] getRestaurantImgViewHeight], [[self class] getRestaurantImgViewHeight]);
        _btnAddImage = [TYZCreateCommonObject createWithButton:self imgNameNor:@"kaicanting_phone_addr" imgNameSel:@"kaicanting_phone_addr" targetSel:@selector(addImage:)];
        _btnAddImage.frame = frame;
        _btnAddImage.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [self.contentView addSubview:_btnAddImage];
    }
}

- (void)addImage:(id)sender
{
    if (_restaurantAddImageBlock)
    {
        _restaurantAddImageBlock(nil);
    }
}

- (void)addAllImgView
{
    /*int col = 3;
    CGFloat space = 3;
    CGRect frame = CGRectMake(0, 0, [[self class] getRestaurantImgViewHeight], [[self class] getRestaurantImgViewHeight]);
    NSInteger count = [_imageInfoList count];
    NSInteger j = 0;
    for (int i=0; i<count; i++)
    {
        if ((i % col) == 0)
        {
            if (i == 0)
            {
                frame.origin.x = 0;
                frame.origin.y = space;
            }
            else
            {
                frame.origin.x = 0;
                frame.origin.y = frame.origin.y + frame.size.height + space;
            }
            j = 1;
        }
        else
        {
//            debugLog(@"else =%d", (int)i);
            frame.origin.x = j*(frame.size.width+space);
            j += 1;
        }
        RestaurantImageEntity *entity = [_imageInfoList objectOrNilAtIndex:i];
        RestaurantImageView *imgView = [[RestaurantImageView alloc] initWithFrame:frame];
        imgView.tag = 100 + i;
        imgView.imageEntity = entity;
//        imgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imgView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:entity.name] placeholderImage:nil];
        [_addImageList addObject:imgView];
        __weak typeof(self)weakSelf = self;
        imgView.touchImageViewBlock = ^(id data, int type)
        {// type 1表示点击；2表示长按
            [weakSelf touchImageView:data type:type];
        };
    }*/
}

/**
 *
 *
 *  @param data data
 *  @param type type 1表示点击；2表示长按
 */
- (void)touchImageView:(id)data type:(int)type
{
    UIImageView *imgView = data;
    debugLog(@"tag=%d", (int)imgView.tag);
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:0];
//    NSArray *images = _detailEntity.shopImages;
    NSMutableArray *images = [NSMutableArray new];
    if (![objectNull(_detailEntity.mainImageEntity.name) isEqualToString:@""])
    {
        [images addObject:_detailEntity.mainImageEntity];
    }
    for (RestaurantImageEntity *ent in _detailEntity.hallImageList)
    {
        if (![objectNull(ent.name) isEqualToString:@""])
        {
            [images addObject:ent];
        }
    }
    for (RestaurantImageEntity *ent in _detailEntity.roomImageList)
    {
        if (![objectNull(ent.name) isEqualToString:@""])
        {
            [images addObject:ent];
        }
    }
    if (![objectNull(_detailEntity.landscapeImageEntity.name) isEqualToString:@""])
    {
        [images addObject:_detailEntity.landscapeImageEntity];
    }
//    debugLog(@"imcount=%d", (int)[images count]);
    NSInteger count = [images count];
    if (count == 0)
    {
        return;
    }
    for (NSInteger i=0; i<count; i++)
    {
        RestaurantImageEntity *comEnt = images[i];
        /*if ([objectNull(comEnt.name) isEqualToString:objectNull(_detailEntity.busLicImageEntity.name)] || [objectNull(comEnt.name) isEqualToString:objectNull(_detailEntity.busCertImageEntity.name)] || [objectNull(comEnt.name) isEqualToString:objectNull(_detailEntity.HealthCertOneImageEntity.name)] || [objectNull(comEnt.name) isEqualToString:objectNull(_detailEntity.HealthCertTwoImageEntity.name)])
        {
            continue;
        }*/
        //        AlbsImageInfoEntity *entity = images[i];
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:comEnt.name];
        debugLog(@"url=%@", comEnt.name);
        //        photo.imageInfoContent = entity.albsDesc;
        photo.srcImageView = imgView;
        [photos addObject:photo];
    }
    
    if ([photos count] == 0)
    {
        return;
    }
    
    // 显示相册
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时候，显示第几张图片
    photoBrowser.currentPhotoIndex = imgView.tag - 100;
    photoBrowser.photos = photos;
    [photoBrowser show];
    
    
//    debugLog(@"type=%d", type);
//    if (type == 2)
//    {
//        if (self.baseTableViewCellBlock)
//        {
//            self.baseTableViewCellBlock(data);
//        }
//    }
}

+ (NSInteger)getRestaurantImgCellMinHeight:(NSInteger)count
{
    NSInteger height = 0;
    int col = 3;
    int row = 1;
    if (count == 0)
    {
        height = 5.0 * 2 + [self getRestaurantImgViewHeight];
    }
    else
    {
        row = ceilf(count / (float)col);
//        debugLog(@"row=%d", row);
        height = 5.0 * 2 + 3.0 * (row-1) + [self getRestaurantImgViewHeight]*row;
    }
    return height;
}

+ (NSInteger)getRestaurantImgViewHeight
{
    NSInteger count = 3;
    CGFloat midSpace = 3;
    int width = ([[UIScreen mainScreen] screenWidth] - (count - 1) * midSpace) / count;
    return width;
}

- (void)updateCellData:(id)cellEntity
{
//    self.imageInfoList = cellEntity;
    self.detailEntity = cellEntity;
    
    debugLog(@"image.count=%d", (int)_detailEntity.shopImages.count);
    
    // 首图
    if ([objectNull(_detailEntity.mainImageEntity.name) isEqualToString:@""])
    {
        [_mainImgView hiddenLabel:NO];
    }
    else
    {
        [_mainImgView hiddenLabel:YES];
        [_mainImgView sd_setImageWithURL:[NSURL URLWithString:_detailEntity.mainImageEntity.name] placeholderImage:nil];
    }
    
    // 大堂图片
    [_hallTwoImgView hiddenLabel:NO];
    [_hallOneImgView hiddenLabel:NO];
    if ([_detailEntity.hallImageList count] > 0)
    {
        RestaurantImageEntity *imageOne = _detailEntity.hallImageList[0];
        if (![objectNull(imageOne.name) isEqualToString:@""])
        {
            [_hallOneImgView hiddenLabel:YES];
            [_hallOneImgView sd_setImageWithURL:[NSURL URLWithString:imageOne.name] placeholderImage:nil];
        }
        
         if ([_detailEntity.hallImageList count] >= 2)
         {
            RestaurantImageEntity *imageTwo = _detailEntity.hallImageList[1];
            if (![objectNull(imageTwo.name) isEqualToString:@""])
            {
                [_hallTwoImgView hiddenLabel:YES];
                [_hallTwoImgView sd_setImageWithURL:[NSURL URLWithString:imageTwo.name] placeholderImage:nil];
            }
         }
    }
    
    // 包间的图片
    [_roomBigImgView hiddenLabel:NO];
    [_roomSmallImgView hiddenLabel:NO];
    if ([_detailEntity.roomImageList count] > 0)
    {
        RestaurantImageEntity *imageOne = _detailEntity.roomImageList[0];
        if (![objectNull(imageOne.name) isEqualToString:@""])
        {
            [_roomBigImgView hiddenLabel:YES];
            [_roomBigImgView sd_setImageWithURL:[NSURL URLWithString:imageOne.name] placeholderImage:nil];
        }
        
        if ([_detailEntity.roomImageList count] >= 2)
        {
            RestaurantImageEntity *imageOne = _detailEntity.roomImageList[1];
            if (![objectNull(imageOne.name) isEqualToString:@""])
            {
                [_roomSmallImgView hiddenLabel:YES];
                [_roomSmallImgView sd_setImageWithURL:[NSURL URLWithString:imageOne.name] placeholderImage:nil];
            }
        }
    }
    
    // 餐厅景观图片
    [_landscapeImgView hiddenLabel:NO];
    if (![objectNull(_detailEntity.landscapeImageEntity.name) isEqualToString:@""])
    {
        [_landscapeImgView hiddenLabel:YES];
        [_landscapeImgView sd_setImageWithURL:[NSURL URLWithString:_detailEntity.landscapeImageEntity.name] placeholderImage:nil];
    }
//    debugLog(@"count=%d", (int)[_imageInfoList count]);
    /*[self addAllImgView];
    
    NSInteger count = [_addImageList count];
    _btnAddImage.hidden = NO;
    if (count >= 9)
    {
        _btnAddImage.hidden = YES;
        return;
    }
    CGRect frame = CGRectZero;
    if (((count % 3) == 0) && count != 0)
    {
//        debugLog(@"if");
        RestaurantImageView *view = [_addImageList lastObject];
        frame = view.frame;
        frame.origin.x = 0;
        frame.origin.y = view.bottom + 3;
    }
    else if (count == 0)
    {
//        debugLog(@"else if");
        frame.origin.x = 0;
        frame.origin.y = 3;
        frame.size = _btnAddImage.size;
    }
    else
    {
//        debugLog(@"else");
//        debugLog(@"====%d", [_addImageList count]);
        RestaurantImageView *view = _addImageList[count-1];
        
//        debugLog(@"tag=%d", (int)view.tag);
        frame = view.frame;

        frame.origin.x = view.right + 3;
    }

    _btnAddImage.frame = frame;
     */
}

@end



















