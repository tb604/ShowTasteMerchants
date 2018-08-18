//
//  RestaurantEditMainImageMultsCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantEditMainImageMultsCell.h"
#import "LocalCommon.h"
#import "RestaurantEditImageView.h"
#import "RestaurantImageEntity.h"
#import "UIImageView+WebCache.h"

@interface RestaurantEditMainImageMultsCell ()
{
    RestaurantEditImageView *_imageViewOne;
    
    RestaurantEditImageView *_imageViewTwo;
}

@property (nonatomic, strong) RestaurantEditImageView *imageViewOne;

@property (nonatomic, strong) RestaurantEditImageView *imageViewTwo;

@property (nonatomic, strong) NSArray *imageLists;


- (void)initWithImageViewOne;

- (void)initWithIMageViewTwo;


@end

@implementation RestaurantEditMainImageMultsCell

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
    
}

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    [self initWithImageViewOne];
    
    [self initWithIMageViewTwo];
}

- (void)initWithImageViewOne
{
    CGRect frame = CGRectMake(10, 10, ([[UIScreen mainScreen] screenWidth] - 30)/2, [[self class] getWithCellHeight] - 20);
    _imageViewOne = [[RestaurantEditImageView alloc] initWithFrame:frame];
    _imageViewOne.tag = 100;
    _imageViewOne.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageViewOne];
    __weak typeof(self)weakSelf = self;
    _imageViewOne.touchwithImgViewBlock = ^(RestaurantEditImageView *view)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            RestaurantImageEntity *ent = view.imageEntity;
            ent.tag = weakSelf.imageViewOne.tag;
            weakSelf.baseTableViewCellBlock(ent);
        }
    };
}

- (void)initWithIMageViewTwo
{
    CGRect frame = _imageViewOne.frame;
    frame.origin.x = _imageViewOne.right + 10;
    _imageViewTwo = [[RestaurantEditImageView alloc] initWithFrame:frame];
    _imageViewTwo.tag = 101;
    _imageViewTwo.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageViewTwo];
    __weak typeof(self)weakSelf = self;
    _imageViewTwo.touchwithImgViewBlock = ^(RestaurantEditImageView *view)
    {
        if (weakSelf.baseTableViewCellBlock)
        {
            RestaurantImageEntity *ent = view.imageEntity;
            ent.tag = weakSelf.imageViewTwo.tag;
            weakSelf.baseTableViewCellBlock(ent);
        }
    };
}

- (void)updateCellData:(id)cellEntity titleOne:(NSString *)titleOne titleTwo:(NSString *)titleTwo
{
    debugMethod();
    self.imageLists = cellEntity;
    if (_imageLists)
    {
        RestaurantImageEntity *imageOneEnt = [_imageLists objectOrNilAtIndex:0];
        _imageViewOne.imageEntity = imageOneEnt;
        if (![objectNull(imageOneEnt.name) isEqualToString:@""])
        {
            [_imageViewOne sd_setImageWithURL:[NSURL URLWithString:imageOneEnt.name] placeholderImage:nil];
            [_imageViewOne updateWithTitle:nil];
        }
        else
        {
            [_imageViewOne updateWithTitle:titleOne];
        }
        RestaurantImageEntity *imageTwoEnt = [_imageLists objectOrNilAtIndex:1];
        _imageViewTwo.imageEntity = imageTwoEnt;
        if (![objectNull(imageTwoEnt.name) isEqualToString:@""])
        {
            [_imageViewTwo sd_setImageWithURL:[NSURL URLWithString:imageTwoEnt.name] placeholderImage:nil];
            [_imageViewTwo updateWithTitle:nil];
        }
        else
        {
            [_imageViewTwo updateWithTitle:titleTwo];
        }
    }
//    if (!_imageEntity)
//    {
//        [_imageView updateWithTitle:title];
//    }
//    else
//    {
//        [_imageView updateWithTitle:nil];
//    }
}

+ (NSInteger)getWithCellHeight
{
    return ceilf([[UIScreen mainScreen] screenWidth] / 2.5);
}



@end
