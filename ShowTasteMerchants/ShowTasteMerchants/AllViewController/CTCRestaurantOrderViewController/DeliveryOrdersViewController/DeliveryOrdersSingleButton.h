//
//  DeliveryOrdersSingleButton.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface DeliveryOrdersSingleButton : TYZBaseView
{
    BOOL _selectButton;
}
@property (nonatomic, assign) BOOL selectButton;

@property (nonatomic, copy) void (^selectButtonBlock)(DeliveryOrdersSingleButton *button);

- (void)updateViewData:(id)entity buttonWidth:(float)buttonWidth;

@end
