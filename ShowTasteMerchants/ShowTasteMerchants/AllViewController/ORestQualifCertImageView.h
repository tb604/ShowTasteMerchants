//
//  ORestQualifCertImageView.h
//  ChefDating
//
//  Created by 唐斌 on 16/6/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORestQualifCertImageView : UIImageView

@property (nonatomic, copy) void (^touchImgViewBlock)(id data);

- (void)hiddenWithTitle:(BOOL)hidden;



@end
