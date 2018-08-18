//
//  ShopAccountStatementHeaderView.h
//  ChefDating
//
//  Created by 唐斌 on 16/8/6.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZBaseView.h"

@interface ShopAccountStatementHeaderView : TYZBaseView

/**
 *  1表示预订；2表示即时
 *
 *  @param type <#type description#>
 *
 *  @return <#return value description#>
 */
+ (CGFloat)getWithViewHeight:(NSInteger)type;

@end
