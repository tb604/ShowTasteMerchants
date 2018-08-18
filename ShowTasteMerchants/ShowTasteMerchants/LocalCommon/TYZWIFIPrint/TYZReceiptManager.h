//
//  TYZReceiptManager.h
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYZSocketManager.h"
#import "TYZPrinterManager.h"

/*
 demo:
 - (void)printWithFood
 {
 NSString *host = @"192.168.1.202";
 UInt16 port = 9100;
 NSTimeInterval timeout = 10;
 MMReceiptManager *manager = [[MMReceiptManager alloc] initWithHost:host port:port timeout:timeout];
 
 self.receiptManager = manager;
 
 // 基础设置
 [manager basicSetting];
 
 NSDate *date = [NSDate date];
 NSString *nowDate = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString *datenum = [date stringWithFormat:@"yyyyMMddHHmmss"];
 // 标题 居中
 [manager writeData_title:@"肯德基" Scale:scale_2 Type:MiddleAlignment];
 NSString *tradDate = [NSString stringWithFormat:@"交易时间：%@", nowDate];
 NSString *tradNum = [NSString stringWithFormat:@"交易号：%@0002", datenum];
 [manager writeData_items:@[@"收银员：001", tradDate, tradNum]];
 // 打印分割线
 //    [manager writeData_line];
 
 [manager writeData_content:@[@{@"key01":@"名称", @"key02":@"单价", @"key03":@"数量", @"key04":@"总价"}]];
 // 打印分割线
 [manager writeData_line];
 [manager writeData_content:@[@{@"key01":@"汉堡", @"key02":@"10.00", @"key03":@"2", @"key04":@"20.00"}, @{@"key01":@"炸鸡", @"key02":@"8.00", @"key03":@"1", @"key04":@"8.00"}]];
 // 打印分割线
 [manager writeData_line];
 [manager writeData_items:@[@"支付方式:现金", @"应收:28.00", @"实际:30.00", @"找零:2.00"]];
 UIImage *qrImage = [MMQRCode qrCodeWithString:@"www.baidu.com" logoName:@"login_icon_logo.png" size:400];
 [manager writeData_image:qrImage alignment:MiddleAlignment maxWidth:400];
 // 打开钱箱
 //    [manager openCashDrawer];
 // 打印小票
 [manager printReceipt];
 
 }
 */

/*
 * 打印单据
 */
@interface TYZReceiptManager : NSObject

/// 打印连接管理
@property (nonatomic, strong) TYZSocketManager *asynaSocket;

/// 打印管理
@property (nonatomic, strong) TYZPrinterManager *printerManager;

/**
 *  初始化连接
 *
 *  @param host 地址
 *  @param port 端口号
 *  @param timeout 超时
 */
- (instancetype)initWithHost:(NSString *)host port:(UInt16)port timeout:(NSTimeInterval)timeout;

/**
 *  连接打印机
 *
 *  @param host 地址
 *  @param port 端口号
 *  @param timeout 超时
 */
- (void)connectWithHost:(NSString *)host port:(UInt16)port timeout:(NSTimeInterval)timeout;

/**
 *  基础设置
 */
- (void)basicSetting;

/**
 *  清空缓存数据
 */
- (void)clearData;

/*
 *  写入单行文字
 *
 *  @param title 标题
 *  @param scale 字符放大倍数
 *  @param type 对齐方式
 */
- (void)writeData_title:(NSString *)title Scale:(kCharScale)scale Type:(kAlignmentType)type;

/**
 * 写入单行文字，左边和右边
 *
 *  @param title 左边的标题
 *  @param value 右边值
 *  @param scale 字符放大倍数
 */
- (void)writeData_titleValue:(NSString *)title value:(NSString *)value Scale:(kCharScale)scale;

/**
 *  写入多行文字
 *
 *  @param items 多行数据
 */
- (void)writeData_items:(NSArray *)items;

/**
 *  打印图片
 *
 *  @param image 图片
 *  @param alignment 对齐方式
 *  @param maxWidth 最大宽度
 */
- (void)writeData_image:(UIImage *)image alignment:(kAlignmentType)alignment maxWidth:(CGFloat)maxWidth;

/**
 *  条目,菜单,有间隔
 *
 *  @param items 内容
 */
- (void)writeData_content:(NSArray *)items printCharSize:(kCharScale)scale;

/**
 *  打印分割线
 */
- (void)writeData_line:(kCharScale)scale;

/**
 *  打开钱箱
 */
- (void)openCashDrawer;

/**
 *  打印小票
 */
- (void)printReceipt;

@end
