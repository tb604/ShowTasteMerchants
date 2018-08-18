//
//  ThridPartPayChoiceViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/1.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "ThridPartPayChoiceViewController.h"
#import "LocalCommon.h"
#import "ThridPartPayChoiceView.h"
#import "TYZShowImageInfoObject.h" // 上传图片
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台

@interface ThridPartPayChoiceViewController () <UITextFieldDelegate>
{
    
    UIScrollView *_contentView;
    
    /// 支付宝支付设置
    ThridPartPayChoiceView *_alipayView;
    
    /// 微信支付
    ThridPartPayChoiceView *_weixinPayView;
    
    NSMutableArray *_payList;
}

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;

/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

@property (nonatomic, strong) TYZShowImageInfoObject *showImageObject;

- (void)initWithShowImageObject;

- (void)initWithContentView;

/**
 *  初始化支付宝支付
 */
- (void)initWithAlipayView;

/**
 *  初始化微信支付
 */
- (void)initWithWeixinPayView;

@end

@implementation ThridPartPayChoiceViewController

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

- (void)initWithVar
{
    [super initWithVar];
    
//    self.selectPayTypeEnt = _payEntity;
    
//    debugLog(@"pay=%@", [_selectPayTypeEnt modelToJSONString]);
    
    _payList = [[NSMutableArray alloc] initWithCapacity:2];
    
    // 支付宝
    PayInfoDataEntity *payEnt = [PayInfoDataEntity new];
    payEnt.type = 1;
    payEnt.payName = @"支付宝账户";
    payEnt.payImageName = @"escrow_icon_zhifubaozhifu";
    payEnt.account = nil;//@"7888@qq.com";
    [_payList addObject:payEnt];
//    if (_payEntity.type == 0 || _payEntity.type == 1)
//    {
//        self.selectPayTypeEnt = payEnt;
//    }
    
    payEnt = [PayInfoDataEntity new];
    payEnt.type = 2;
    payEnt.payName = @"微信钱包";
    payEnt.payImageName = @"escrow_icon-weixinzhifu";
    payEnt.account = @"18261929604";
    [_payList addObject:payEnt];
    
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    [self initWithShowImageObject];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"收款第三方";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    // 初始化支付宝支付
    [self initWithAlipayView];
    
    // 初始化微信支付
    [self initWithWeixinPayView];
}

- (void)clickedBack:(id)sender
{
    [super clickedBack:sender];
}

#pragma mark -
#pragma mark private methods

- (void)initWithContentView
{
    if (!_contentView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight]);
        _contentView = [[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        [self.view addSubview:_contentView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//        [_contentView addGestureRecognizer:tap];
        
    }
}

/**
 *  初始化支付宝支付
 */
- (void)initWithAlipayView
{
    if (!_alipayView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kThridPartPayChoiceViewHeight);
        _alipayView = [[ThridPartPayChoiceView alloc] initWithFrame:frame];
        _alipayView.payAccountTxtField.delegate = self;
        [_contentView addSubview:_alipayView];
    }
    [_alipayView updateViewData:_payList[0]];
    __weak typeof(self)weakSelf = self;
    _alipayView.uploadQrcodeImageBlock = ^(PayInfoDataEntity *payEnt)
    {
        [weakSelf.showImageObject showActionSheet:weakSelf];
    };
}

/**
 *  初始化微信支付
 */
- (void)initWithWeixinPayView
{
    if (!_weixinPayView)
    {
        CGRect frame = _alipayView.frame;
        frame.origin.y = _alipayView.bottom;
        _weixinPayView = [[ThridPartPayChoiceView alloc] initWithFrame:frame];
        _weixinPayView.payAccountTxtField.delegate = self;
        [_contentView addSubview:_weixinPayView];
        [_weixinPayView hiddenWithBottomLine:YES];
    }
    [_weixinPayView updateViewData:_payList[1]];
    __weak typeof(self)weakSelf = self;
    _weixinPayView.uploadQrcodeImageBlock = ^(PayInfoDataEntity *payEnt)
    {
        [weakSelf.showImageObject showActionSheet:weakSelf];
    };
}

- (void)initWithShowImageObject
{
    __weak typeof(self)weakSelf = self;
    _showImageObject = [[TYZShowImageInfoObject alloc] init];
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenWidth]);
    _showImageObject.imgType = EN_IMAGE_SQUARE_ACTION;
    _showImageObject.extName = @"jpg";
    _showImageObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {
        UIImage *image = [UIImage imageWithData:data];
        debugLogSize(image.size);
        [weakSelf uploadImageToServer:data imageName:imgName];
    };
}

- (void)uploadImageToServer:(NSData *)data imageName:(NSString *)imageName
{
    //    debugLog(@"imageName=%@", imageName);
    [SVProgressHUD showWithStatus:@"上传中"];
    _uploadFileInputEntity.data = data;
    _uploadFileInputEntity.extName = _showImageObject.extName;
    
    debugLog(@"inputEnt=%@", [_uploadFileInputEntity modelToJSONString]);
    
    __weak typeof(self)weakSelf = self;
    [_uploadImgServerObject getUploadFileToken:_uploadFileInputEntity complete:^(int status, NSString *host, NSString *filePath, NSInteger imageId) {
        debugLog(@"status=%d; filePath=%@", status, filePath);
        if (status == 1)
        {
            [weakSelf uploadImageResponse:status urlPath:filePath];
        }
    }];
}

- (void)uploadImageResponse:(int)status urlPath:(NSString *)urlPath
{
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_weixinPayView.payAccountTxtField isEqual:textField])
    {
        if (kiPhone5)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-90, 0, 0, 0);
        }
        else if (kiPhone4)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
        }
        else if (kiPhone6)
        {
            _contentView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if ([_weixinPayView.payAccountTxtField isEqual:textField])
    {
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return YES;
}


@end



























