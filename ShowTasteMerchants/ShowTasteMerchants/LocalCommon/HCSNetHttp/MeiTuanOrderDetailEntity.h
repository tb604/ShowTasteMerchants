//
//  MeiTuanOrderDetailEntity.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/28.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeiTuanOrderDetailEntity : NSObject

/// 订单创建时间(秒数:1476703162)
//@property (nonatomic, assign) NSInteger cTime;

/// 订单备注（例如：鱼香肉丝不要太甜）
//@property (nonatomic, copy) NSString *caution;

/// 用户预计送达时间，立即送达为0（单位:秒）
//@property (nonatomic, assign) NSInteger deliveryTime;

/// 城市id
//@property (nonatomic, assign) NSInteger cityId;

/// 订单菜品详情(指的时订单中都有哪些菜品)
@property (nonatomic, strong) NSArray *detail;

/// erp方门店id（指的时三方系统中得门店id）
//@property (nonatomic, copy) NSString *ePoiId;

/// 订单扩展信息(指的是订单锁参加的优惠等信息)
@property (nonatomic, strong) NSArray *extras;

/// 是否需要发票 1：需要发票；0不需要发票
//@property (nonatomic, assign) int hasInvoiced;

/// 发票抬头(如果用户选择需要发票，此字段是用户填写的发票抬头)
//@property (nonatomic, copy) NSString *invoiceTitle;

/// 是否是预定单。1预订单；0非预订单
//@property (nonatomic, assign) int isPre;

/// 是否第三方配送。0否；1是。
//@property (nonatomic, assign) int isThirdShipping;

/// 实际送餐地址维度(美团使用的是高德坐标)
//@property (nonatomic, assign) double latitude;

/// 实际送餐地址经度(美团使用的是高德坐标)
//@property (nonatomic, assign) double longitude;

/// 商家对账信息
@property (nonatomic, strong) id poi_receive_detail;

/// 配送完成时间(单位秒)
//@property (nonatomic, assign) NSInteger logisticsCancelTime;

/// 配送类型码
//@property (nonatomic, copy) NSString *logisticsCode;

/// 配送单确认时间，骑手接单时间(单位秒)
//@property (nonatomic, assign) NSInteger logisticsConfirmTime;

/// 骑手电话
//@property (nonatomic, copy) NSString *logisticsDispatcherMobile;

/// 骑手电话（以这个为准）
//@property (nonatomic, copy) NSString *shipperPhone;

/// 骑手姓名
//@property (nonatomic, copy) NSString *logisticsDispatcherName;

/// 骑手取单时间(单位：秒)
//@property (nonatomic, assign) NSInteger logisticsFetchTime;

/// 配送方id
//@property (nonatomic, assign) int logisticsId;

/// 配送方名称
//@property (nonatomic, copy) NSString *logisticsName;

/// 配送单下单时间(单位：秒)
//@property (nonatomic, assign) NSInteger logisticsSendTime;

/// 配送订单状态
//@property (nonatomic, assign) int logisticsStatus;

/// 订单完成时间(单位：秒)
//@property (nonatomic, assign) NSInteger orderCompletedTime;

/// 商户确认时间(单位：秒)
//@property (nonatomic, assign) NSInteger orderConfirmTime;

/// 订单取消时间(单位：秒)
//@property (nonatomic, assign) NSInteger orderCancelTime;

/// 订单id
//@property (nonatomic, assign) NSInteger orderId;

/// 订单展示id(指的是C端用户在外卖App上看道德订单号)
//@property (nonatomic, assign) NSInteger orderIdView;

/// 用户下单时间(单位：秒)
//@property (nonatomic, assign) NSInteger orderSendTime;

/// 订单原价
//@property (nonatomic, assign) float originalPrice;

/// 订单支付类型(1：货到付款；2：在线支付)
//@property (nonatomic, assign) int payType;

/// 门店地址
//@property (nonatomic, copy) NSString *poiAddress;

/// 门店id(指的是外卖中得门店Id)
//@property (nonatomic, assign) NSInteger poiId;

/// 门店名称
//@property (nonatomic, copy) NSString *poiName;

/// 门店服务电话
//@property (nonatomic, copy) NSString *poiPhone;

/// 收货人的地址(实际的地址 @#后是经纬度反查地址)
//@property (nonatomic, copy) NSString *recipientAddress;

/// 收货人名称
//@property (nonatomic, copy) NSString *recipientName;

/// 收货人电话
//@property (nonatomic, copy) NSString *recipientPhone;



/// 配送费用
//@property (nonatomic, assign) float shippingFee;

/// 订单状态
//@property (nonatomic, assign) int status;

/// 总价(用户实际支付金额)
//@property (nonatomic, assign) float total;

/// 订单更新时间（单位：秒）
@property (nonatomic, assign) NSInteger uTime;

/// 门店当前的订单流水号
//@property (nonatomic, assign) NSInteger daySeq;

/// 就餐人数(商家可以根据就餐人数提供餐具)
//@property (nonatomic, assign) int dinnersNumber;

@end

/*
 {
 "detail": "[{\"app_food_code\":\"7317\",\"box_num\":2,\"box_price\":1,\"food_discount\":1,\"food_name\":\"猪肉茴香（锅贴）\",\"price\":12,\"quantity\":2,\"sku_id\":\"6857\",\"unit\":\"份\"},{\"app_food_code\":\"7266\",\"box_num\":1,\"box_price\":1,\"food_discount\":1,\"food_name\":\"老北京豆酱\",\"price\":16,\"quantity\":1,\"sku_id\":\"6806\",\"unit\":\"份\"}]",
 "extras": "[{\"mt_charge\":0,\"poi_charge\":5,\"reduce_fee\":0,\"remark\":\"满38.0元赠随机饮料*1\",\"type\":5},{\"mt_charge\":0,\"poi_charge\":3,\"reduce_fee\":3,\"remark\":\"满30.0元减3.0元\",\"type\":2},{\"mt_charge\":0,\"poi_charge\":3,\"reduce_fee\":3,\"remark\":\"用户使用了商家代金券减3元\",\"type\":101},{\"mt_charge\":0,\"poi_charge\":0,\"reduce_fee\":0,\"remark\":\"送5元商家代金券\",\"type\":100},{}]",
 "poi_receive_detail":"{\"actOrderChargeByMt\":[{\"comment\":\"满38.0元赠随机饮料*1[商家承担:5.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":0,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true},{\"comment\":\"满30.0元减3.0元[商家承担:3.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":0,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true},{\"comment\":\"用户使用了商家代金券减3元[商家承担:3.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":0,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true}],\"actOrderChargeByMtIterator\":{},\"actOrderChargeByMtSize\":3,\"actOrderChargeByPoi\":[{\"comment\":\"满38.0元赠随机饮料*1[商家承担:5.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":500,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true},{\"comment\":\"满30.0元减3.0元[商家承担:3.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":300,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true},{\"comment\":\"用户使用了商家代金券减3元[商家承担:3.0元]\",\"feeTypeDesc\":\"活动款\",\"feeTypeId\":10019,\"moneyCent\":300,\"setComment\":true,\"setFeeTypeDesc\":true,\"setFeeTypeId\":true,\"setMoneyCent\":true}],\"actOrderChargeByPoiIterator\":{},\"actOrderChargeByPoiSize\":3,\"foodShareFeeChargeByPoi\":555,\"logisticsFee\":500,\"onlinePayment\":4200,\"setActOrderChargeByMt\":true,\"setActOrderChargeByPoi\":true,\"setFoodShareFeeChargeByPoi\":true,\"setLogisticsFee\":true,\"setOnlinePayment\":true,\"setWmPoiReceiveCent\":true,\"wmPoiReceiveCent\":3145}",
 
 "uTime": 1476706282,
 "daySeq": 1,
 "dinnersNumber": 1476706282,
 }
*/






















