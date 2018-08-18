//
//  ChoiceLocationCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ChoiceLocationCell.h"
#import "LocalCommon.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>


@implementation ChoiceLocationCell

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
    
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)updateCellData:(id)cellEntity
{
    BMKPoiInfo *poiInfo = cellEntity;
    self.textLabel.text = poiInfo.name;
    self.detailTextLabel.text = poiInfo.address;
}


@end
