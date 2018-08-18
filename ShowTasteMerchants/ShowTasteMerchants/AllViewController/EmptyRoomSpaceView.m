//
//  EmptyRoomSpaceView.m
//  ChefDating
//
//  Created by 唐斌 on 16/9/2.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "EmptyRoomSpaceView.h"
#import "LocalCommon.h"

@interface EmptyRoomSpaceView ()

@end

@implementation EmptyRoomSpaceView

- (void)initWithSubView
{
    [super initWithSubView];
    
    
    CGRect frame = self.bounds;
    UIImage *image = [UIImage imageWithContentsOfFileName:@"space_bg.png"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:frame];
    bgImgView.alpha = 0.5;
    bgImgView.image = image;
    [self addSubview:bgImgView];
//    bgImgView.userInteractionEnabled = NO;
    
    self.userInteractionEnabled = NO;
}

@end
