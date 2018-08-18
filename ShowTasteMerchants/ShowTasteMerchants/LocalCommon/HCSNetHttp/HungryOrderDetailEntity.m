//
//  HungryOrderDetailEntity.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "HungryOrderDetailEntity.h"
#import "TYZKit.h"

@implementation HungryOrderDetailEntity

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"desc" : @"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"phone_list" : [NSString class]};
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
//    uint64_t timestamp = [dic unsignedLongLongValueForKey:@"t" default:0];
//    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    if ([[dic allKeys] containsObject:@"cTime"])
    {// 订单创建时间(秒数:1476703162)
        self.created_at = [NSDate timeStampWithString:[dic[@"cTime"] integerValue] format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if ([[dic allKeys] containsObject:@"orderSendTime"])
    {// 用户下单时间
        
    }
    
    if ([[dic allKeys] containsObject:@"caution"])
    {// 订单备注（例如：鱼香肉丝不要太甜）
        self.desc = objectNull(dic[@"caution"]);
    }
    
    if ([[dic allKeys] containsObject:@"deliveryTime"])
    {// 用户预计送达时间，立即送达为0（单位:秒）
        self.deliver_time = [NSDate timeStampWithString:[dic[@"deliveryTime"] integerValue] format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    if ([[dic allKeys] containsObject:@"ePoiId"])
    {// erp方门店id（指的时三方系统中得门店id）
        self.restaurant_id = [dic[@"ePoiId"] integerValue];
    }
    
    if ([[dic allKeys] containsObject:@"hasInvoiced"])
    {// 是否需要发票 1：需要发票；0不需要发票
        self.invoiced = [dic[@"hasInvoiced"] intValue];
    }
    
    if ([[dic allKeys] containsObject:@"invoiceTitle"])
    {// 发票抬头
        self.invoice = objectNull(dic[@"invoiceTitle"]);
    }
    
    if ([[dic allKeys] containsObject:@"isPre"])
    {// 是否是预定单。1预订单；0非预订单
        self.is_book = [dic[@"isPre"] boolValue];
    }
    
    if ([[dic allKeys] containsObject:@"longitude"])
    {// 实际送餐地址经度(美团使用的是高德坐标)
        // delivery_geo
        NSArray *array = [objectNull(_delivery_geo) componentsSeparatedByString:@","];
        double longitude = [dic[@"longitude"] doubleValue];
        if ([array count] == 0 || [array count] == 1)
        {
            self.delivery_geo = [NSString stringWithFormat:@"%f,0", longitude];
        }
        else
        {
            
            self.delivery_geo = [NSString stringWithFormat:@"%f,%@", longitude, array[1]];
        }
    }
    
    if ([[dic allKeys] containsObject:@"latitude"])
    {// 实际送餐地址维度(美团使用的是高德坐标)
        NSArray *array = [objectNull(_delivery_geo) componentsSeparatedByString:@","];
        double latitude = [dic[@"latitude"] doubleValue];
        if ([array count] == 0 || [array count] == 1)
        {
            self.delivery_geo = [NSString stringWithFormat:@"0,%f", latitude];
        }
        else
        {
            
            self.delivery_geo = [NSString stringWithFormat:@"%@,%f", array[0], latitude];
        }
    }
    
    if ([[dic allKeys] containsObject:@"logisticsStatus"])
    {// 订单配送状态
        self.deliver_status = [dic[@"logisticsStatus"] intValue];
    }
    
    if ([[dic allKeys] containsObject:@"orderId"])
    {// 订单id
        self.order_id = [dic[@"orderId"] integerValue];
    }
    
    if ([[dic allKeys] containsObject:@"originalPrice"])
    {// 订单原价
        self.original_price = [dic[@"originalPrice"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"payType"])
    {// 订单支付类型(1：货到付款；2：在线支付)
        int payType = [dic[@"payType"] intValue];
        self.is_online_paid = (payType==2?YES:NO);
    }
    
    if ([[dic allKeys] containsObject:@"poiId"])
    {// 餐厅id
        self.restaurant_id = [dic[@"poiId"] integerValue];
    }
    
    if ([[dic allKeys] containsObject:@"poiName"])
    {// 餐厅名称
        self.restaurant_name = objectNull(dic[@"poiName"]);
    }
    
    if ([[dic allKeys] containsObject:@"recipientAddress"])
    {// 收货人地址
        self.address = objectNull(dic[@"recipientAddress"]);
    }
    
    if ([[dic allKeys] containsObject:@"recipientName"])
    {// 收货人姓名
        self.consignee = objectNull(dic[@"recipientName"]);
    }
    
    if ([[dic allKeys] containsObject:@"recipientPhone"])
    {// 收货人电话
        NSString *phone = objectNull(dic[@"recipientPhone"]);
        self.phone_list = [NSArray arrayWithObject:phone];
    }
    
    if ([[dic allKeys] containsObject:@"shippingFee"])
    {// 配送费用
        self.deliver_fee = [dic[@"shippingFee"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"status"])
    {// 订单状态
        self.status_code = [dic[@"status"] integerValue];
    }
    
    if ([[dic allKeys] containsObject:@"total"])
    {// 总价(用户实际支付金额)
        self.total_price = [dic[@"total"] floatValue];
    }
    
    if ([[dic allKeys] containsObject:@"daySeq"])
    {// 当天的订单流水号
        self.restaurant_number = [dic[@"daySeq"] integerValue];
    }
    
    // HungryOrderDetailCategoryEntity
    
    
    return YES;
}
- (void)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
{
//    dic[@"t"] = @([self.time timeIntervalSince1970] * 1000).description;
    
    
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    return [self modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone
{
    return [self modelCopy];
}
- (NSUInteger)hash
{
    return [self modelHash];
}
- (BOOL)isEqual:(id)object
{
    return [self modelIsEqual:object];
}

@end
