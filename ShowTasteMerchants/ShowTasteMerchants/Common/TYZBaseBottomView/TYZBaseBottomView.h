//
//  TYZBaseBottomView.h
//  51tourGuide
//
//  Created by 唐斌 on 16/4/19.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface TYZBaseBottomView : TYZBaseView
@property (nonatomic, copy) void (^bottomClickedBlock)(NSString *title, NSInteger tag);

- (void)updateBottomCancel:(NSString *)cancelTitle submitTitle:(NSString *)submitTitle;


- (void)topLineWithHidden:(BOOL)hidden;

@end
