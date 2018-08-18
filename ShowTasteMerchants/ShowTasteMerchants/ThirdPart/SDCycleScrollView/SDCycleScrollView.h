//
//  SDCycleScrollView.h
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
 UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005.jpg"]];
 backgroundView.frame = self.view.bounds;
 [self.view addSubview:backgroundView];
 
 UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
 demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
 [self.view addSubview:demoContainerView];
 
 self.title = @"轮播Demo";
 
 
 // 情景一：采用本地图片实现
 NSArray *imageNames = @[@"h1.jpg",
 @"h2.jpg",
 @"h3.jpg",
 @"h4.jpg",
 @"h7" // 本地图片请填写全名
 ];
 
 // 情景二：采用网络图片实现
 NSArray *imagesURLStrings = @[
 @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
 @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
 @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
 ];
 
 // 情景三：图片配文字
 NSArray *titles = @[@"新建交流QQ群：185534916 ",
 @"感谢您的支持，如果下载的",
 @"如果代码在使用过程中出现问题",
 @"您可以发邮件到gsdios@126.com"
 ];
 
 CGFloat w = self.view.bounds.size.width;
 
 
 
 // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
 // 本地加载 --- 创建不带标题的图片轮播器
 SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, w, 180) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
 cycleScrollView.delegate = self;
 cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
 [demoContainerView addSubview:cycleScrollView];
 //         --- 轮播时间间隔，默认1.0秒，可自定义
 //cycleScrollView.autoScrollTimeInterval = 4.0;
 
 
 // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
 // 网络加载 --- 创建带标题的图片轮播器
 SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 280, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
 
 cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
 cycleScrollView2.titlesGroup = titles;
 cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
 [demoContainerView addSubview:cycleScrollView2];
 
 //         --- 模拟加载延迟
 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
 });
 
 
 block监听点击方式
 
 cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
 NSLog(@">>>>>  %ld", (long)index);
 };
 
 


// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图3 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

// 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 500, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
cycleScrollView3.imageURLStringsGroup = imagesURLStrings;

[demoContainerView addSubview:cycleScrollView3];


 */

/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

/*
 * 当前版本为1.6 
 * 更新日期：2016.01.10
 */

#import <UIKit/UIKit.h>

typedef enum {
    SDCycleScrollViewPageContolAlimentRight,
    SDCycleScrollViewPageContolAlimentCenter
} SDCycleScrollViewPageContolAliment;

typedef enum {
    SDCycleScrollViewPageContolStyleClassic,        // 系统自带经典样式
    SDCycleScrollViewPageContolStyleAnimated,       // 动画效果pagecontrol
    SDCycleScrollViewPageContolStyleNone            // 不显示pagecontrol
} SDCycleScrollViewPageContolStyle;

@class SDCycleScrollView;

@protocol SDCycleScrollViewDelegate <NSObject>

@optional

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface SDCycleScrollView : UIView



// >>>>>>>>>>>>>>>>>>>>>>>>>>  数据源接口

/** 本地图片数组 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 每张图片对应要显示的文字数组 */
@property (nonatomic, strong) NSArray *titlesGroup;





// >>>>>>>>>>>>>>>>>>>>>>>>>  滚动控制接口

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property(nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property(nonatomic,assign) BOOL autoScroll;

@property (nonatomic, weak) id<SDCycleScrollViewDelegate> delegate;

/** block监听点击方式 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);


// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  自定义样式接口

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;



/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有一张图时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** pagecontrol 样式，默认为动画样式 */
@property (nonatomic, assign) SDCycleScrollViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) SDCycleScrollViewPageContolAliment pageControlAliment;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 当前分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *currentPageDotImage;

/** 其他分页控件小圆标图片 */
@property (nonatomic, strong) UIImage *pageDotImage;



/** 轮播文字label字体颜色 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/** 轮播文字label字体大小 */
@property (nonatomic, strong) UIFont  *titleLabelTextFont;

/** 轮播文字label背景颜色 */
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;

/** 轮播文字label高度 */
@property (nonatomic, assign) CGFloat titleLabelHeight;



/** 初始轮播图（推荐使用） */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<SDCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageURLStringsGroup:(NSArray *)imageURLStringsGroup;


/** 本地图片轮播初始化方式 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame imageNamesGroup:(NSArray *)imageNamesGroup;

/** 本地图片轮播初始化方式2,infiniteLoop:是否无限循环 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop imageNamesGroup:(NSArray *)imageNamesGroup;

// >>>>>>>>>>>>>>>>>>>>>>>>>  清除缓存接口

/** 清除图片缓存（此次升级后统一使用SDWebImage管理图片加载和缓存）  */
+ (void)clearImagesCache;

/** 清除图片缓存（兼容旧版本方法） */
- (void)clearCache;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com