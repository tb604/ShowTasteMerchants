//
//  OMLSingleButtonView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

//#define kOMLSingleButtonViewWidth (kiPhone6Plus?55:45.0) // 50
#define kOMLSingleButtonViewHeight ([OMLSingleButtonView getWithButtonWidth]+5+15)

@interface OMLSingleButtonView : TYZBaseView

+ (NSInteger)getWithButtonWidth;

@end
