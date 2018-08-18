//
//  ORestQualifCertViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ORestQualifCertViewCell.h"
#import "LocalCommon.h"
#import "ORestQualifCertView.h"
#import "RestaurantBaseDataEntity.h"
#import "RestaurantDetailDataEntity.h"

/*
 EN_OPRT_INFO_QUACERT_BUSLIC_ROW = 0, ///< 营业执照
 //    EN_OPRT_INFO_QUACERT_HYGLIC_ROW, ///< 卫生许可证
 //    EN_OPRT_INFO_QUACERT_LPIDCARD_ROW, ///< 法人身份证
 */

@interface ORestQualifCertViewCell ()
{
    /**
     * 营业执照
     */
    ORestQualifCertView *_buslicView;
    
    /**
     *  餐厅经营许可证
     */
    ORestQualifCertView *_hyglicView;
    
    /**
     *  消防检查合格意见书
     */
//    ORestQualifCertView *_fireQualifiedView;
    
    /**
     *  健康证(1)
     */
    ORestQualifCertView *_healthCertOneView;
    
    /**
     *  健康证(2)
     */
    ORestQualifCertView *_healthCertTwoView;
}


/**
 *  营业执照
 */
- (void)initWithBuslicView;

/**
 *  餐厅经营许可证
 */
- (void)initWithHyglicView;

/**
 *  消防检查合格意见书
 */
//- (void)initWithFireQualifiedView;

/**
 * 健康证(1)
 */
- (void)initWithHealthCertOneView;

/**
 * 健康证(2)
 */
- (void)initWithHealthCertTwoView;


@end

@implementation ORestQualifCertViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initWithSubViewCell
{
    [super initWithSubViewCell];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor whiteColor];
    
    // 营业执照
    [self initWithBuslicView];
    
    // 餐厅经营许可证
    [self initWithHyglicView];
    
    // 消防检查合格意见书
//    [self initWithFireQualifiedView];
    
    // 健康证(1)
    [self initWithHealthCertOneView];
    
    // 健康证(2)
    [self initWithHealthCertTwoView];

}

/**
 *  营业执照
 */
- (void)initWithBuslicView
{
    if (!_buslicView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertViewCellHeight]);
        _buslicView = [[ORestQualifCertView alloc] initWithFrame:frame];
        _buslicView.tag = 100;
        [self.contentView addSubview:_buslicView];
    }
    __weak typeof(self)weakSelf = self;
    _buslicView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchImageView:data];
    };
}

/**
 *  餐厅经营许可证
 */
- (void)initWithHyglicView
{
    if (!_hyglicView)
    {
        CGRect frame = CGRectMake(0, _buslicView.bottom, [[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertViewCellHeight]);
        _hyglicView = [[ORestQualifCertView alloc] initWithFrame:frame];
        _hyglicView.tag = 101;
        [self.contentView addSubview:_hyglicView];
    }
    __weak typeof(self)weakSelf = self;
    _hyglicView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchImageView:data];
    };
}

/**
 *  消防检查合格意见书
 */
/*- (void)initWithFireQualifiedView
{
    if (!_fireQualifiedView)
    {
        CGRect frame = CGRectMake(0, _hyglicView.bottom, [[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertViewCellHeight]);
        _fireQualifiedView = [[ORestQualifCertView alloc] initWithFrame:frame];
        _fireQualifiedView.tag = 102;
        [self.contentView addSubview:_fireQualifiedView];
    }
    __weak typeof(self)weakSelf = self;
    _fireQualifiedView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchImageView:data];
    };
}*/

/**
 * 健康证(1)
 */
- (void)initWithHealthCertOneView
{
    if (!_healthCertOneView)
    {
        CGRect frame = CGRectMake(0, _hyglicView.bottom, [[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertViewCellHeight]);
        _healthCertOneView = [[ORestQualifCertView alloc] initWithFrame:frame];
        _healthCertOneView.tag = 103;
        [self.contentView addSubview:_healthCertOneView];
    }
    __weak typeof(self)weakSelf = self;
    _healthCertOneView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchImageView:data];
    };
}

/**
 * 健康证(2)
 */
- (void)initWithHealthCertTwoView
{
    if (!_healthCertTwoView)
    {
        CGRect frame = CGRectMake(0, _healthCertOneView.bottom, [[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertViewCellHeight]);
        _healthCertTwoView = [[ORestQualifCertView alloc] initWithFrame:frame];
        _healthCertTwoView.tag = 104;
        [self.contentView addSubview:_healthCertTwoView];
    }
    __weak typeof(self)weakSelf = self;
    _healthCertTwoView.viewCommonBlock = ^(id data)
    {
        [weakSelf touchImageView:data];
    };
}

- (void)touchImageView:(id)data
{
    if (self.baseTableViewCellBlock)
    {
        self.baseTableViewCellBlock(data);
    }
}

+ (CGFloat)getQualifCertViewCellHeight
{
    return [ORestQualifCertView getQualifCertViewCellHeight] * 4;
}

- (void)hiddenWithTitle:(BOOL)hidden
{
    [_buslicView hiddenWithTitle:hidden];
    
    [_hyglicView hiddenWithTitle:hidden];
    
//    [_fireQualifiedView hiddenWithTitle:hidden];
    
    [_healthCertOneView hiddenWithTitle:hidden];
    
    [_healthCertTwoView hiddenWithTitle:hidden];
    
}

- (void)updateCellData:(id)cellEntity
{
    RestaurantDetailDataEntity *detailEnt = cellEntity;
    [_buslicView updateWithTitle:@"营业执照" imageEntity:detailEnt.busLicImageEntity];
    
    [_hyglicView updateWithTitle:@"经营许可证或卫生许可证" imageEntity:detailEnt.busCertImageEntity];
    
//    [_fireQualifiedView updateWithTitle:@"消防检查合格意见书"imageEntity:detailEnt.fireSafeImageEntity];
    
    [_healthCertOneView updateWithTitle:@"健康证（1）" imageEntity:detailEnt.HealthCertOneImageEntity];
    
    [_healthCertTwoView updateWithTitle:@"健康证（2）" imageEntity:detailEnt.HealthCertTwoImageEntity];
}

@end



























