//
//  TYZImageEditorBottomView.h
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYZImageEditorBottomView : UIView

@property (nonatomic, copy) void (^touchCancelSubmitBlock)(int tag);

@end
