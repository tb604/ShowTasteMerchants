//
//  DinersRecipeBottomView.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DinersRecipeBottomView.h"
#import "LocalCommon.h"
#import "ShopingCartView.h"
#import "SYFireworksButton.h"
#import <objc/runtime.h>
#import "SYFireworksView.h"
#import "ShopingCartEntity.h" // 购物车里面的数据实体类

@interface DinersRecipeBottomView ()
{
    UIButton *_btnChoice;
    
    UILabel *_totalPriceLabel;
    
    UILabel *_descLabel;
    
    /**
     *  购物车按钮视图
     */
//    ShopingCartView *_shopingCartView;
    
}
@property (nonatomic, strong) CALayer *verLine;

@property (nonatomic, strong) SYFireworksButton *shoppingCar;

- (void)initWithVerLine;

- (void)initWithBtnChoice;

- (void)initWithTotalPriceLabel;

- (void)initWithDescLabel;

//- (void)initWithShoppingCar;

/**
 *  购物车按钮视图
 */
//- (void)initWithShopingCartView;

@end

@implementation DinersRecipeBottomView

- (void)initWithSubView
{
    [super initWithSubView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self initWithLine];
    
    [self initWithVerLine];
    
    [self initWithBtnChoice];
    
    [self initWithTotalPriceLabel];
    
//    [self initWithDescLabel];
    
    // 购物车按钮视图
//    [self initWithShopingCartView];
    
//    [self initWithShoppingCar];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth], 0.8);
    line.left = 0;
    line.top = 0;
    line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
    [self.layer addSublayer:line];
}

- (void)initWithVerLine
{
    int leftWidth = (int)([[UIScreen mainScreen] screenWidth] / 4.16);
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake(0.8, self.height);
    line.left = leftWidth;
    line.top = 0;
    line.backgroundColor = [UIColor colorWithHexString:@"#9a9a9a"].CGColor;
    [self.layer addSublayer:line];
    self.verLine = line;
}

- (void)initWithBtnChoice
{
    CGRect frame = CGRectMake(self.width - self.width/4, 0, self.width/4, self.height);
    _btnChoice = [TYZCreateCommonObject createWithNotImageButton:self btnTitle:@"完成" titleColor:[UIColor whiteColor] titleFont:FONTSIZE_18 targetSel:@selector(clickedChoice:)];
    _btnChoice.frame = frame;
    _btnChoice.backgroundColor = [UIColor colorWithHexString:@"#ff5500"];
    [self addSubview:_btnChoice];
}

- (void)initWithTotalPriceLabel
{
    CGRect frame = CGRectMake(_verLine.right + 15, (kDinersRecipeBottomViewHeight - 20) / 2, _btnChoice.left - _verLine.right - 15 - 10, 20);
    _totalPriceLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#ff5500"] fontSize:FONTSIZE_18 labelTag:0 alignment:NSTextAlignmentLeft];
//    _totalPriceLabel.text = @"￥320";
}

- (void)initWithDescLabel
{
    CGRect frame = _totalPriceLabel.frame;
    frame.size.height = 16;
    frame.origin.y = _totalPriceLabel.bottom + 2;
    _descLabel = [TYZCreateCommonObject createWithLabel:self labelFrame:frame textColor:[UIColor colorWithHexString:@"#cdcdcd"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
    _descLabel.text = @"预付金为订餐金额的20%";
}

/*
- (void)initWithShoppingCar
{
    if(!_shoppingCar)
    {
        UIImage *image = [UIImage imageNamed:@"order_cart_clickable"];
        CGRect frame = CGRectMake((_verLine.left - image.size.width) / 2, (self.height - image.size.height)/2, image.size.width, image.size.height);
        _shoppingCar = [SYFireworksButton buttonWithType:UIButtonTypeCustom];
        _shoppingCar.backgroundColor = [UIColor clearColor];
        _shoppingCar.frame = frame;
        _shoppingCar.alpha = 1;
        //    cart_count
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.tag = 1002;
        numLabel.frame = CGRectMake((38-12)/2, 3, 12, 12);
        //        numLabel.text = [UserInfo shareUserInfo].userInfoModel.cart_count;
        if (numLabel.text.length ==2)
        {
            //            numLabel.frame.origin.x = (38-24)/2;
            //            numLabel.width = 24;
        }
        [numLabel setFont: [UIFont systemFontOfSize:10]];
        [self.shoppingCar addSubview:numLabel];
//        _shoppingCar.particleImage = [UIImage imageNamed:@"Sparkle"];
        _shoppingCar.particleScale = 0.05;
        _shoppingCar.particleScaleRange = 0.02;
        [_shoppingCar setImage:image forState:UIControlStateNormal];
        //        [_shoppingCar addTarget:self action:@selector(shoppingCarClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shoppingCar];
    }

}
*/

/**
 *  购物车按钮视图
 */
/*- (void)initWithShopingCartView
{
    __weak typeof(self)weakSelf = self;
    CGRect frame = CGRectMake(0, 0, _verLine.left, self.height);
    _shopingCartView = [[ShopingCartView alloc] initWithFrame:frame];
//    _shopingCartView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_shopingCartView];
    _shopingCartView.TouchShopingCartBlock = ^()
    {
        if (weakSelf.TouchShopingCartBlock)
        {
            weakSelf.TouchShopingCartBlock();
        }
    };
}*/

// 选好了
- (void)clickedChoice:(id)sender
{
    if (self.viewCommonBlock)
    {
        self.viewCommonBlock(nil);
    }
}

- (void)updateWithBtnTitle:(NSString *)title
{
    [_btnChoice setTitle:title forState:UIControlStateNormal];
}

- (void)updateViewData:(id)entity
{
    NSArray *array = entity;
    CGFloat totalPrice = 0.0;
    for (ShopingCartEntity *cartEnt in array)
    {
        totalPrice += ((cartEnt.activityPrice==0.0?cartEnt.price:cartEnt.activityPrice) * cartEnt.number);
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.0f", totalPrice];
}

@end
















