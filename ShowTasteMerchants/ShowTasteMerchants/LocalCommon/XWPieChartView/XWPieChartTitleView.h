//
//  XWPieChartTitleView.h
//  ChefDating
//
//  Created by 唐斌 on 16/9/7.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface XWPieChartTitleView : TYZBaseView

+ (CGFloat)getWithWidth;

- (void)updateWithName:(NSString *)name color:(UIColor *)color;

@end
