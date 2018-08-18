//
//  ORestQualifCertView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface ORestQualifCertView : TYZBaseView


+ (NSInteger)getQualifCertImgViewHeight;

+ (CGFloat)getQualifCertViewCellHeight;

- (void)updateWithTitle:(NSString *)title imageEntity:(id)imageEntity;

- (void)hiddenWithTitle:(BOOL)hidden;

@end
