/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanViewStyle.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 11:20
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanViewStyle.h"

@implementation TYZScanViewStyle

- (id)init
{
    if (self = [super init])
    {
        self.isNeedShowRetangle = YES;
        
        self.whRatio = 1.0;
        
        self.colorRetangleLine = [UIColor whiteColor];
        
        self.centerUpOffset = 44;
        self.xScanRetangleOffset = 60;
        //        if ([UIScreen mainScreen].bounds.size.height <= 480 )
        //        {
        //            //3.5inch 显示的扫码缩小
        //            self.xScanRetangleOffset = self.xScanRetangleOffset - 10;
        //        }
        
        self.anmiationStyle = TYZScanViewAnimationStyle_LineMove;
        self.photoframeAngleStyle = TYZScanViewPhotoframeAngleStyle_Outer;
        self.colorAngle = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        
        self.red_notRecoginitonArea = 0.0;
        self.green_notRecoginitonArea = 0.0;
        self.blue_notRecoginitonArea = 0.0;
        self.alpa_notRecoginitonArea = 0.5;
        
        self.photoframeAngleW = 24;
        self.photoframeAngleH = 24;
        self.photoframeLineW = 7;
    }
    return self;
}

@end




















