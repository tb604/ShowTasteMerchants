/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: TYZScan
 * 文件名称: TYZScanViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/31 23:45
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "TYZScanViewController.h"

@interface TYZScanViewController ()

@end

@implementation TYZScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[TYZScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
        
    }
    
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
    
    
}

- (void)reStartDevice
{
    [_scanObj startScan];
}

//启动设备
- (void)startScan
{
    if ( ![TYZScanWrapper isGetCameraPermission])
    {
        [_qRScanView stopDeviceReadying];
        
//        [self showError:@"   请到设置隐私中开启本程序相机权限   "];
        NSLog(@"   请到设置隐私中开启本程序相机权限   ");
        return;
    }
    
    if (!_scanObj )
    {
        __weak __typeof(self) weakSelf = self;
        // AVMetadataObjectTypeQRCode   AVMetadataObjectTypeEAN13Code
        
        CGRect cropRect = CGRectZero;
        
        if (_isOpenInterestRect)
        {
            
            cropRect = [TYZScanView getScanRectWithPreView:self.view style:_style];
        }
        
        UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        videoView.backgroundColor = [UIColor clearColor];
        
        
        [self.view insertSubview:videoView atIndex:0];
        
        self.scanObj = [[TYZScanWrapper alloc] initWithPreView:videoView ArrayObjectType:nil cropRect:cropRect success:^(NSArray<TYZScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
        
        // 设置扫码成功后是否拍照，ios7 AVFoundation框架，
        [_scanObj setNeedCaptureImage:_isNeedScanImage];
//
        [self cameraInitOver];
        
    }
    
    // 开始扫码,扫码成功返回数据后，内部调用stopScan，重新扫描需要重新调用startScan
    [_scanObj startScan];
    
    // 设备启动完成
    [_qRScanView stopDeviceReadying];
    
    // 开始扫描动画
    [_qRScanView startScanAnimation];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)cameraInitOver
{
    NSLog(@"%@--%s", [self description], __func__);
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_scanObj stopScan];
    [_qRScanView stopScanAnimation];
}



#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<TYZScanResult*>*)array
{
    
}





//开关闪光灯
- (void)openOrCloseFlash
{
    [_scanObj openOrCloseFlash];
    
    self.isOpenFlash =!self.isOpenFlash;
    
}


#pragma mark --打开相册并识别图片

/*!
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    
    //    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}



//当选择一张图片后进入这里

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    __weak __typeof(self) weakSelf = self;
    [TYZScanWrapper recognizeImage:image success:^(NSArray<TYZScanResult *> *array) {
        
        [weakSelf scanResultWithArray:array];
    }];
    
    
    
    //系统自带识别方法
    /*
     CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
     NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
     if (features.count >=1)
     {
     CIQRCodeFeature *feature = [features objectAtIndex:0];
     NSString *scanResult = feature.messageString;
     
     NSLog(@"%@",scanResult);
     }
     */
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//子类继承必须实现的提示
- (void)showError:(NSString*)str
{
    
}


@end
