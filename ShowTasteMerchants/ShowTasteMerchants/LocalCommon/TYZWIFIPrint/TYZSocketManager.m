//
//  TYZSocketManager.m
//  ShowTasteMerchants
//
//  Created by 唐斌 on 2016/11/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZSocketManager.h"
#import "TYZKit.h"
#import "SVProgressHUD.h"

@interface TYZSocketManager ()

@property (nonatomic, strong) AsyncSocket *asyncSocket;

/// 0表示关闭连接了；1表示连接成功；2表示将要连接
@property (nonatomic, assign) int connectState;

@end

@implementation TYZSocketManager

- (instancetype)init
{
    if (self = [super init])
    {
        _connectState = 0;
        self.asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
        [self.asyncSocket setRunLoopModes:@[NSRunLoopCommonModes]];
    }
    return self;
}

#pragma mark -
#pragma mark public methods
//连接打印机
- (void)socketConnectToPrint:(NSString *)host port:(UInt16)port timeout:(NSTimeInterval)timeout
{
    NSError *error = nil;
    [self.asyncSocket connectToHost:host onPort:port withTimeout:timeout error:&error];
//     debugLog(@"error=%@", [error localizedDescription]);
//    debugLog(@"bRet=%d", bRet);
}

//检查连接状态
- (BOOL)socketIsConnect
{
    BOOL isConn = [self.asyncSocket isConnected];
    if (isConn)
    {
        debugLog(@"host=%@\nport=%hu\nlocalHost=%@\nlocalPort=%hu",self.asyncSocket.connectedHost,self.asyncSocket.connectedPort,self.asyncSocket.localHost,self.asyncSocket.localPort);
    }
    return isConn;
}
//发送数据
- (void)socketWriteData:(NSData *)data
{
//    if (![self socketIsConnect])
//    {
//        [SVProgressHUD showInfoWithStatus:@"跟打印机没有连接"];
//        debugLog(@"跟打印机没有连接");
//        return;
//    }
    [self.asyncSocket writeData:data withTimeout:-1 tag:0];
}

//手动断开连接
- (void)socketDisconnectSocket
{
    [self.asyncSocket disconnect];
}

#pragma mark -
#pragma mark AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    debugLog(@"%s--连接成功", __func__);
//    self.connectState = 1;
    if (_blockCheckData)
    {
        _blockPrintData();
    }
    // 写入数据后连接断开
    [sock disconnectAfterWriting];
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    debugLog(@"%s--关闭连接", __func__);
    
//    if (_connectState == 2)
//    {
//        [SVProgressHUD showInfoWithStatus:@"打印机未连接好！"];
//    }
//    _connectState = 0;
    if (_blockCheckData)
    {
        _blockCheckData();
    }
}
//
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
//    self.connectState = 2;
    debugLog(@"%s--将要连接", __func__);
    return YES;
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    debugLog(@"%s--读取完成", __func__);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    debugLog(@"%s--写入完成", __func__);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    debugLog(@"%s--即将断开", __func__);
    if (err)
    {
        // [SVProgressHUD showInfoWithStatus:@"打印机未连接好！"];
        [SVProgressHUD showInfoWithStatus:@"打印机未连接好！"];
    }
    debugLog(@"err=%@", [err localizedDescription]);
}


@end
