//
//  DeliveryOrdersListViewController.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/17.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "DeliveryOrdersListViewController.h"
#import "LocalCommon.h"
#import "DeliveryOrderUserBaseInfoCell.h" // 用户基本信息cell
#import "DeliveryOrderFoodInfoViewCell.h" // 物品cell
#import "DeliveryOrderOperatorViewCell.h" // 功能操作cell
#import "DeliveryOrderDistributionViewCell.h"
#import "HungryOrderDetailEntity.h" // 订单详情
#import "HungryNetHttp.h"
#import "DeliveryOrderInfoViewCell.h"
#import "DeliveryOrderDetailViewCell.h"
#import "DeliveryIncreaseTipBackgroundView.h" // 增加小费视图
#import "TYZDBManager.h"
#import "TYZReceiptManager.h" // 打印单据
#import "TYZQRCode.h" // 二维码
#import "CTCEmptyOrderView.h"
#import "HungryBaseInfoObject.h"
#import "HungryOrderNoteEntity.h"
#import "DaDaDistAddOrderTipsEntity.h" // 达达添加小费


@interface DeliveryOrdersListViewController ()
{
    
    DeliveryIncreaseTipBackgroundView *_tipView;
    
    CTCEmptyOrderView *_emptyView;
}

@property (nonatomic, strong) HungryBaseInfoObject *hungryObject;

/// 打印
@property (nonatomic, strong) TYZReceiptManager *receiptManager;

@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *   接收到新的订单
 */
- (void)revcOrderInfo:(NSNotification *)note;

@end

@implementation DeliveryOrdersListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHUNGRY_NEW_ORDER_NOTE object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark override

/*
 EN_TM_ORDER_WAIT_ORDER = 0,     ///< 待接单
 EN_TM_ORDER_RECEIVE_ORDER,      ///< 已接单
 EN_TM_ORDER_SHIP_NOT_ORDER,     ///< 配送未接单
 EN_TM_ORDER_PICKUP_ORDER,       ///< 取货中
 EN_TM_ORDER_DIST_RESULT_ORDER,  ///< 配送结果
 EN_TM_ORDER_EXCEPTION_ORDER,    ///< 异常订单
 */


- (void)initWithVar
{
    [super initWithVar];
    
    //  接收到新的订单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(revcOrderInfo:) name:kHUNGRY_NEW_ORDER_NOTE object:nil];
    
    
    [[TYZDBManager shareInstance] updateEmpOrder:STATUS_CODE_PROCESSED_AND_VALID deliverCode:0 csCode:ELEME_ORDER_PROCESSED_AND_VALID orderId:101638123997961838];
    
    self.hungryObject = [HungryBaseInfoObject shareInstance];
    
    if (_orderType == EN_TM_ORDER_EXCEPTION_ORDER)
    {
//        [self performSelector:@selector(printWithFood:) withObject:nil afterDelay:3];
        
//        NSString *str = @",";
//        NSArray *array = [str componentsSeparatedByString:@","];
//        debugLog(@"count=%d", (int)array.count);
        
//        mtorderdetail.json
        // 美团
        /*NSString *cityPath = [NSFileManager getfilebulderPath:@"mtorderdetail.json"];
        NSString *jsonStr = [NSString stringWithContentsOfFile:cityPath encoding:NSUTF8StringEncoding error:nil];
//        debugLog(@"jsonStr=%@", jsonStr);
        NSDictionary *dict = [NSDictionary modelDictionaryWithJson:jsonStr];
        HungryOrderDetailEntity *orderDetilEnt = [HungryOrderDetailEntity modelWithJSON:dict];
        
        HungryOrderDetailCategoryEntity *ent = [HungryOrderDetailCategoryEntity new];
        orderDetilEnt.detail = ent;
        NSMutableArray *group = [NSMutableArray new];
        NSArray *details = nil;
        if ([dict[@"detail"] isKindOfClass:[NSArray class]])
        {
            details = dict[@"detail"];
        }
        else if ([dict[@"detail"] isKindOfClass:[NSString class]])
        {
            details = [NSArray modelArrayWithJson:dict[@"detail"]];
        }
        for (id foodDict in details)
        {
            HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:foodDict];
            [group addObject:foodEnt];
        }
        orderDetilEnt.detail.group = [NSArray arrayWithObject:group];
        
        NSArray *extrs = nil;
        if ([dict[@"extras"] isKindOfClass:[NSArray class]])
        {
            extrs = dict[@"extras"];
        }
        else if ([dict[@"extras"] isKindOfClass:[NSString class]])
        {
            extrs = [NSArray modelArrayWithJson:dict[@"extras"]];
        }
        NSMutableArray *extras = [NSMutableArray new];
        for (id extDict in extrs)
        {
            HungryOrderDetailCategoryExtraEntity *extraEnt = [HungryOrderDetailCategoryExtraEntity modelWithJSON:extDict];
            extraEnt.quantity = 1;
            [extras addObject:extraEnt];
        }
        orderDetilEnt.detail.extra = extras;
        
        
        debugLog(@"consignee=%@", orderDetilEnt.consignee);
        debugLog(@"phone_list=%@", orderDetilEnt.phone_list);
        debugLog(@"detail=%@", [orderDetilEnt.detail modelToJSONString]);
         */
    }
    
    // 初始化打印
//    _wifiObject = [TYZWIFIPrintObject new];
    
//    NSArray *array = [[TYZDBManager shareInstance] getWithOrderAllDetails];
//    [self.baseList addObjectsFromArray:array];
    
//    [[TYZDBManager shareInstance] deleteWithOrderDetail];
    
    /*NSString *cityPath = [NSFileManager getfilebulderPath:@"emeOrderDetail.json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:cityPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [NSArray modelArrayWithJson:jsonStr];
//    debugLog(@"array=%@", NSStringFromClass([array class]));
    int i=0;
    for (NSDictionary *dict in array)
    {
        HungryOrderDetailEntity *orderDetilEnt = [HungryOrderDetailEntity modelWithJSON:dict];
        
        if (i == 0 && _orderType == EN_TM_ORDER_EXCEPTION_ORDER)
        {
            orderDetilEnt.invalid_type = TYPE_SYSTEM_AUTO_CANCEL;
        }
        else if (i == 1 && _orderType == EN_TM_ORDER_EXCEPTION_ORDER)
        {
            orderDetilEnt.refund_code = REFUND_STATUS_LATER_REFUND_REQUEST;
        }
        else if (i == 2 && _orderType == EN_TM_ORDER_EXCEPTION_ORDER)
        {
            orderDetilEnt.refund_code = REFUND_STATUS_LATER_REFUND_SUCCESS;//退单成功
            orderDetilEnt.deliver_status = DELIVER_BE_ASSIGNED_MERCHANT; // 配送状态
        }
        orderDetilEnt.detail.newgroups = [NSMutableArray new];
        orderDetilEnt.detail.newextra = [NSMutableArray new];
        
        HungryOrderDetailCategoryExtraEntity *extEnt = [HungryOrderDetailCategoryExtraEntity new];
        extEnt.name = @"商品总计";
        extEnt.price = orderDetilEnt.original_price;
        [orderDetilEnt.detail.newextra addObject:extEnt];
        if ([orderDetilEnt.detail.extra count] > 0)
        {
            [orderDetilEnt.detail.newextra addObjectsFromArray:orderDetilEnt.detail.extra];
        }
        
        extEnt = [HungryOrderDetailCategoryExtraEntity new];
        extEnt.name = @"包  装 费";
        extEnt.price = orderDetilEnt.package_fee;
        [orderDetilEnt.detail.newextra addObject:extEnt];
        
        extEnt = [HungryOrderDetailCategoryExtraEntity new];
        extEnt.name = @"配  送 费";
        extEnt.price = orderDetilEnt.deliver_fee;
        [orderDetilEnt.detail.newextra addObject:extEnt];
        
        extEnt = [HungryOrderDetailCategoryExtraEntity new];
        extEnt.name = @"配  送 费";
        extEnt.price = orderDetilEnt.deliver_fee;
        [orderDetilEnt.detail.newextra addObject:extEnt];
        
        
        
        float addHeight = [objectNull(orderDetilEnt.address) heightForFont:FONTSIZE_13 width:[[UIScreen mainScreen] screenWidth] - 20];
        orderDetilEnt.addressHeight = addHeight;
        NSMutableArray *groups = [NSMutableArray new];
        for (id list in orderDetilEnt.detail.group)
        {
            NSMutableArray *addList = [NSMutableArray new];
            for (id dict in list)
            {
                HungryOrderFoodEntity *foodEnt = [HungryOrderFoodEntity modelWithJSON:dict];
                [addList addObject:foodEnt];
                [orderDetilEnt.detail.newgroups addObject:foodEnt];
                if (foodEnt.garnish.count > 0)
                {
                    [orderDetilEnt.detail.newgroups addObjectsFromArray:foodEnt.garnish];
                }
            }
            if ([addList count] > 0)
            {
                [groups addObject:addList];
            }
        }
        if ([groups count] > 0)
        {
            orderDetilEnt.detail.group = groups;
        }
        [self.baseList addObject:orderDetilEnt];
        
        i++;
        
//        [[TYZDBManager shareInstance] insertWithOrderDetail:orderDetilEnt userId:[UserLoginStateObject getUserId] shopId:[UserLoginStateObject getCurrentShopId]];
        // insertWithOrderDetail
        
    }
    */
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
//    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = self.baseTableView.frame;
    frame.size.height = frame.size.height - 40;
    self.baseTableView.frame = frame;
    self.baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initWithEmptyView];
    
    
    
    [self doRefreshData];
    
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    // 重新刷新数据
    NSArray *array = [_hungryObject getOrderDetailList:_orderType];
    [self.baseList removeAllObjects];
    [self.baseList addObjectsFromArray:array];
    
    [self.baseTableView reloadData];
    
    [self initWithEmptyView];
    
    [self endAllRefreshing];
    
}

- (void)initWithEmptyView
{
    if (!_emptyView)
    {
        CGRect frame = CGRectMake(0, 0, 230, 230);
        _emptyView = [[CTCEmptyOrderView alloc] initWithFrame:frame];
        _emptyView.userInteractionEnabled = NO;
        _emptyView.center = CGPointMake(self.baseTableView.width / 2., self.baseTableView.height / 2. - 60);
        [self.view addSubview:_emptyView];
    }
    _emptyView.hidden = YES;
    if ([self.baseList count] == 0)
    {
        _emptyView.hidden = NO;
    }
}

/**
 * 把订单加入到列表中
 */
- (void)addWithOrderDetail:(HungryOrderDetailEntity *)entity
{
    BOOL isExists = NO;
    for (HungryOrderDetailEntity *empEnt in self.baseList)
    {
        if (empEnt.order_id == entity.order_id)
        {
            empEnt.status_code = entity.status_code;
            empEnt.refund_code = entity.refund_code;
            empEnt.deliver_status = entity.deliver_status;
            empEnt.invalid_type = entity.invalid_type;
            empEnt.cs_status_code = entity.cs_status_code;
            isExists = YES;
            break;
        }
    }
    if (!isExists)
    {
        [self.baseList insertObject:entity atIndex:0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.baseTableView reloadData];
        [self initWithEmptyView];
    });
    
}

/**
 * 把订单从列表中删除
 */
- (void)removeWithOrderDetail:(HungryOrderDetailEntity *)entity
{
    NSInteger index = -1;
    for (NSInteger i=0; i<self.baseList.count; i++)
    {
        HungryOrderDetailEntity *empEnt = self.baseList[i];
        if (empEnt.order_id == entity.order_id)
        {
            index = i;
            break;
        }
    }
    if (index != -1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseList removeObjectAtIndex:index];
            [self.baseTableView reloadData];
            [self initWithEmptyView];
        });
        
        
    }
    
}

/**
 *  重新刷新数据
 */
- (void)reloadWithData
{
    NSArray *array = [_hungryObject getOrderDetailList:_orderType];
    if ([self.baseList count] == 0)
    {
        [self.baseList addObjectsFromArray:array];
    }
    else
    {
        for (HungryOrderDetailEntity *ent in array)
        {
            BOOL isExists = NO;
            for (HungryOrderDetailEntity *empEnt in self.baseList)
            {
                if (empEnt.order_id == ent.order_id)
                {
                    isExists = YES;
                    break;
                }
            }
            if (!isExists)
            {
                [self.baseList addObject:ent];
            }
        }
    }
    [self.baseTableView reloadData];
    [self initWithEmptyView];
    
    [self endAllRefreshing];
}

/**
 *  增加小费视图
 */
- (void)showWithIncreaseTipView:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    if (!_tipView)
    {
        _tipView =[[DeliveryIncreaseTipBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _tipView.alpha = 0;
    }
    _tipView.touchViewBlock = ^(id data)
    {// 增加小费
        [weakSelf increaseTip:data];
    };
    
    if (show)
    {
        [self.view.window addSubview:_tipView];
        [UIView animateWithDuration:0.5 animations:^{
            _tipView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _tipView.alpha = 0;
        } completion:^(BOOL finished) {
            [_tipView removeFromSuperview];
        }];
    }
}

- (void)increaseTip:(id)data
{
    if (!data)
    {
        [self showWithIncreaseTipView:NO];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"添加小费中"];
    // 增加小费
    float amount = [data floatValue];
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[_indexPath.section];
    DaDaDistAddOrderTipsEntity *inputEnt = [DaDaDistAddOrderTipsEntity new];
    inputEnt.source_id = @"73753";// 临时
    inputEnt.order_id = [NSString stringWithFormat:@"%lld", (long long)orderDetailEnt.order_id];
    inputEnt.tips = amount;
    inputEnt.city_code = @"025";
    inputEnt.info = @"";
    
    [HCSNetHttp requestWithDadaAddTip:inputEnt completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"添加小费成功"];
            [self showWithIncreaseTipView:NO];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
    
    
}

- (int)getSubChar:(NSString *)data
{
    NSString *model = objectNull([UtilityObject  readWithPrinterModel]);
    NSString *str = nil;
    if ([model isEqualToString:@"58"])
    {
        str = @"--------------------------------";
    }
    else if ([model isEqualToString:@"80"])
    {
        str = @"-----------------------";
        //                ------------------------------------------
    }
    
    int len = [str getCharacterLen];
    debugLog(@"len=%d", len);
    
    
    int subLen = len - [data getCharacterLen] - 2;
    if ([data length] > 5)
    {
        subLen = subLen - 3;
    }
    debugLog(@"subLen=%d", subLen);
    return subLen;
}

- (NSString *)getWithPlatform:(NSString *)data detilEntity:(HungryOrderDetailEntity *)detilEntity ch:(NSString *)ch
{
    NSString *model = objectNull([UtilityObject  readWithPrinterModel]);
    
    
    //    --------------------------------
    
    // ------------------------------------------
    // ------------------------------------------
    
    NSString *str = nil;
    if ([model isEqualToString:@"58"])
    {
        str = @"--------------------------------";
    }
    else if ([model isEqualToString:@"80"])
    {
        str = @"---------------------------------------";
//                ------------------------------------------
    }
    
    int len = [str getCharacterLen];
    debugLog(@"len=%d", len);
    
    
    int subLen = len - [data getCharacterLen] - 2;
    if ([data length] > 5)
    {
        subLen = subLen - 3;
    }
    debugLog(@"subLen=%d", subLen);
    
    int halfLen = subLen / 2;
    debugLog(@"halfLen=%d", halfLen);
    
    NSMutableString *strLeft = [NSMutableString new];
    for (int i=0; i<halfLen; i++)
    {
        [strLeft appendString:ch];
    }
    
    NSMutableString *strRight = [NSMutableString new];
    if (subLen % 2 == 0)
    {
        [strRight appendString:strLeft];
    }
    else
    {
        [strRight appendString:strLeft];
        [strRight appendString:ch];
    }
    
    return [NSString stringWithFormat:@"%@ %@ %@", strLeft, data, strRight];
}

/// 打印
- (void)printWithFood:(HungryOrderDetailEntity *)detilEntity
{
    debugMethod();
    
//    [HungryNetHttp requestWithMeiTuanTest];
//    
//    return;
    
    // 192.168.1.202/
    NSString *host = objectNull([UtilityObject readWithPrinterIP]);//@"192.168.1.200";
    
    if ([host isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请设置打印机IP！"];
        return;
    }
    
    NSString *model = objectNull([UtilityObject  readWithPrinterModel]);
    if ([model isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请设置打印机型号！"];
        return;
    }
    
    UInt16 port = 9100;//9100;
    NSTimeInterval timeout = 5;
    TYZReceiptManager *manager = [[TYZReceiptManager alloc] initWithHost:host port:port timeout:timeout];
    self.receiptManager = manager;
//    return;
    //https://open-erp.meituan.com/storemap
    
    // 基础设置
    [manager basicSetting];
    
    // Delivery platform
    NSString *deplatform = @"";
    if (detilEntity.provider == EN_ORDER_SOURCE_ELE)
    {// 饿了么
        deplatform = [NSString stringWithFormat:@"#%d饿了么订单", (int)detilEntity.restaurant_number];
    }
    else if (detilEntity.provider == EN_ORDER_SOURCE_MEITUAN)
    {// 美团
        deplatform = [NSString stringWithFormat:@"#%d美团订单", (int)detilEntity.restaurant_number];
    }
    
    NSString *platformTitle = [self getWithPlatform:deplatform detilEntity:detilEntity ch:@"*"];
//    debugLog(@"platformTitle=%@", platformTitle);
    
    // 外卖商家标题
    [manager writeData_title:platformTitle Scale:scale_1 Type:MiddleAlignment];
//    return;
    
    // 外卖餐厅名
    [manager writeData_title:detilEntity.restaurant_name Scale:scale_1 Type:MiddleAlignment];
    
    // 支付类型
    NSString *payType = @"- 已在线支付 -";
    if (!detilEntity.is_online_paid)
    {
        payType = @"- 货到付款 -";
    }
    [manager writeData_title:payType Scale:scale_2 Type:MiddleAlignment];
    
    
    // 打印分割线
    [manager writeData_line:scale_1];
    
    // 下单时间
    NSString *placeOrderTime = [NSString stringWithFormat:@"下单时间：%@", objectNull(detilEntity.created_at)];
    [manager writeData_title:placeOrderTime Scale:scale_1 Type:MiddleAlignment];
    
    // 备注
    if (![objectNull(detilEntity.desc) isEqualToString:@""])
    {
        NSString *desc = [NSString stringWithFormat:@"备注：%@", detilEntity.desc];
        [manager writeData_title:desc Scale:scale_2 Type:MiddleAlignment];
    }
    
    // 发票
    if (detilEntity.invoiced == 1)
    {// 需要发票
        if (![objectNull(detilEntity.invoice) isEqualToString:@""])
        {
            NSString *invoice = [NSString stringWithFormat:@"发票：%@", detilEntity.invoice];
            [manager writeData_title:invoice Scale:scale_2 Type:MiddleAlignment];
        }
    }
    
    // 篮子
    for (int i=0; i<detilEntity.detail.group.count; i++)
    {
        // 几号篮子
        NSString *groupTitle = [NSString stringWithFormat:@"%d号篮子", i+1];
        NSString *title = [self getWithPlatform:groupTitle detilEntity:detilEntity ch:@"-"];
        [manager writeData_title:title Scale:scale_1 Type:MiddleAlignment];
        NSArray *foodList = detilEntity.detail.group[i];
        NSMutableArray *addList = [NSMutableArray new];
        for (HungryOrderFoodEntity *foodEnt in foodList)
        {
            float price = foodEnt.quantity * foodEnt.price;
            NSDictionary *dict = @{@"key01":objectNull(foodEnt.name), @"key02":[NSString stringWithFormat:@"x%d", foodEnt.quantity], @"key03":[NSString stringWithFormat:@"%.2f", price]};
            [addList addObject:dict];
        }
        if (addList.count > 0)
        {
            [manager writeData_content:addList printCharSize:scale_1];
        }
    }
    
    // 其它
    if (detilEntity.detail.extra.count > 0)
    {
        NSString *title = [self getWithPlatform:@"其它费用" detilEntity:detilEntity ch:@"-"];
        [manager writeData_title:title Scale:scale_1 Type:MiddleAlignment];
    }
    
    NSMutableArray *addList = [NSMutableArray new];
    for (HungryOrderDetailCategoryExtraEntity *extEnt in detilEntity.detail.extra)
    {
        float price = extEnt.quantity * extEnt.price;
        NSDictionary *dict = @{@"key01":objectNull(extEnt.name), @"key02":[NSString stringWithFormat:@"x%d", (int)extEnt.quantity], @"key03":[NSString stringWithFormat:@"%.2f", price]};
        [addList addObject:dict];
    }
    if (addList.count > 0)
    {
        [manager writeData_content:addList printCharSize:scale_1];
    }
    
    // 打印分割线
    [manager writeData_line:scale_1];
    
    // 已付
    NSString *total = [NSString stringWithFormat:@"￥%.2f", detilEntity.total_price];
    NSString *empstr = [NSString stringWithFormat:@"已付%@", total];
    int subLen = [self getSubChar:empstr];
    NSMutableString *space = [NSMutableString new];
    for (int i=0; i<subLen; i++)
    {
        [space appendString:@" "];
    }
    NSString *toalpri = [NSString stringWithFormat:@"已付%@%@", space, total];
    [manager writeData_title:objectNull(toalpri) Scale:scale_2 Type:LeftAlignment];
//    [manager writeData_titleValue:@"已付" value:total Scale:scale_2];
    
    // 地址
    [manager writeData_title:objectNull(detilEntity.address) Scale:scale_2 Type:LeftAlignment];
    
    // 食客姓名(收货人)
    [manager writeData_title:objectNull(detilEntity.consignee) Scale:scale_2 Type:LeftAlignment];
    
    // 收货人电话
    NSMutableString *phone = [NSMutableString new];
    for (NSString *mobile in detilEntity.phone_list)
    {
        [phone appendFormat:@",%@", mobile];
    }
    NSString *strPhone = @"";
    if (phone.length > 0)
    {
        strPhone = [phone substringFromIndex:1];
    }
    [manager writeData_title:objectNull(strPhone) Scale:scale_2 Type:LeftAlignment];
    
    
    // 完成
    NSString *finishTitle = [self getWithPlatform:[NSString stringWithFormat:@"#%d完", (int)detilEntity.restaurant_number] detilEntity:detilEntity ch:@"*"];
    [manager writeData_title:finishTitle Scale:scale_1 Type:MiddleAlignment];
    
    // 开始打印
//    [manager performSelector:@selector(printReceipt) withObject:nil afterDelay:1];
    [manager printReceipt];
    
    /*NSDate *date = [NSDate date];
    NSString *nowDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datenum = [date stringWithFormat:@"yyyyMMddHHmmss"];
    // 标题 居中
    [manager writeData_title:@"唐氏餐厅" Scale:scale_2 Type:MiddleAlignment];
    
    [manager writeData_title:@"外卖平台：饿了么" Scale:scale_1 Type:MiddleAlignment];
    
    NSString *orderNum = [NSString stringWithFormat:@"订 单 号：%@0002", datenum];
    
    NSString *placeOrderTime = [NSString stringWithFormat:@"下单时间：%@", nowDate];
    
    NSString *deliveryTime = [NSString stringWithFormat:@"送货时间：%@", nowDate];
    
    NSString *userName = [NSString stringWithFormat:@"用 户 名：%@", @"唐斌"];
    NSString *address = [NSString stringWithFormat:@"送货地址：%@", @"紫东国际创意园201"];
    NSString *payWay = [NSString stringWithFormat:@"支付方式：%@", @"在线支付"];
    [manager writeData_items:@[orderNum, placeOrderTime, deliveryTime, userName, address, payWay]];
    // 打印分割线
//    [manager writeData_line];
    
    [manager writeData_content:@[@{@"key01":@"名称", @"key02":@"数量", @"key03":@"金额"}]];
    // 打印分割线
    [manager writeData_line];
    [manager writeData_content:@[@{@"key01":@"红烧排骨", @"key02":@"x1", @"key03":@"40.00"}, @{@"key01":@"松鼠桂鱼", @"key02":@"x2", @"key03":@"70.00"}]];
    // 打印分割线
    [manager writeData_line];
    
    [manager writeData_title:@"秀味商家" Scale:scale_1 Type:MiddleAlignment];
    */
//    [manager writeData_items:@[@"支付方式:现金", @"应收:28.00", @"实际:30.00", @"找零:2.00"]];
//    UIImage *qrImage = [TYZQRCode qrCodeWithString:@"www.baidu.com" logoName:@"login_icon_logo.png" size:400];
//    [manager writeData_image:qrImage alignment:MiddleAlignment maxWidth:400];
    // 打开钱箱
//    [manager openCashDrawer];
    // 打印小票
//    [manager printReceipt];
    
}

/**
 *  得到添加达达配送的订单参数
 */
- (DaDaDistAddOrderInputEntity *)getAddDadaOrderInputEntity:(HungryOrderDetailEntity *)orderDetailEnt
{
    DaDaDistAddOrderInputEntity *inputEnt = [DaDaDistAddOrderInputEntity new];
    inputEnt.shop_id = [UserLoginStateObject getCurrentShopId];
    if (orderDetailEnt.provider == EN_ORDER_SOURCE_ELE)
    {// 饿了么
        // eleme/meituan
        inputEnt.platform = @"eleme";
    }
    else if (orderDetailEnt.provider == EN_ORDER_SOURCE_MEITUAN)
    {// 美团
        inputEnt.platform = @"meituan";
    }
    inputEnt.order_id = [NSString stringWithFormat:@"%lld", (long long)orderDetailEnt.order_id];
    inputEnt.city_code = @"025";
    inputEnt.order_price = orderDetailEnt.total_price;
    inputEnt.name = objectNull(orderDetailEnt.consignee);
    inputEnt.address = orderDetailEnt.address;
    if (orderDetailEnt.phone_list.count > 0)
    {
        inputEnt.phone = orderDetailEnt.phone_list[0];
    }
    else
    {
        inputEnt.phone = @"";
    }
    NSArray *geoArray = [orderDetailEnt.delivery_geo componentsSeparatedByString:@","];
    if ([geoArray count] == 2)
    {
        id lon = geoArray[0];
        id lat = geoArray[1];
        if (![lon isEqualToString:@""])
        {
            inputEnt.lng = lon;
        }
        
        if (![lat isEqualToString:@""])
        {
            inputEnt.lat = lat;
        }
    }
    
    return inputEnt;
}

/**
 *  商家操作
 */
- (void)shopWithOperator:(NSString *)title indexPath:(NSIndexPath *)indexPath
{
    
//    [_wifiObject connectPrintHost:@"192.168.1.202" onPort:9100];
//    [_wifiObject connectPrintHost:@"www.baidu.com" onPort:80];
//    return;
    self.indexPath = indexPath;
    
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[_indexPath.section];
    
    debugLog(@"title=%@", title);
    // 如果商家给“饿了么”配送，将由系统自行完成，进入“取货中”
    if ([title isEqualToString:@"取消订单"])
    {// 商家(餐厅)取消订单
        // type 1表示商家取消用户的订单；2表示商家取消达达的配送订单
        [self refusedWithOrder:orderDetailEnt type:1];
    }
    else if ([title isEqualToString:@"确认订单"])
    {// 商家确认订单(待接单)，点击确认后，就表示商家接单了
        [self pickupOrder:orderDetailEnt];
    }
    else if ([title isEqualToString:@"呼叫达达"] || [title isEqualToString:@"改发达达"])
    {// 商家可以自动给“饿了么”配送；商家也可以选择达达配送；商家也可以自己配送
        // 调用达达接口，让达达去配送
        [self addOrderToDada:orderDetailEnt];
    }
    else if ([title isEqualToString:@"取消达达"])
    {// 表示取消“达达配送”
        // type 1表示商家取消用户的订单；2表示商家取消达达的配送订单
        [self refusedWithOrder:orderDetailEnt type:2];
    }
    else if ([title isEqualToString:@"增加小费"])
    {// 调用达达接口，给配送增加小费
        [self showWithIncreaseTipView:YES];
    }
//    else if ([title isEqualToString:@"确认退款"])
//    {// 调用“饿了么”接口，退款
//        debugLog(@"orderId=%lld", (long long)orderDetailEnt.order_id);
        
//    }
//    else if ([title isEqualToString:@"取消配送"])
//    {
//        
//    }
}

/**
 * 订单添加给达达配送
 */
- (void)addOrderToDada:(HungryOrderDetailEntity *)orderDetailEnt
{
    /*[SVProgressHUD showWithStatus:@"呼叫达达中"];
    
    DaDaDistAddOrderInputEntity *inputEnt = [self getAddDadaOrderInputEntity:orderDetailEnt];
    [HCSNetHttp requestWithDadaAddOrder:inputEnt completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD dismiss];
            debugLog(@"呼叫达达成功");
            */
    
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_indexPath.section];
            [self.baseTableView beginUpdates];
            [self.baseList removeObjectAtIndex:_indexPath.section];
            [self.baseTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.baseTableView endUpdates];
    
            HungryOrderBodyEntity *orderNoteEnt = [HungryOrderBodyEntity new];
            orderNoteEnt.type = 2;
            orderNoteEnt.commend = DELIVERY_STATUS_TO_BE_ASSIGNED_COURIER;
            
            HungryOrdersEntity *body = [HungryOrdersEntity new];
            if (orderDetailEnt.provider == EN_ORDER_SOURCE_ELE)
            {// 饿了么
                body.platform = @"ele";
            }
            else if (orderDetailEnt.provider == EN_ORDER_SOURCE_MEITUAN)
            {
                body.platform = @"meituan";
            }
            body.eleme_order_id = [NSString stringWithFormat:@"%lld", (long long)orderDetailEnt.order_id];
            orderNoteEnt.body = body;
    
            [_hungryObject revcOrderInfo:orderNoteEnt];
            
        /*}
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];*/
}

- (void)deleteSections:(HungryOrderDetailEntity *)detailEnt
{
    NSInteger index = -1;
    debugLog(@"detailEnt.orderId=%lld", (long long)detailEnt.order_id);
    debugLog(@"count=%d", (int)self.baseList.count);
    for (NSInteger i=0; i<self.baseList.count; i++)
    {
        HungryOrderDetailEntity *ent = self.baseList[i];
        debugLog(@"ent.orderId=%lld", (long long)ent.order_id);
        if (ent.order_id == detailEnt.order_id)
        {
            index = i;
            break;
        }
    }
    
    if (index == -1)
    {
        return;
    }
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_indexPath.section];
        [self.baseTableView beginUpdates];
        [self.baseList removeObjectAtIndex:_indexPath.section];
        [self.baseTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.baseTableView endUpdates];
        
        [self initWithEmptyView];
    });
    
}

/**
 *   接收到新的订单
 */
- (void)revcOrderInfo:(NSNotification *)note
{
    debugLog(@"----接收到信息");
    HungryOrderNoteEntity *noteEnt = [note object];
//    HungryOrderNoteEntity
    
    HungryOrderDetailEntity *detailEnt = noteEnt.orderEntitiy;
    if (!detailEnt)
    {
        debugLog(@"detailEnt is nil.");
        return;
    }
    
    
    if (_orderType == EN_TM_ORDER_WAIT_ORDER)
    {// 待接单
        
        if (detailEnt.status_code == STATUS_CODE_UNPROCESSED)
        {// 订单等待餐厅确认
            [self addWithOrderDetail:detailEnt];
        }
    }
    else if (_orderType == EN_TM_ORDER_RECEIVE_ORDER)
    {// 已接单
        // 删除
        [self removeWithOrderDetail:detailEnt];
        
        if (detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == 0)
        {// 订单已处理、待分配（物流系统已生成运单，待分配配送商）
            [self addWithOrderDetail:detailEnt];
        }
    }
    else if (_orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
    {// 配送未接单
        if (detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_BE_ASSIGNED_COURIER)
        {// 订单已处理、待取餐（已分配给配送员，配送员未取餐）
            [self addWithOrderDetail:detailEnt];
        }
        else if (detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_BE_FETCHED)
        {
            debugLog(@"dfsfds");
            // 删除
            [self removeWithOrderDetail:detailEnt];
        }
    }
    else if (_orderType == EN_TM_ORDER_PICKUP_ORDER)
    {// 取货中
        if (detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_BE_FETCHED)
        {// 订单已处理、待取餐（已分配给配送员，配送员未取餐）
            [self addWithOrderDetail:detailEnt];
        }
        else if ((detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_DELIVERING))
        {// 配送中（配送员已取餐，正在配送）
            // 删除
            [self removeWithOrderDetail:detailEnt];
        }

    }
    else if (_orderType == EN_TM_ORDER_DIST_RESULT_ORDER)
    {// 配送结果
        if ((detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_DELIVERING) || (detailEnt.status_code == STATUS_CODE_PROCESSED_AND_VALID && detailEnt.deliver_status == DELIVER_COMPLETED) || detailEnt.status_code == STATUS_CODE_FINISHED)
        {
            [self addWithOrderDetail:detailEnt];
        }
    }
    else if (_orderType == EN_TM_ORDER_EXCEPTION_ORDER)
    {
        if (detailEnt.status_code == STATUS_CODE_INVALID)
        {
            [self addWithOrderDetail:detailEnt];
        }
        // 【STATUS_CODE_INVALID[订单已取消] || refund_code(退单)】
    }
}

/**
 *  拒接订单(取消订单)
 
 *  @param type 1表示商家取消用户的订单；2表示商家取消达达的配送订单
 */
- (void)refusedWithOrder:(HungryOrderDetailEntity *)detailEntity type:(int)type
{
    [MCYPushViewController showWithDeliveryCancelOrderVC:self data:detailEntity type:type completion:^(id data) {
        // 返回结果
        if ([data isEqualToString:@"cancelSuccess"])
        {// 取消成功
            [self deleteSections:detailEntity];
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_indexPath.section];
//            [self.baseTableView beginUpdates];
//            [self.baseList removeObjectAtIndex:_indexPath.section];
//            [self.baseTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.baseTableView endUpdates];
        }
        else if ([data isEqualToString:@"cancelDADASuccess"])
        {
            [self deleteSections:detailEntity];
            HungryOrderBodyEntity *orderNoteEnt = [HungryOrderBodyEntity new];
            orderNoteEnt.type = 2;
            orderNoteEnt.commend = ELEME_ORDER_PROCESSED_AND_VALID;
            
            HungryOrdersEntity *body = [HungryOrdersEntity new];
            if (detailEntity.provider == EN_ORDER_SOURCE_ELE)
            {// 饿了么
                body.platform = @"ele";
            }
            else if (detailEntity.provider == EN_ORDER_SOURCE_MEITUAN)
            {
                body.platform = @"meituan";
            }
            body.eleme_order_id = [NSString stringWithFormat:@"%lld", (long long)detailEntity.order_id];
            orderNoteEnt.body = body;
            
            [_hungryObject revcOrderInfo:orderNoteEnt];
        }
    }];
}

/**
 *  商家接单
 */
- (void)pickupOrder:(HungryOrderDetailEntity *)detailEntity
{
    [SVProgressHUD showWithStatus:@"接单中"];
    NSString *orderId = [NSString stringWithFormat:@"%lld", (long long)detailEntity.order_id];
    [HCSNetHttp requestWithWaimaiConfirmOrder:orderId completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            // 打印
            [self printWithFood:detailEntity];
            
            [SVProgressHUD showSuccessWithStatus:@"接单成功"];
            
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_indexPath.section];
            [self.baseTableView beginUpdates];
            [self.baseList removeObjectAtIndex:_indexPath.section];
            [self.baseTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.baseTableView endUpdates];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
}



/**
 *  展开或者收取
 */
- (void)touchCharge:(NSIndexPath *)indexPath
{
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[indexPath.section];
    orderDetailEnt.isCharge = !orderDetailEnt.isCharge;
    
    DeliveryOrderInfoViewCell *cell = (DeliveryOrderInfoViewCell *)[self.baseTableView cellForRowAtIndexPath:indexPath];
    [cell updateCellData:orderDetailEnt];
    
    if (orderDetailEnt.isCharge)
    {
        NSMutableArray *addList = [NSMutableArray new];
        [addList addObject:[NSIndexPath indexPathForRow:1+indexPath.row inSection:indexPath.section]];
        
        [self.baseTableView insertRowsAtIndexPaths:addList withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        NSMutableArray *addList = [NSMutableArray new];
        [addList addObject:[NSIndexPath indexPathForRow:1+indexPath.row inSection:indexPath.section]];
        [self.baseTableView deleteRowsAtIndexPaths:addList withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.baseList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[section];
    if (orderDetailEnt.isCharge)
    {
        return 1 + orderDetailEnt.detail.newgroups.count + 3;
    }
    if (orderDetailEnt.invalid_type == TYPE_SYSTEM_AUTO_CANCEL)
    {// 系统自动取消订单
        return 1 + orderDetailEnt.detail.newgroups.count + 1;
    }
    return 1 + orderDetailEnt.detail.newgroups.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[indexPath.section];
    NSInteger count = orderDetailEnt.detail.newgroups.count;
    if (indexPath.row == 0)
    {// 用户基本信息
        DeliveryOrderUserBaseInfoCell *cell = [DeliveryOrderUserBaseInfoCell cellForTableView:tableView];
        [cell updateCellData:orderDetailEnt orderType:_orderType];
        return cell;
    }
    else if (indexPath.row == count + 1)
    {// 订单信息
        DeliveryOrderInfoViewCell *cell = [DeliveryOrderInfoViewCell cellForTableView:tableView];
        [cell updateCellData:orderDetailEnt orderType:_orderType];
        cell.touchChargeBlock = ^()
        {// 展开
            [weakSelf touchCharge:indexPath];
        };
        return cell;
    }
    else if (indexPath.row == count + 2 && orderDetailEnt.isCharge)
    {// 订单详细信息
        DeliveryOrderDetailViewCell *cell = [DeliveryOrderDetailViewCell cellForTableView:tableView];
        [cell updateCellData:orderDetailEnt.detail.newextra];
        return cell;
    }
    else if ((indexPath.row == count + 2 && !orderDetailEnt.isCharge) || (indexPath.row == count + 3 && orderDetailEnt.isCharge))
    {// 功能按钮视图
        /*
         EN_TM_ORDER_WAIT_ORDER = 0,     ///< 待接单
         EN_TM_ORDER_RECEIVE_ORDER,      ///< 已接单
         EN_TM_ORDER_SHIP_NOT_ORDER,     ///< 配送未接单
         EN_TM_ORDER_PICKUP_ORDER,       ///< 取货中
         EN_TM_ORDER_DIST_RESULT_ORDER,  ///< 配送结果
         EN_TM_ORDER_EXCEPTION_ORDER,    ///< 异常订单
         */
        if (_orderType == EN_TM_ORDER_WAIT_ORDER || _orderType == EN_TM_ORDER_RECEIVE_ORDER || _orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
        {// 待接单、已接单、配送未接单
            DeliveryOrderOperatorViewCell *cell = [DeliveryOrderOperatorViewCell cellForTableView:tableView];
            [cell updateCellData:orderDetailEnt orderType:_orderType];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf shopWithOperator:data indexPath:indexPath];
            };
            return cell;
        }
        else if (_orderType == EN_TM_ORDER_PICKUP_ORDER || _orderType == EN_TM_ORDER_DIST_RESULT_ORDER)
        {// 取货中、配送结果
            DeliveryOrderDistributionViewCell *cell = [DeliveryOrderDistributionViewCell cellForTableView:tableView];
            [cell updateCellData:orderDetailEnt orderType:_orderType];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf shopWithOperator:data indexPath:indexPath];
            };
            return cell;
        }
        else
        {// 异常订单
            DeliveryOrderOperatorViewCell *cell = [DeliveryOrderOperatorViewCell cellForTableView:tableView];
            [cell updateCellData:orderDetailEnt orderType:_orderType];
            return cell;
        }
    }
    else
    {
        HungryOrderFoodEntity *foodEnt = orderDetailEnt.detail.newgroups[indexPath.row - 1];
        DeliveryOrderFoodInfoViewCell *cell = [DeliveryOrderFoodInfoViewCell cellForTableView:tableView];
        [cell updateCellData:foodEnt];
        [cell hiddenBottomLine:NO];
        if (indexPath.row == count)
        {
            [cell hiddenBottomLine:YES];
        }
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 60;
    HungryOrderDetailEntity *orderDetailEnt = self.baseList[indexPath.section];
    NSInteger count = orderDetailEnt.detail.newgroups.count;
    if (indexPath.row == 0)
    {
        height = kDeliveryOrderUserBaseInfoCellHeight - 20 + orderDetailEnt.addressHeight;
    }
    else if (indexPath.row == count + 1)
    {// 订单信息
        height = kDeliveryOrderInfoViewCellHeight;
        if (orderDetailEnt.isCharge)
        {
            height = height - 4;
        }
        if (orderDetailEnt.invalid_type == TYPE_SYSTEM_AUTO_CANCEL)
        {// 系统自动取消订单
            height = height - 16 - 4;
        }
    }
    else if (indexPath.row == count + 2 && orderDetailEnt.isCharge)
    {// 订单详细信息
        NSInteger count = orderDetailEnt.detail.newextra.count;
        height = 0 + 16 * count + 4 * (count - 1) + 8;
    }
    else if ((indexPath.row == count + 2 && !orderDetailEnt.isCharge) || (indexPath.row == count + 3 && orderDetailEnt.isCharge))
    {// 功能按钮视图
        
        if (_orderType == EN_TM_ORDER_WAIT_ORDER || _orderType == EN_TM_ORDER_RECEIVE_ORDER || _orderType == EN_TM_ORDER_SHIP_NOT_ORDER)
        {// 待接单、已接单、配送未接单
            height = kDeliveryOrderOperatorViewCellHeight;
        }
        else if (_orderType == EN_TM_ORDER_PICKUP_ORDER || _orderType == EN_TM_ORDER_DIST_RESULT_ORDER)
        {// 取货中、配送结果
            height = kDeliveryOrderDistributionViewCellHeight;
        }
        else
        {// 异常订单
            height = kDeliveryOrderOperatorViewCellHeight;
        }
    }
    else
    {
        height = kDeliveryOrderFoodInfoViewCellHeight;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}


@end














