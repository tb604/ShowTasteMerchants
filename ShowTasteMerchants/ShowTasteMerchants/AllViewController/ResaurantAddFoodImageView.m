//
//  ResaurantAddFoodImageView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/8.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ResaurantAddFoodImageView.h"
#import "LocalCommon.h"

@interface ResaurantAddFoodImageView ()
{
    /**
     *  menu_edit_icon_photo
     */
    UIImageView *_thumalImgView;
    
    UILabel *_descLabel;
}

- (void)initWithSubView;

- (void)initWithThumalImgView;

- (void)initWithDescLabel;

- (void)tapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation ResaurantAddFoodImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    [self initWithThumalImgView];
    
    [self initWithDescLabel];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
}

- (void)initWithThumalImgView
{
    UIImage *image = [UIImage imageNamed:@"menu_edit_icon_photo"];
    CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
    _thumalImgView = [[UIImageView alloc] initWithFrame:frame];
    _thumalImgView.image = image;
    _thumalImgView.centerX = self.width / 2;
    _thumalImgView.bottom = self.height / 2 + 10;
    [self addSubview:_thumalImgView];
}

- (void)initWithDescLabel
{
    CGRect frame = CGRectMake(15, _thumalImgView.bottom + 10, self.width - 30, 20);
    _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cccccc"] fontSize:FONTSIZE_11 labelTag:0 alignment:NSTextAlignmentCenter];
    _descLabel.text = @"请上传一张精美的菜品图片";
}

- (void)updateWithTitle:(NSString *)title
{
    _descLabel.text = title;
}

- (void)hiddenWithThumalImage:(BOOL)hidden
{
    _descLabel.hidden = hidden;
    _thumalImgView.hidden = hidden;
}

- (void)tapGesture:(UITapGestureRecognizer *)tap
{
    if (_touchUploadImageBlock)
    {
        _touchUploadImageBlock();
    }
}

+ (NSInteger)getWithHeight
{
    return ceilf([[UIScreen mainScreen] screenWidth] / 1.6);//  1.875
}


@end
