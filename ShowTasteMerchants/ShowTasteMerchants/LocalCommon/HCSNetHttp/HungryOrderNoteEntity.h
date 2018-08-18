//
//  HungryOrderNoteEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/24.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HungryOrderDetailEntity.h"

@interface HungryOrderNoteEntity : NSObject

@property (nonatomic, strong) HungryOrderDetailEntity *orderEntitiy;

/// 自己定义的订单状态
@property (nonatomic, assign) NSInteger commend;

@end
