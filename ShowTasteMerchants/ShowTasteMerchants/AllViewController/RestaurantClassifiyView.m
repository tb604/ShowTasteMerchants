//
//  RestaurantClassifiyView.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantClassifiyView.h"
#import "LocalCommon.h"
#import "RestaurantClassifiyBottomView.h"
#import "ClassifiyConditionFiltrateView.h"
#import "ShopTypeFilterInputEntity.h"
#import "RestaurantClassifiySingleView.h"
#import "CuisineTypeDataEntity.h"
#import "CuisineFlavorDataEntity.h"

@interface RestaurantClassifiyView ()
{
    UIScrollView *_contentView;
    
    /**
     *  商圈分类视图
     */
    RestaurantClassifiySingleView *_mallClassifiyView;
    
    /**
     *  传统菜系视图
     */
    RestaurantClassifiySingleView *_traditionCuisineView;
    
    /**
     *  特色菜系视图
     */
    RestaurantClassifiySingleView *_featureCuisinedView;
    
    /**
     *  国际菜系视图
     */
    RestaurantClassifiySingleView *_interCusinedView;
    
    CGFloat _contentHeight;
    
    // icon_xiala
    UIImageView *_xialaImgView;
}

@property (nonatomic, strong) CuisineFlavorDataEntity *flavorEntity;

//@property (nonatomic, strong) NSArray *cuisineList;

@property (nonatomic, strong) RestaurantClassifiyBottomView *bottomView;

@property (nonatomic, assign) CGFloat bottomHeight;

/**
 *  筛选条件
 */
@property (nonatomic, strong) ShopTypeFilterInputEntity *conditionEntity;

@property (nonatomic, strong) CALayer *topLine;

- (void)initWithContentView;

- (void)initWithBottomView;

/**
 *  初始化商圈视图
 */
- (void)initWithMallClassifiyView;

/**
 *  初始化传统菜系视图
 */
- (void)initWithTraditionCuisineView;

/**
 *  初始化特色菜系视图
 */
- (void)initWithFeatureCuisinedView;

/**
 *  初始化国际菜系视图
 */
- (void)initWithInterCusinedView;

- (void)initWithXialaImgView;

@end

@implementation RestaurantClassifiyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame bottomHeight:(CGFloat)bottomHeight
{
    self.bottomHeight = bottomHeight;
    return [self initWithFrame:frame];
}

- (void)initWithVar
{
    [super initWithVar];
    
    _contentHeight = 0.0;
    
    _conditionEntity = [ShopTypeFilterInputEntity new];
}

- (void)initWithSubView
{
    [super initWithSubView];
    
//    self.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [self initWithContentView];
    
    [self initWithBottomView];
    
    // 初始化商圈视图
    [self initWithMallClassifiyView];
    
    // 初始化传统菜系视图
    [self initWithTraditionCuisineView];
    
    // 初始化特色菜系视图
    [self initWithFeatureCuisinedView];
    
    // 初始化国际菜系视图
    [self initWithInterCusinedView];
    
    [self initWithXialaImgView];
    
    if (!_topLine)
    {
        CALayer *line = [CALayer drawLine:self frame:CGRectMake(0, 0, _xialaImgView.left, 0.8) lineColor:[UIColor colorWithHexString:@"#ff5700"]];
        self.topLine = line;
        
        [CALayer drawLine:self frame:CGRectMake(_xialaImgView.right, 0, [[UIScreen mainScreen] screenWidth] - _xialaImgView.right, 0.8) lineColor:[UIColor colorWithHexString:@"#ff5700"]];
    }

    
}

- (void)initWithContentView
{
    if (!_contentView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
}

- (void)initWithBottomView
{
    
    if (!_bottomView)
    {
        CGFloat height = [[UIScreen mainScreen] screenHeight] - _bottomHeight;
        AppDelegate *app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, height - app.rootViewController.appTabBarHeight - STATUSBAR_HEIGHT - app.rootViewController.appNavBarHeight, self.width, 0);

        _bottomView = [[RestaurantClassifiyBottomView alloc] initWithFrame:frame];
        _bottomView.hidden = YES;
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#ff5601"];
        [self addSubview:_bottomView];
    }
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        if (weakSelf.viewCommonBlock)
        {
            weakSelf.viewCommonBlock(weakSelf.conditionEntity);
        }
    };
}

/**
 *  初始化商圈视图
 */
- (void)initWithMallClassifiyView
{// screenz_icon_shangquan
    
    if (!_mallClassifiyView)
    {
        
    }
}

/**
 *  初始化传统菜系视图
 */
- (void)initWithTraditionCuisineView
{// caixi_icon_chuantong
    if (!_traditionCuisineView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kRestaurantClassifiySingleViewHeight);
        _traditionCuisineView = [[RestaurantClassifiySingleView alloc] initWithFrame:frame];
        [_contentView addSubview:_traditionCuisineView];
    }
    _flavorEntity.chuantong.imageName = @"caixi_icon_chuantong";
    [_traditionCuisineView updateViewData:_flavorEntity.chuantong];
    _traditionCuisineView.height = [_traditionCuisineView getClassifiySingleViewHeight];
    __weak typeof(self)weakSelf = self;
    _traditionCuisineView.viewCommonBlock = ^(id data)
    {
        [weakSelf choiceType:data typeId:2];
    };
}

/**
 *  初始化特色菜系视图
 */
- (void)initWithFeatureCuisinedView
{// caixi_icon_tese
    if (!_featureCuisinedView)
    {
        CGRect frame = CGRectMake(0, _traditionCuisineView.bottom, [[UIScreen mainScreen] screenWidth], kRestaurantClassifiySingleViewHeight);
        _featureCuisinedView = [[RestaurantClassifiySingleView alloc] initWithFrame:frame];
        [_contentView addSubview:_featureCuisinedView];
    }
    _flavorEntity.tese.imageName = @"caixi_icon_tese";
    [_featureCuisinedView updateViewData:_flavorEntity.tese];
    _featureCuisinedView.top = _traditionCuisineView.bottom;
    _featureCuisinedView.height = [_featureCuisinedView getClassifiySingleViewHeight];
    __weak typeof(self)weakSelf = self;
    _featureCuisinedView.viewCommonBlock = ^(id data)
    {
        [weakSelf choiceType:data typeId:3];
    };
}

/**
 *  初始化国际菜系视图
 */
- (void)initWithInterCusinedView
{// caixi_icon_guoji
    if (!_interCusinedView)
    {
        CGRect frame = CGRectMake(0, _featureCuisinedView.bottom, [[UIScreen mainScreen] screenWidth], kRestaurantClassifiySingleViewHeight);
        _interCusinedView = [[RestaurantClassifiySingleView alloc] initWithFrame:frame];
        [_contentView addSubview:_interCusinedView];
    }
    _flavorEntity.guoji.imageName = @"caixi_icon_guoji";
    [_interCusinedView updateViewData:_flavorEntity.guoji];
    _interCusinedView.top = _featureCuisinedView.bottom;
    _interCusinedView.height = [_interCusinedView getClassifiySingleViewHeight];
    __weak typeof(self)weakSelf = self;
    _interCusinedView.viewCommonBlock = ^(id data)
    {
        [weakSelf choiceType:data typeId:4];
    };
}

- (void)initWithXialaImgView
{
    if (!_xialaImgView)
    {
        UIImage *image = [UIImage imageNamed:@"icon_xiala"];
        CGFloat screenWidth = [[UIScreen mainScreen] screenWidth];
        CGRect frame = CGRectMake(screenWidth / 2 + (screenWidth/2-image.size.width)/2, 0, image.size.width, image.size.height);
        _xialaImgView = [[UIImageView alloc] initWithFrame:frame];
        _xialaImgView.image = image;
        [self addSubview:_xialaImgView];
    }
}


/**
 *  点击
 *
 *  @param typeEntity 参数
 *  @param typeId     1表示商圈；2表示传统菜系；3表示特色菜系；4表示国际菜系
 */
- (void)choiceType:(CuisineContentDataEntity *)typeEntity typeId:(NSInteger)typeId
{
//    NSInteger menuId = 0;
    if (typeId == 1)
    {// 商圈
//        menuId = typeEntity.id;
//        conditionEntity
        _conditionEntity.mallId = typeEntity.id;
    }
    else if (typeId == 2)
    {// 传统菜系
//        menuId = typeEntity.id;
//        self.ctId = typeEntity.id;
        _conditionEntity.traditionCuisineId = typeEntity.id;
    }
    else if (typeId == 3)
    {// 特色菜系
//        menuId = typeEntity.id;
//        self.tsId = typeEntity.id;
        _conditionEntity.featureCuisinedId = typeEntity.id;
    }
    else if (typeId == 4)
    {// 国际菜系
//        menuId = typeEntity.id;
//        self.gjId = typeEntity.id;
        _conditionEntity.interCusinedId = typeEntity.id;
    }
//    debugLog(@"menuId=%d", (int)menuId);
    
//    if (self.cuisineChoiceBlock)
//    {
//        self.cuisineChoiceBlock(typeEntity, typeId);
//    }
}

- (void)updateWithHiddenFrame
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 0);
    _contentView.frame = frame;
    
    
    CGFloat height = [[UIScreen mainScreen] screenHeight] - _bottomHeight;
    frame = CGRectMake(0, height - app.rootViewController.appTabBarHeight - STATUSBAR_HEIGHT - app.rootViewController.appNavBarHeight, self.width, 0);
    _bottomView.frame = frame;
}
- (void)updateWithShowFrame
{
    AppDelegate *app = [UtilityObject appDelegate];
    CGFloat height = [[UIScreen mainScreen] screenHeight] - _bottomHeight;
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], height - app.rootViewController.appTabBarHeight - STATUSBAR_HEIGHT - app.rootViewController.appNavBarHeight);
    _contentView.frame = frame;

    
    
    height = [[UIScreen mainScreen] screenHeight] - _bottomHeight;
    frame = CGRectMake(0, height - app.rootViewController.appTabBarHeight - STATUSBAR_HEIGHT - app.rootViewController.appNavBarHeight, self.width, app.rootViewController.appTabBarHeight);
    _bottomView.frame = frame;
}

- (void)updateHidden:(BOOL)hidden
{
//    _contentView.hidden = hidden;
    _bottomView.hidden = hidden;
}

- (void)updateViewData:(id)entity
{
//    self.cuisineList = entity;
    self.flavorEntity = entity;
//    for (CuisineTypeDataEntity *ent in _cuisineList)
//    {
//        debugLog(@"ent=%@", [ent modelToJSONString]);
//    }
    
    // 初始化商圈视图
//    [self initWithMallClassifiyView];
    
    // 初始化传统菜系视图
    [self initWithTraditionCuisineView];
    
    // 初始化特色菜系视图
    [self initWithFeatureCuisinedView];
    
    // 初始化国际菜系视图
    [self initWithInterCusinedView];

}

@end























