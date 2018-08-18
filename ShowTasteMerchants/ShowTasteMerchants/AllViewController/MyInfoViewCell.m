//
//  MyInfoViewCell.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/25.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "MyInfoViewCell.h"
#import "LocalCommon.h"
#import "CellCommonDataEntity.h"

@implementation MyInfoViewCell

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
    
    [self initWithLine];
}

- (void)initWithLine
{
    CALayer *line = [CALayer layer];
    line.size = CGSizeMake([[UIScreen mainScreen] screenWidth] / 3 * 2, 0.8);
    line.left = 0;
    line.bottom = kMyInfoViewCellHeight;
    line.backgroundColor = [UIColor colorWithHexString:@"#dbdbdb"].CGColor;
    [self.layer addSublayer:line];
}

- (void)updateCellData:(id)cellEntity
{
    CellCommonDataEntity *commonEnt = cellEntity;
    self.textLabel.font = FONTSIZE_15;
    self.textLabel.text = commonEnt.title;
    self.textLabel.textColor = [UIColor colorWithHexString:@"#323232"];
    if (commonEnt.thumalImgName)
    {
        self.imageView.image = [UIImage imageNamed:commonEnt.thumalImgName];
    }
    if (commonEnt.subTitle && commonEnt.subTitle.length > 0)
    {
        self.detailTextLabel.font = FONTSIZE_15;
        self.detailTextLabel.text = commonEnt.subTitle;
        self.detailTextLabel.textColor =[UIColor colorWithHexString:@"#9a9a9a"];
    }
}


@end
