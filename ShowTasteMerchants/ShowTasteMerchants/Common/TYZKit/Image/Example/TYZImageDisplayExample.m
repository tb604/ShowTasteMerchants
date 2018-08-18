//
//  TYZImageDisplayExample.m
//  51tourGuide
//
//  Created by 唐斌 on 16/4/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZImageDisplayExample.h"
#import "TYZKit.h"
#import "TYZImageExampleHelper.h"

@interface TYZImageDisplayExample () <UIGestureRecognizerDelegate>
{
    UIScrollView *_scrollView;
}

- (void)initWithScrollView;

@end

@implementation TYZImageDisplayExample

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithScrollView];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.size = CGSizeMake(_scrollView.width, 60);
    label.top = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"Tap the image to pause/play\n Slide on the image to forward/rewind";
    [_scrollView addSubview:label];
    
    [self addImageWithName:@"niconiconi" text:@"Animated GIF"];
    [self addImageWithName:@"wall-e" text:@"Animated WebP"];
    [self addImageWithName:@"pia" text:@"Animated PNG (APNG)"]; // 有我呢提
    [self addFrameImageWithText:@"Frame Animation"];
    [self addSpriteSheetImageWithText:@"Sprite sheet Animation"];
    
    _scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
}

- (void)initWithScrollView
{
    _scrollView = [UIScrollView new];
    _scrollView.frame = self.view.bounds;
//    _scrollView.backgroundColor = [UIColor purpleColor];
    _scrollView.height = _scrollView.height - 64;
    [self.view addSubview:_scrollView];
}

- (void)addImageWithName:(NSString *)name text:(NSString *)text
{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"cube@2x.png" ofType:nil];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSLog(@"data.len=%lld", (long long)data.length);
    TYZImage *image = [TYZImage imageNamed:name];
    [self addImage:image size:CGSizeZero text:text];
}

- (void)addFrameImageWithText:(NSString *)text
{
    NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"EmoticonWeibo.bundle/com.sina.default"];
    NSMutableArray *paths = [NSMutableArray new];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_aini@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_baibai@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chanzui@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chijing@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_dahaqi@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_guzhang@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haha@2x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haixiu@3x.png"]];
    
    UIImage *image = [[TYZFrameImage alloc] initWithImagePaths:paths oneFrameDuration:0.1 loopCount:0];
    [self addImage:image size:CGSizeZero text:text];
}

- (void)addSpriteSheetImageWithText:(NSString *)text
{
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"ResourceTwitter.bundle/fav02l-sheet@2x.png"];
    UIImage *sheet = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path] scale:2];
    NSMutableArray *contentRects = [NSMutableArray new];
    NSMutableArray *durations = [NSMutableArray new];
    
    
    // 8 * 12 sprites in a single sheet image
    CGSize size = CGSizeMake(sheet.size.width / 8, sheet.size.height / 12);
    for (int j = 0; j < 12; j++)
    {
        for (int i = 0; i < 8; i++)
        {
            CGRect rect;
            rect.size = size;
            rect.origin.x = sheet.size.width / 8 * i;
            rect.origin.y = sheet.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1 / 60.0)];
        }
    }
    TYZSpriteSheetImage *sprite;
    sprite = [[TYZSpriteSheetImage alloc] initWithSpriteSheetImage:sheet
                                                     contentRects:contentRects
                                                   frameDurations:durations
                                                        loopCount:0];
    [self addImage:sprite size:size text:text];
}

- (void)addImage:(UIImage *)image size:(CGSize)size text:(NSString *)text
{
    TYZAnimatedImageView *imageView = [[TYZAnimatedImageView alloc] initWithImage:image];
    if (size.width > 0 && size.height > 0)
    {
        imageView.size = size;
    }
    imageView.centerX = self.view.width / 2;
    imageView.top = [(UIView *)[_scrollView.subviews lastObject] bottom] + 30;
    [_scrollView addSubview:imageView];
    imageView.backgroundColor = [UIColor orangeColor];

    
    
    [TYZImageExampleHelper addTapControlToAnimatedImageView:imageView];
    [TYZImageExampleHelper addPanControlToAnimatedImageView:imageView];
    for (UIGestureRecognizer *g in imageView.gestureRecognizers)
    {
        g.delegate = self;
    }

    
    
    
    
    
    UILabel *imageLabel = [UILabel new];
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.frame = CGRectMake(0, 0, self.view.width, 20);
    imageLabel.top = imageView.bottom + 10;
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.text = text;
    [_scrollView addSubview:imageLabel];
    
    _scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom + 20);
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end














