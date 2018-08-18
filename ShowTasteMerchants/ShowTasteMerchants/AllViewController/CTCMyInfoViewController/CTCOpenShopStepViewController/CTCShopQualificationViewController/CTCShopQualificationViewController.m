/*
 *   Copyright © 2016年 唐斌. All rights reserved.
 *
 * 项目名称: ShowTasteMerchants
 * 文件名称: CTCShopQualificationViewController.m
 * 文件标识:
 * 摘要描述:
 *
 * 当前版本:
 * 作者姓名: 唐斌
 * 创建日期: 2016/10/19 17:34
 * 完成日期:
 *
 * 取代版本:
 * 作者姓名: 输入作者(或修改者)名字
 * 完成日期:
 */

#import "CTCShopQualificationViewController.h"
#import "LocalCommon.h"
#import "CTCShopQualificationHeaderView.h"
#import "CTCShopQualificationFooterView.h"
#import "OpenRestaurantBottomView.h"
#import "CTCShopQualificationViewCell.h"
#import "CTCShopInstanceReferenceBgView.h"
#import "RestaurantDetailDataEntity.h"

#import "TYZShowImageInfoObject.h" // 上传图片
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "CTCShopLicenseDataEntity.h" // 资质审核数据
#import "CTCShopCertificateDataEntity.h"
#import "MyRestaurantListViewController.h" // 餐厅列表视图控制器

@interface CTCShopQualificationViewController ()
{
    CTCShopQualificationHeaderView *_headerView;
    
    CTCShopQualificationFooterView *_footerView;
    
    OpenRestaurantBottomView *_bottomView;
    
    CTCShopInstanceReferenceBgView *_instanceRefView;
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

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithShowImageObject;

- (void)initWithBottomView;

@end

@implementation CTCShopQualificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark override

- (void)initWithVar
{
    [super initWithVar];
    
    [self.baseList addObject:@"营业执照"];
    [self.baseList addObject:@"餐厅经营许可证/卫生许可证"];
    [self.baseList addObject:@"健康证(1)"];
    [self.baseList addObject:@"健康证(2)"];
    
    
    /*if ([_licenseEntity.certificates count] == 0)
    {
        _licenseEntity.certificates = [NSMutableArray array];
        
        // 营业执照
        CTCShopCertificateDataEntity *ent = [CTCShopCertificateDataEntity new];
        [_licenseEntity.certificates addObject:ent];
        
        // 餐厅经营许可证/卫生许可证
        ent = [CTCShopCertificateDataEntity new];
        [_licenseEntity.certificates addObject:ent];
        
        // 健康证(1)
        ent = [CTCShopCertificateDataEntity new];
        [_licenseEntity.certificates addObject:ent];
        
        // 健康证(2)
        ent = [CTCShopCertificateDataEntity new];
        [_licenseEntity.certificates addObject:ent];
    }
    */
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = _shopId;
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    [self initWithShowImageObject];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐厅资质";
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    AppDelegate *app = [UtilityObject appDelegate];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - [app tabBarHeight] - STATUSBAR_HEIGHT);
    self.baseTableView.frame = frame;
    self.baseTableView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    [self initWithBottomView];
}

- (void)clickedBack:(id)sender
{
    
    NSArray *viewContrller = self.navigationController.viewControllers;
    MyRestaurantListViewController *shopListVC = nil;
    for (id vc in viewContrller)
    {
        if ([vc isKindOfClass:[MyRestaurantListViewController class]])
        {
            shopListVC = vc;
            break;
        }
    }
    if (shopListVC)
    {// 有餐厅列表
        shopListVC.comeType = 0;
        [self.navigationController popToViewController:shopListVC animated:YES];
        return;
    }
    
    [MCYPushViewController showWithOpenRestaurantListVC:self data:@(2) completion:^(id data) {
    }];
    
    
//    if (_licenseEntity.state == 4)
//    {
//        [super clickedBack:sender];
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"请先进行资质审核"];
        // 餐厅列表(2表示从资质审核中进去的)
//        [MCYPushViewController showWithOpenRestaurantListVC:self data:@(2) completion:^(id data) {
////            ShopListDataEntity *shopEnt = data;
//            
//        }];
//    }
}

- (void)initWithHeaderView
{
    if (!_headerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCShopQualificationHeaderViewHeight);
        _headerView = [[CTCShopQualificationHeaderView alloc] initWithFrame:frame];
        self.baseTableView.tableHeaderView = _headerView;
    }
    
    [_headerView updateViewData:_licenseEntity];
    
}

- (void)initWithFooterView
{
    if (!_footerView)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kCTCShopQualificationFooterViewHeight);
        _footerView = [[CTCShopQualificationFooterView alloc] initWithFrame:frame];
        self.baseTableView.tableFooterView = _footerView;
    }
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {
        [weakSelf showWithInstanceRefView:YES];
    };
}

- (void)initWithBottomView
{
    if (!_bottomView)
    {
        AppDelegate * app = [UtilityObject appDelegate];
        CGRect frame = CGRectMake(0, [[UIScreen mainScreen] screenHeight] - [app navBarHeight] - STATUSBAR_HEIGHT - [app tabBarHeight], [[UIScreen mainScreen] screenWidth], [app tabBarHeight]);
        _bottomView = [[OpenRestaurantBottomView alloc] initWithFrame:frame];
        [_bottomView topLineWithHidden:YES];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"#feac00"];
        [self.view addSubview:_bottomView];
        [_bottomView updateViewData:@"提交"];
    }
    
    if (_licenseEntity.state == 2)
    {
        [_bottomView updateViewData:@"审核中"];
    }
    
    __weak typeof(self)weakSelf = self;
    _bottomView.viewCommonBlock = ^(id data)
    {
        if ([data isEqualToString:@"提交"])
        {
            [weakSelf touchWithSubmit];
        }
    };
}

- (void)initWithShowImageObject
{
    __weak typeof(self)weakSelf = self;
    _showImageObject = [[TYZShowImageInfoObject alloc] init];
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenWidth]);
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
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
    /*   图片类型id
     (
     EN_UPLOAD_IMAGE_CHEF_HEADER = 3000, ///< 厨师头像 1张
     EN_UPLOAD_IMAGE_BUSINESS_LICENSE = 4000, ///< 餐厅营业执照 1张
     EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE, ///< 餐厅经营许可证 1张
     EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE, ///< 餐厅消防安全证 1张
     EN_UPLOAD_IMAGE_HYGIENE_LICENSE,  ///< 餐厅卫生许可证 1张
     EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE, ///< 餐厅从业人员健康证1
     EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO, ///< 餐厅从业人员健康证2
     )*/
    debugLog(@"row=%d", (int)_indexPath.row);
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_BUSINESS_LICENSE)
    {// 营业执照
        CTCShopCertificateDataEntity *ent = _licenseEntity.certificates[_indexPath.row];
        ent.name = urlPath;
        debugLog(@"营业执照");
        debugLog(@"urlPath=%@", urlPath);
        debugLog(@"ent.name=%@", ent.name);
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE)
    {// 餐厅经营许可证/卫生许可证
        CTCShopCertificateDataEntity *ent = _licenseEntity.certificates[_indexPath.row];
        ent.name = urlPath;
        debugLog(@"餐厅经营许可证/卫生许可证");
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE)
    {// 餐厅从业人员健康证1
        CTCShopCertificateDataEntity *ent = _licenseEntity.certificates[_indexPath.row];
        ent.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO)
    {// 餐厅从业人员健康证2
        CTCShopCertificateDataEntity *ent = _licenseEntity.certificates[_indexPath.row];
        ent.name = urlPath;
    }
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    
}


/// 提交
- (void)touchWithSubmit
{
    // 营业执照 The business license
    CTCShopCertificateDataEntity *busLicenseEnt = [_licenseEntity.certificates objectOrNilAtIndex:0];
    debugLog(@"营业执照=%@", busLicenseEnt.name);
    if (!busLicenseEnt)
    {
        debugLog(@"is nil");
    }
    
    // 卫生许可证
     CTCShopCertificateDataEntity *healthEnt = [_licenseEntity.certificates objectOrNilAtIndex:1];
    
    if ([objectNull(busLicenseEnt.name) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请上传营业执照"];
        return;
    }
    
    if ([objectNull(healthEnt.name) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"餐厅经营许可证/卫生许可证"];
        return;
    }
    
    [HCSNetHttp requestWithShopSaveCertificate:_shopId userId:[UserLoginStateObject getUserId] completion:^(TYZRespondDataEntity *result) {
        if (result.errcode == respond_success)
        {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [_bottomView updateViewData:@"审核中"];
        }
        else
        {
            [UtilityObject svProgressHUDError:result viewContrller:self];
        }
    }];
}

- (void)showWithInstanceRefView:(BOOL)show
{
    __weak typeof(self)blockSelf = self;
    if (!_instanceRefView)
    {
        _instanceRefView = [[CTCShopInstanceReferenceBgView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight])];
        _instanceRefView.alpha = 0;
    }
    _instanceRefView.touchWithHiddenBlock = ^()
    {
        [blockSelf showWithInstanceRefView:NO];
    };
    
    
    if (show)
    {
        [self.view.window addSubview:_instanceRefView];
        [UIView animateWithDuration:0.5 animations:^{
            _instanceRefView.alpha = 1.0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _instanceRefView.alpha = 0;
        } completion:^(BOOL finished) {
            [_instanceRefView removeFromSuperview];
        }];
    }
}

- (CTCShopCertificateDataEntity *)getWithCertType:(NSInteger)type
{
    CTCShopCertificateDataEntity *ent = nil;
    for (CTCShopCertificateDataEntity *certEnt in _licenseEntity.certificates)
    {
        if (certEnt.type == type)
        {
            ent = certEnt;
            break;
        }
    }
    return ent;
}

- (void)touchWithUploadImage:(id)data indexPath:(NSIndexPath *)indexPath
{
//    debugMethod();
    
    if (_licenseEntity.state == 2)
    {
        [SVProgressHUD showInfoWithStatus:@"审核中，不允许修改信息。"];
        return;
    }
    
    
    self.indexPath = indexPath;
    
    if (indexPath.row == EN_SHOPQ_BUSLICENSE_ROW)
    {// 营业执照
        CTCShopCertificateDataEntity *ent = [self getWithCertType:EN_UPLOAD_IMAGE_BUSINESS_LICENSE];
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
        _uploadFileInputEntity.imageId = ent.id;
    }
    else if (indexPath.row == EN_SHOPQ_BUSHYGLICENSE_ROW)
    {// 餐厅经营许可证\卫生许可证
        CTCShopCertificateDataEntity *ent = [self getWithCertType:EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE];
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
        _uploadFileInputEntity.imageId = ent.id;
    }
    else if (indexPath.row == EN_SHOPQ_HEALTHCERONE_ROW)
    {// 健康证1
        CTCShopCertificateDataEntity *ent = [self getWithCertType:EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE];
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
        _uploadFileInputEntity.imageId = ent.id;
    }
    else if (indexPath.row == EN_SHOPQ_HEALTHCERTWO_ROW)
    {// 健康证2
        CTCShopCertificateDataEntity *ent = [self getWithCertType:EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO];
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
        _uploadFileInputEntity.imageId = ent.id;
    }
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
    _showImageObject.extName = @"jpg";
//    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertImgViewHeight]);
    [_showImageObject showActionSheet:self];
    
    
}

#pragma mark -
#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return EN_SHOPQ_MAX_ROW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    CTCShopCertificateDataEntity *certEnt = [_licenseEntity.certificates objectOrNilAtIndex:indexPath.row];
    CTCShopQualificationViewCell *cell = [CTCShopQualificationViewCell cellForTableView:tableView];
    [cell updateCellData:certEnt title:self.baseList[indexPath.row]];
    cell.baseTableViewCellBlock = ^(id data)
    {// 点击图片
        [weakSelf touchWithUploadImage:data indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CTCShopQualificationViewCell getWithCellHeight];
}

/*
 RestaurantDetailDataEntity *detailEnt = cellEntity;
 [_buslicView updateWithTitle:@"营业执照" imageEntity:detailEnt.busLicImageEntity];
 
 [_hyglicView updateWithTitle:@"经营许可证或卫生许可证" imageEntity:detailEnt.busCertImageEntity];
 
 //    [_fireQualifiedView updateWithTitle:@"消防检查合格意见书"imageEntity:detailEnt.fireSafeImageEntity];
 
 [_healthCertOneView updateWithTitle:@"健康证（1）" imageEntity:detailEnt.HealthCertOneImageEntity];
 
 [_healthCertTwoView updateWithTitle:@"健康证（2）" imageEntity:detailEnt.HealthCertTwoImageEntity];
 */

@end














