//
//  MyInfoCommonViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoCommonViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@interface MyInfoCommonViewCell ()

@end

@implementation MyInfoCommonViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *dataEntity = cellEntity;
    self.textLabel.font = FONTSIZE_15;
    self.textLabel.text = dataEntity.title;
    self.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    if (dataEntity.thumalImgName)
    {
        self.imageView.image = [UIImage imageNamed:dataEntity.thumalImgName];
    }
    if (dataEntity.subTitle && dataEntity.subTitle.length > 0)
    {
        self.detailTextLabel.font = FONTSIZE_15;
        self.detailTextLabel.text = dataEntity.subTitle;
        self.detailTextLabel.textColor =[UIColor colorWithHexString:@"#9a9a9a"];
    }
}

@end
