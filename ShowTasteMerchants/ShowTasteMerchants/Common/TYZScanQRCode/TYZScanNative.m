/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanNative.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/29 11:36
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanNative.h"


@interface TYZScanNative () <AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL bNeedScanResult;
}

/// 摄像头设备
@property (nonatomic, assign) AVCaptureDevice *device;

/// 输入设备设置
@property (nonatomic, strong) AVCaptureDeviceInput *input;

/// 输出设备设置
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/// 二维码生成绘画
@property (nonatomic, strong) AVCaptureSession *session;

/// 二维码生成的图层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

/// 拍照
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, assign) BOOL isNeedCaputureImage;

/// 扫码结果
@property (nonatomic, strong) NSMutableArray<TYZScanResult *> *arrayResult;

/// 扫码类型
@property (nonatomic, strong) NSArray *arrayBarCodeType;

/// 视频预览显示视图
@property (nonatomic, weak) UIView *videoPreView;

@property (nonatomic, copy) void (^blockScanResult)(NSArray<TYZScanResult *> *array);

@end

@implementation TYZScanNative

- (void)setNeedCaptureImage:(BOOL)isNeedCaputureImg
{
    _isNeedCaputureImage = isNeedCaputureImg;
}

+ (CGFloat)getCameraVideoMaxScale
{
    return 50.0;
}

- (id)initWithPreView:(UIView *)preView ObjectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void (^)(NSArray<TYZScanResult *> *))block
{
    if (self = [super init])
    {
        [self initParaWithPreView:preView objectType:objType cropRect:cropRect success:block];
    }
    return self;
}

- (void)initParaWithPreView:(UIView *)videoPreView objectType:(NSArray *)objType cropRect:(CGRect)cropRect success:(void(^)(NSArray<TYZScanResult *> *array))block
{
    self.arrayBarCodeType = objType;
    self.blockScanResult = block;
    self.videoPreView = videoPreView;
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!_device)
    {
        return;
    }
    
    // input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    if (!_input)
    {
        return;
    }
    
    bNeedScanResult = YES;
    
    // output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if (!CGRectEqualToRect(cropRect, CGRectZero))
    {
        _output.rectOfInterest = cropRect;
    }
    
    // setup the still image file output
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    
    // session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:_input])
    {
        [_session addInput:_input];
    }
    
    if ([_session canAddOutput:_output])
    {
        [_session addOutput:_output];
    }
    
    if ([_session canAddOutput:_stillImageOutput])
    {
        [_session addOutput:_stillImageOutput];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    if (!objType)
    {
        objType = [self defaultMetaDataObjectTypes];
    }
    
    _output.metadataObjectTypes = objType;
    
    // preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    CGRect frame = videoPreView.frame;
    frame.origin = CGPointZero;
    _preview.frame = frame;
    
    [_videoPreView.layer insertSublayer:self.preview atIndex:0];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat scale = videoConnection.videoScaleAndCropFactor;
    NSLog(@"scale=%.2f", scale);
    
    // 先进行判断是否支持控制对焦，不开启自动对焦功能，很难识别二维码
    if (_device.isFocusPointOfInterestSupported && [_device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        [_input.device lockForConfiguration:nil];
        [_input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [_input.device unlockForConfiguration];
    }
}

- (CGFloat)getVideoMaxScale
{
    [_input.device lockForConfiguration:nil];
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    CGFloat maxScale = videoConnection.videoMaxScaleAndCropFactor;
    [_input.device unlockForConfiguration];
    
    return maxScale;
}

- (void)setVideoScale:(CGFloat)scale
{
    [_input.device lockForConfiguration:nil];
    
    AVCaptureConnection *videoConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    
    CGFloat zoom = scale / videoConnection.videoScaleAndCropFactor;
    
    videoConnection.videoScaleAndCropFactor = scale;
    
    [_input.device unlockForConfiguration];
    
    CGAffineTransform transform = _videoPreView.transform;
    
    _videoPreView.transform = CGAffineTransformScale(transform, zoom, zoom);
}

- (void)setScanRect:(CGRect)scanRect
{
    // 识别区域设置
    if (_output)
    {
        _output.rectOfInterest = [self.preview metadataOutputRectOfInterestForRect:scanRect];
    }
}

- (void)changeScanType:(NSArray *)objType
{
    _output.metadataObjectTypes = objType;
}

- (void)startScan
{
    if (_input && !_session.isRunning)
    {
        [_session startRunning];
        bNeedScanResult = YES;
        
        [_videoPreView.layer insertSublayer:self.preview atIndex:0];
    }
    bNeedScanResult = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == _input.device)
    {
        NSLog(@"flash change");
    }
}

- (void)stopScan
{
    bNeedScanResult = NO;
    if (_input && _session.isRunning)
    {
        bNeedScanResult = NO;
        [_session stopRunning];
    }
}

// 开启关闭闪光灯
- (void)setTorch:(BOOL)torch
{
    [self.input.device lockForConfiguration:nil];
    self.input.device.torchMode = (torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff);
    [self.input.device unlockForConfiguration];
}

- (void)changeTorch
{
    AVCaptureTorchMode torch = self.input.device.torchMode;
    
    switch (_input.device.torchMode)
    {
        case AVCaptureTorchModeAuto:
            break;
        case AVCaptureTorchModeOff:
            torch = AVCaptureTorchModeOn;
            break;
        case AVCaptureTorchModeOn:
            torch = AVCaptureTorchModeOff;
            break;
        default:
            break;
    }
    [_input.device lockForConfiguration:nil];
    _input.device.torchMode = torch;
    [_input.device unlockForConfiguration];
}

- (UIImage *)getImageFromLayer:(CALayer *)layer size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, [[UIScreen mainScreen] scale]);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections
{
    for (AVCaptureConnection *connection in connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:mediaType])
            {
                return connection;
            }
        }
    }
    return nil;
}

- (void)captureImage
{
    AVCaptureConnection *stillImageConnection = [self connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self stillImageOutput] connections]];
    
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        [self stopScan];
        if (imageDataSampleBuffer)
        {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage *img = [UIImage imageWithData:imageData];
            
            for (TYZScanResult *result in _arrayResult)
            {
                result.imgScanned = img;
            }
        }
        if (_blockScanResult)
        {
            _blockScanResult(_arrayResult);
        }
        
    }];
}


#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput2:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 识别扫码类型
    for (AVMetadataObject *current in metadataObjects)
    {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
            NSLog(@"type:%@", current.type);
            NSLog(@"result:%@", scannedResult);
            
            // 测试可以同时识别多个二维码
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!bNeedScanResult)
    {
        return;
    }
    
    bNeedScanResult = NO;
    
    if (!_arrayResult)
    {
        self.arrayResult = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        [_arrayResult removeAllObjects];
    }
    
    // 识别扫码类型
    for (AVMetadataObject *current in metadataObjects)
    {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]])
        {
            bNeedScanResult = NO;
            
            NSLog(@"type=%@", current.type);
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
            
            if (scannedResult && ![scannedResult isEqualToString:@""])
            {
                TYZScanResult *result = [TYZScanResult new];
                result.strScanned = scannedResult;
                result.strBarCodeType = current.type;
                
                [_arrayResult addObject:result];
            }
            // 测试可以同时识别多个二维码
        }
    }
    
    if (_arrayResult.count < 1)
    {
        bNeedScanResult = YES;
        return;
    }
    
    if (_isNeedCaputureImage)
    {
        [self captureImage];
    }
    else
    {
        [self stopScan];
        
        if (_blockScanResult)
        {
            _blockScanResult(_arrayResult);
        }
    }
}

/**
 *  @brief 默认支持码的类型
 *
 *  @return 支持类别 数组
 */
- (NSArray *)defaultMetaDataObjectTypes
{
    NSMutableArray *types = [@[AVMetadataObjectTypeQRCode,
                               AVMetadataObjectTypeUPCECode,
                               AVMetadataObjectTypeCode39Code,
                               AVMetadataObjectTypeCode39Mod43Code,
                               AVMetadataObjectTypeEAN13Code,
                               AVMetadataObjectTypeEAN8Code,
                               AVMetadataObjectTypeCode93Code,
                               AVMetadataObjectTypeCode128Code,
                               AVMetadataObjectTypePDF417Code,
                               AVMetadataObjectTypeAztecCode] mutableCopy];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)
    {
        [types addObjectsFromArray:@[
                                     AVMetadataObjectTypeInterleaved2of5Code,
                                     AVMetadataObjectTypeITF14Code,
                                     AVMetadataObjectTypeDataMatrixCode
                                     ]];
    }
    
    return types;
}

@end



























