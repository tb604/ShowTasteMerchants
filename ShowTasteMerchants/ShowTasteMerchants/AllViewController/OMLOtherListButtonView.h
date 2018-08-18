//
//  OMLOtherListButtonView.h
//  ChefDating
//
//  Created by 唐斌 on 16/5/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"
#import "OMLSingleButtonView.h"

//#define kOMLOtherSpace (kiPhone6Plus?20:15)

#define kOMLOtherListButtonViewHeight ([OMLOtherListButtonView getWithOtherSpace]+kOMLSingleButtonViewHeight+[OMLOtherListButtonView getWithOtherSpace])

/**
 *  其它功能视图(餐厅订餐、外卖订餐、家庭订餐、私厨预订、邻里厨房)
 */
@interface OMLOtherListButtonView : TYZBaseView

+ (NSInteger)getWithOtherSpace;

@end
