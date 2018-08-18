//
//  OpenRestaurantInfoViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "OpenRestaurantInfoViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "RestaurantInfoHeaderView.h" // 头视图信息
#import "RestaurantImageViewCell.h"
#import "ORestCommonMultsCell.h"
#import "ORestCommonSingleCell.h"
#import "ORestCookInfoViewCell.h" // 厨师信息cell
#import "ORestQualifCertViewCell.h" // 资质认证
//#import "UploadImageObject.h" // 上传图片
#import "TYZShowImageInfoObject.h" // 上传图片
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "RestaurantImageView.h" // 餐厅形象图片
#import "MallListDataEntity.h" // 商圈
#import "UserLoginStateObject.h"
#import "ORestQualifCertView.h"
#import "MyRestaurantListViewController.h" // 餐厅列表视图控制器

@interface OpenRestaurantInfoViewController ()
{
    CGFloat _titleWidth;
}

@property (nonatomic, strong) NSIndexPath *indexPath;

//@property (nonatomic, strong) UploadImageObject *uploadImgObject;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;


/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

@property (nonatomic, strong) TYZShowImageInfoObject *showImageObject;

//- (void)initWithUploadImgObject;

- (void)initWithShowImageObject;

@end

@implementation OpenRestaurantInfoViewController

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
    
    NSString *str = @"第三方支付";
    _titleWidth = [str widthForFont:FONTSIZE_12 height:20];
    
//    [self initWithUploadImgObject];
    
    [self initWithShowImageObject];
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = _inputEntity.shopId;
//    RestaurantImageView *imgView1 = [[RestaurantImageView alloc] initWithFrame:CGRectZero];
//    RestaurantImageView *imgView2 = [[RestaurantImageView alloc] initWithImage:nil];
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐厅信息";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [self doRefreshData];
}

- (void)clickedBack:(id)sender
{
    if (_inputEntity.comeType == 1)
    {
        AppDelegate *app = [UtilityObject appDelegate];
        [app loadRootVC];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super clickedBack:sender];
        });
    }
    else if (_inputEntity.comeType == 3)
    {// 从餐厅列表中创建的
        MyRestaurantListViewController *shopListVC = nil;
        for (id vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass:[MyRestaurantListViewController class]])
            {
                shopListVC = vc;
                break;
            }
        }
        if (shopListVC)
        {
            [shopListVC doRefreshData];
            [self.navigationController popToViewController:shopListVC animated:YES];
        }
    }
    else
    {
        if (self.popResultBlock)
        {
            self.popResultBlock(_detailEntity);
        }
        [super clickedBack:sender];
    }
}

- (void)doRefreshData
{
    [super doRefreshData];
    
    [self getRestaurantDetailData];
}

/*- (void)initWithUploadImgObject
{
    __weak typeof(self)weakSelf = self;
    _uploadImgObject = [[UploadImageObject alloc] init];
    _uploadImgObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenWidth]);
    _uploadImgObject.imgType = 1;
    _uploadImgObject.extName = @"jpg";
    _uploadImgObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {// 保存图片
        [weakSelf uploadImageToServer:data imageName:imgName];
    };
}*/

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


/**
 *  得到餐厅详情信息
 */
- (void)getRestaurantDetailData
{
    // 餐厅id
    NSInteger shopId = _inputEntity.shopId;
    [HCSNetHttp requestWithShopShow:shopId completion:^(id result) {
        [self getRestaurantDetailData:result];
    }];
}

- (void)getRestaurantDetailData:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        self.detailEntity = respond.data;
//        _detailEntity.details.slogan
        _detailEntity.details.sloganHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.slogan) font:FONTSIZE(15) maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        _detailEntity.details.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.intro) font:FONTSIZE(15) maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
        // 厨师简介 FONTSIZE_12
        _detailEntity.topchef.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.topchef.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
//        debugLog(@"deai=%@", [_detailEntity modelToJSONString]);
        [self.baseTableView reloadData];
        [SVProgressHUD dismiss];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
    [self endAllRefreshing];
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
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_CHEF_HEADER)
    {// 总厨头像
        debugLog(@"厨师头像=%@", urlPath);
        debugLog(@"section=%d; row=%d", (int)_indexPath.section, (int)_indexPath.row);
        _detailEntity.topchef.image = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_BUSINESS_LICENSE)
    {// 营业执照
        _detailEntity.busLicImageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE)
    {// 餐厅经营许可证
        _detailEntity.busCertImageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE)
    {// 餐厅消防安全证
        _detailEntity.fireSafeImageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_HYGIENE_LICENSE)
    {// 餐厅卫生许可证
        
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE)
    {// 餐厅从业人员健康证1
        _detailEntity.HealthCertOneImageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO)
    {// 餐厅从业人员健康证2
        _detailEntity.HealthCertTwoImageEntity.name = urlPath;
    }
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}

/**
 *  添加餐厅图片
 *
 *  @param data
 */
/*- (void)addRestaurantImage:(id)data
{
    if ([_detailEntity.images count] >= 9)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您最多只能上传9张图片！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    _uploadFileInputEntity.imageType = 1000;
    [self.uploadImgObject showActionSheet:self];
}*/

/**
 *  长按餐厅形象图片
 *
 *  @param data data
 */
- (void)longPressGesture:(id)data
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为首页", @"删除", nil];
    [sheet showInView:self.view];
}

// 修改厨师信息
- (void)chefWithInfo:(id)data
{
    NSInteger tag = [data integerValue];
    debugLog(@"tag=%d", (int)tag);
    if (tag == 100)
    {// 姓名
        NSDictionary *param = @{@"title":@"主厨姓名", @"data":objectNull(_detailEntity.topchef.name), @"placeholder":@"请输入姓名", @"isNumber":@(NO)};
        [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
            [self updateWithChefInfo:data tag:tag];
        }];
    }
    else if (tag == 101)
    {// 等级
        NSDictionary *param = @{@"title":@"主厨等级", @"data":objectNull(_detailEntity.topchef.title), @"placeholder":@"请输入等级", @"isNumber":@(NO)};
        [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
            [self updateWithChefInfo:data tag:tag];
        }];
    }
    else if (tag == 102)
    {// 介绍
        NSDictionary *param = @{@"title":@"主厨介绍", @"data":objectNull(_detailEntity.topchef.intro), @"placeholder":@"请输入主厨介绍", @"fontNum":@(0)};
        [MCYPushViewController showWithRestaurantIntroEditVC:self data:param completion:^(id data) {
            [self updateWithChefInfo:data tag:tag];
        }];
    }
    else if (tag == 103)
    {// 厨师头像
        _showImageObject.extName = @"png";
        _uploadFileInputEntity.imageId = _detailEntity.topchef.image_id;
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_CHEF_HEADER;
        _showImageObject.imgSize = CGSizeMake(140,140);
        _showImageObject.imgType = EN_IMAGE_SQUARE_ACTION;
        [_showImageObject showActionSheet:self];
    }
}

// 资质认证
- (void)qualifCertImage:(id)data
{
    NSInteger tag = [data integerValue];
    debugLog(@"%s--tag=%d", __func__, (int)tag);
    if (tag == 100)
    {// 营业执照
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_BUSINESS_LICENSE;
        _uploadFileInputEntity.imageId = _detailEntity.busLicImageEntity.id;
    }
    else if (tag == 101)
    {// 餐厅经营许可证
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_BUSINESS_CERTIFICATE;
        _uploadFileInputEntity.imageId = _detailEntity.busCertImageEntity.id;
    }
    else if (tag == 102)
    {// 消防检查合格意见书
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_FIRESAFETY_CERTIFICATE;
        _uploadFileInputEntity.imageId = _detailEntity.fireSafeImageEntity.id;
    }
    else if (tag == 103)
    {// 健康证1
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_ONE;
        _uploadFileInputEntity.imageId = _detailEntity.HealthCertOneImageEntity.id;
    }
    else if (tag == 104)
    {// 健康证2
        _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_HEALTH_CERTIFICATE_TWO;
        _uploadFileInputEntity.imageId = _detailEntity.HealthCertTwoImageEntity.id;
    }
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
    _showImageObject.extName = @"jpg";
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth], [ORestQualifCertView getQualifCertImgViewHeight]);
    [_showImageObject showActionSheet:self];
}

//修改基本信息
- (void)updateWithBaseData:(id)data
{
    switch (_indexPath.row)
    {
        case EN_OPRT_INFO_BD_NAME_ROW:
        {// 餐厅名字
            [SVProgressHUD showWithStatus:@"提交中"];
            [HCSNetHttp requestWithShopSetName:_inputEntity.shopId name:data completion:^(id result) {
                [self responseWithShopSetName:result shopName:data];
            }];
        } break;
        case EN_OPRT_INFO_BD_RECOMMENDWORD_ROW:
        {// 餐厅推荐词
            [SVProgressHUD showWithStatus:@"提交中"];
            [HCSNetHttp requestWithShopSetSlogan:_inputEntity.shopId slogan:data completion:^(id result) {
                [self responseWithShopSetSlogan:result slogan:data];
            }];
        } break;
        case EN_OPRT_INFO_BD_BUSC_ROW:
        {// 商圈
            MallListDataEntity *entity = data;
            _detailEntity.details.mall_id = entity.id;
            _detailEntity.details.mall_name = entity.name;
            [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        } break;
        case EN_OPRT_INFO_BD_ADDRESS_ROW:
        {// 地址
//            NSDictionary *param = @{@"address":address, @"lon":@(coordinate.longitude), @"lat":@(coordinate.latitude)};
            [SVProgressHUD showWithStatus:@"提交中"];
            debugLog(@"data=%@", [data modelToJSONString]);
            [HCSNetHttp requestWithShopSetAddress:_inputEntity.shopId lng:[data[@"lon"] doubleValue] lat:[data[@"lat"] doubleValue] address:data[@"address"] completion:^(id result) {
                [self responseWithShopSetAddress:result param:data];
            }];
        } break;
        case EN_OPRT_INFO_BD_MOBILE_ROW:
        {// 联系方式
            [SVProgressHUD showWithStatus:@"提交中"];
            [HCSNetHttp requestWithShopSetMobile:_inputEntity.shopId mobile:data completion:^(id result) {
                [self responseWithShopSetMobile:result mobile:data];
            }];
        } break;
        case EN_OPRT_INFO_BD_INTRO_ROW:
        {// 餐厅介绍
            debugLog(@"餐厅介绍");
            [SVProgressHUD showWithStatus:@"提交中"];
            [HCSNetHttp requestWithShopSetIntro:_inputEntity.shopId intro:data completion:^(id result) {
                [self responseWithShopSetIntro:result intro:data];
            }];
        } break;
        case EN_OPRT_INFO_BD_AVERAGE_ROW:
        {// 人均消费
//            debugLog(@"人均消费");
            [SVProgressHUD showWithStatus:@"提交中"];
            [HCSNetHttp requestWithShopSetAverage:_inputEntity.shopId average:[data integerValue] completion:^(id result) {
                [self responseWithShopSetAverage:result average:[data integerValue]];
            }];
        } break;
        default:
            break;
    }
}

// 修改厨师信息
- (void)updateWithChefInfo:(id)data tag:(NSInteger)tag
{
    if (tag == 100)
    {// 姓名
        [SVProgressHUD showWithStatus:@"提交中"];
        [HCSNetHttp requestWithShopSetShopChefName:_inputEntity.shopId name:data completion:^(id result) {
            [self responseWithShopSetShopChefName:result chefName:data];
        }];
    }
    else if (tag == 101)
    {// 等级
        debugLog(@"等级");
        [SVProgressHUD showWithStatus:@"提交中"];
        [HCSNetHttp requestWithShopSetShopChefTitle:_inputEntity.shopId title:data completion:^(id result) {
            [self responseWithShopSetShopChefTitle:result title:data];
        }];
    }
    else if (tag == 102)
    {// 介绍
        [SVProgressHUD showWithStatus:@"提交中"];
        [HCSNetHttp requestWithShopSetShopChefIntro:_inputEntity.shopId intro:data completion:^(id result) {
            [self responseWithShopSetShopChefIntro:result intro:data];
        }];
    }
}

// 更新支付方式
- (void)updateWithPayType:(PayInfoDataEntity *)payEntity
{
//    debugLog(@"pay=%@", [payEntity modelToJSONString]);
    [SVProgressHUD showWithStatus:@"提交中"];
    
    [HCSNetHttp requestWithShopSetPay:_inputEntity.shopId payType:payEntity.type payAccount:payEntity.account completion:^(id result) {
        [self responseWithShopSetPay:result payEntity:payEntity];
    }];
}

- (void)responseWithShopSetPay:(TYZRespondDataEntity *)respond payEntity:(PayInfoDataEntity *)payEntity
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.pay = payEntity;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [SVProgressHUD dismiss];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改主厨姓名，返回结果
- (void)responseWithShopSetShopChefName:(TYZRespondDataEntity *)respond chefName:(NSString *)chefName
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.topchef.name = chefName;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [SVProgressHUD dismiss];
    }
    else
    {
        [UtilityObject svProgressHUDError: respond viewContrller:self];
    }
}

// 修改职称
- (void)responseWithShopSetShopChefTitle:(TYZRespondDataEntity *)respond title:(NSString *)title
{
    debugLog(@"修改职称");
    if (respond.errcode == respond_success)
    {
        _detailEntity.topchef.title = title;
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [SVProgressHUD dismiss];
    }
    else
    {
        [UtilityObject svProgressHUDError: respond viewContrller:self];
    }
}

// 修改主厨简介，返回结果
- (void)responseWithShopSetShopChefIntro:(TYZRespondDataEntity *)respond intro:(NSString *)intro
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.topchef.intro = intro;
        _detailEntity.topchef.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.topchef.intro) font:FONTSIZE_12 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
        [SVProgressHUD dismiss];
    }
    else
    {
        [UtilityObject svProgressHUDError: respond viewContrller:self];
    }
}

- (UITableViewCell *)addBaseData:(NSIndexPath *)indexPath tableview:(UITableView *)tableview
{
    switch (indexPath.row)
    {
        case EN_OPRT_INFO_BD_NAME_ROW:
        {// 餐厅名字
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"店名" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.name) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            
            return cell;
        } break;
        case EN_OPRT_INFO_BD_RECOMMENDWORD_ROW:
        {// 餐厅推荐词
            ORestCommonMultsCell *cell = [ORestCommonMultsCell cellForTableView:tableview];
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"餐厅推荐词(20个文字以内)" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.slogan) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title value:value hiddenThanImgView:NO valueHeight:_detailEntity.details.sloganHeight];
            return cell;
        } break;
        case EN_OPRT_INFO_BD_BUSC_ROW:
        {// 商圈
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"商圈" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.mall_name) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        } break;
        case EN_OPRT_INFO_BD_ADDRESS_ROW:
        {// 地址
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"地址" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.address) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        } break;
        case EN_OPRT_INFO_BD_MOBILE_ROW:
        {// 联系方式
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"联系方式" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.mobile) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        } break;
        case EN_OPRT_INFO_BD_INTRO_ROW:
        {// 餐厅介绍
            ORestCommonMultsCell *cell = [ORestCommonMultsCell cellForTableView:tableview];
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"餐厅介绍" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#a1a1a1"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:objectNull(_detailEntity.details.intro) attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            
            [cell updateWithTitle:title value:value hiddenThanImgView:NO valueHeight:_detailEntity.details.introHeight];
            return cell;
        } break;
        case EN_OPRT_INFO_BD_AVERAGE_ROW:
        {// 人均消费
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableview];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"人均消费" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", (int)_detailEntity.details.average] attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        } break;
        default:
        {
            return nil;
        }  break;
    }
}

- (CGFloat)addBaseHeight:(NSIndexPath *)indexPath tableview:(UITableView *)tableview
{
    CGFloat height = kORestCommonSingleCellHeight;
    if (indexPath.row == EN_OPRT_INFO_BD_RECOMMENDWORD_ROW)
    {// 餐厅推荐词
        height = kORestCommonMultsCellMinHeight - 20 + _detailEntity.details.sloganHeight;
    }
    else if (indexPath.row == EN_OPRT_INFO_BD_INTRO_ROW)
    {// 餐厅介绍
        height = kORestCommonMultsCellMinHeight - 20 + _detailEntity.details.introHeight;
    }
    return height;
}

// 修改餐厅名称，返回结果
- (void)responseWithShopSetName:(TYZRespondDataEntity *)respond shopName:(NSString *)shopName
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.name = shopName;
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改口号，返回结果
- (void)responseWithShopSetSlogan:(TYZRespondDataEntity *)respond slogan:(NSString *)slogan
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.slogan = slogan;
        _detailEntity.details.sloganHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.slogan) font:FONTSIZE(15) maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改餐厅地址，返回结果
- (void)responseWithShopSetAddress:(TYZRespondDataEntity *)respond param:(NSDictionary *)param
{
//    debugMethod();
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.address = param[@"address"];
        _detailEntity.details.lng = [param[@"lon"] doubleValue];
        _detailEntity.details.lat = [param[@"lat"] doubleValue];
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改联系方式，返回结果
- (void)responseWithShopSetMobile:(TYZRespondDataEntity *)respond mobile:(NSString *)mobile
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.mobile = mobile;
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改餐厅简介，返回结果
- (void)responseWithShopSetIntro:(TYZRespondDataEntity *)respond intro:(NSString *)intro
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.intro = intro;
        _detailEntity.details.introHeight = [UtilityObject mulFontHeights:objectNull(_detailEntity.details.intro) font:FONTSIZE(15) maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改餐厅人均消费，返回结果
- (void)responseWithShopSetAverage:(TYZRespondDataEntity *)respond average:(NSInteger)average
{
    if (respond.errcode == respond_success)
    {
        _detailEntity.details.average = average;
        [SVProgressHUD dismiss];
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

/**
 *  编辑餐厅图片，进入编辑餐厅图片视图控制器
 */
- (void)editWithRestaurantImageView:(UITapGestureRecognizer *)tap
{
    [MCYPushViewController showWithRestaurantEditMainImageVC:self data:_detailEntity completion:^(id data) {
        [self doRefreshData];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_OPRT_INFO_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    switch (section)
    {
        case EN_OPRT_INFO_RESTIMAGE_SECTION:
        {// 餐厅图片
            count = EN_OPRT_INFO_RESTIMAGE_MAX_ROW;
        } break;
        case EN_OPRT_INFO_BASEDATA_SECTION:
        {// 基本资料
            count = EN_OPRT_INFO_BASEDATA_MAX_ROW;
        } break;
        /*case EN_OPRT_INFO_ACCOUNT_SECTION:
        {// 支付账号设置
            count = EN_OPRT_INFO_ACCOUNT_MAX_ROW;
        } break;*/
        case EN_OPRT_INFO_COOKINFO_SECTION:
        {
            count = EN_OPRT_INFO_COOKINFO_MAX_ROW;
        } break;
        case EN_OPRT_INFO_QUACERT_SECTION:
        {// 资质认证
            count = EN_OPRT_INFO_QUACERT_MAX_ROW;
        } break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if ([indexPath section] == EN_OPRT_INFO_RESTIMAGE_SECTION)
    {// 图片
        RestaurantImageViewCell *cell = [RestaurantImageViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_detailEntity];
        cell.restaurantAddImageBlock = ^(id data)
        {// 添加图片
//            [weakSelf addRestaurantImage:data];
        };
        cell.baseTableViewCellBlock = ^(id data)
        {// 长按
            [weakSelf longPressGesture:data];
        };
        return cell;
    }
    else if ([indexPath section] == EN_OPRT_INFO_BASEDATA_SECTION)
    {// 基本资料
        return [self addBaseData:indexPath tableview:tableView];
    }
    /*else if ([indexPath section] == EN_OPRT_INFO_ACCOUNT_SECTION)
    {// 支付账号设置
        ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
        UIColor *color = [UIColor colorWithHexString:@"#646464"];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"第三方支付" attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
        color = [UIColor colorWithHexString:@"#323232"];
        NSString *str = objectNull(_detailEntity.pay.account);
        if ([str isEqualToString:@""])
        {
            str = @"请选择提现账号";
        }
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
        [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
        return cell;

    }*/
    else if ([indexPath section] == EN_OPRT_INFO_COOKINFO_SECTION)
    {// 厨师信息
        ORestCookInfoViewCell *cell = [ORestCookInfoViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_detailEntity.topchef];
        cell.baseTableViewCellBlock = ^(id data)
        {
            weakSelf.indexPath = indexPath;
            [weakSelf chefWithInfo:data];
        };
        return cell;
    }
    else if ([indexPath section] == EN_OPRT_INFO_QUACERT_SECTION)
    {// 资质认证
        ORestQualifCertViewCell *cell = [ORestQualifCertViewCell cellForTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateCellData:_detailEntity];
        /*cell.baseTableViewCellBlock = ^(id data)
        {// 资质认证
            weakSelf.indexPath = indexPath;
            [weakSelf qualifCertImage:data];
        };*/
        return cell;
    }
    // ORestCookInfoViewCell
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60.0;
    if (indexPath.section == EN_OPRT_INFO_RESTIMAGE_SECTION)
    {// 餐厅图片
        NSInteger count = 6;//[_detailEntity.images count];
//        if (count < 9)
//        {
//            count = count + 1;
//        }
        height = [RestaurantImageViewCell getRestaurantImgCellMinHeight:count];
    }
    else if (indexPath.section == EN_OPRT_INFO_BASEDATA_SECTION)
    {// 基本资料
        height = [self addBaseHeight:indexPath tableview:tableView];
    }
    /*else if ([indexPath section] == EN_OPRT_INFO_ACCOUNT_SECTION)
    {// 账号设置
        height = kORestCommonSingleCellHeight;
    }*/
    else if ([indexPath section] == EN_OPRT_INFO_COOKINFO_SECTION)
    {// 厨师信息
        height = [ORestCookInfoViewCell getCookInfoViewCellHeight] - 20 + _detailEntity.topchef.introHeight;
    }
    else if ([indexPath section] == EN_OPRT_INFO_QUACERT_SECTION)
    {// 资质认证
        return [ORestQualifCertViewCell getQualifCertViewCellHeight];
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RestaurantInfoHeaderView *view = [[RestaurantInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kRestaurantInfoHeaderViewHeight)];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    BOOL isHidden = YES;
    switch (section)
    {
        case EN_OPRT_INFO_RESTIMAGE_SECTION:
        {// 餐厅图片
            NSString *str = @"餐厅组图";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            str = @"（限6张）";
            color = [UIColor colorWithHexString:@"#999999"];
            butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(11), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            isHidden = NO;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editWithRestaurantImageView:)];
            [view addGestureRecognizer:tap];
            
        } break;
        case EN_OPRT_INFO_BASEDATA_SECTION:
        {// 基本资料
            NSString *str = @"基本资料";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        /*case EN_OPRT_INFO_ACCOUNT_SECTION:
        {// 支付账号设置
            NSString *str = @"账号设置";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;*/
        case EN_OPRT_INFO_COOKINFO_SECTION:
        {// 总厨信息
            NSString *str = @"总厨信息";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        case EN_OPRT_INFO_QUACERT_SECTION:
        {// 资质认证
            NSString *str = @"资质认证";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        default:
            break;
    }
    [view updateViewData:mas hiddenThan:isHidden];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kRestaurantInfoHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
//    debugLog(@"section=%d; row=%d", (int)indexPath.section, (int)indexPath.row);
    if (indexPath.section == EN_OPRT_INFO_BASEDATA_SECTION)
    {// 基本资料
        switch (indexPath.row)
        {
            case EN_OPRT_INFO_BD_NAME_ROW:
            {// 餐厅名字
                NSDictionary *param = @{@"title":@"店名", @"data":objectNull(_detailEntity.details.name), @"placeholder":@"请输入店名", @"isNumber":@(NO)};
                [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            } break;
            case EN_OPRT_INFO_BD_RECOMMENDWORD_ROW:
            {// 餐厅推荐词
                NSDictionary *param = @{@"title":@"餐厅推荐词", @"data":objectNull(_detailEntity.details.slogan), @"placeholder":@"请输入餐厅推荐词", @"fontNum":@(20)};
                [MCYPushViewController showWithRestaurantIntroEditVC:self data:param completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            } break;
            case EN_OPRT_INFO_BD_BUSC_ROW:
            {// 商圈
                [MCYPushViewController showWithRestaurantMallEditVC:self data:@(_detailEntity.details.city_id) completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            } break;
            case EN_OPRT_INFO_BD_ADDRESS_ROW:
            {// 地址
                [MCYPushViewController showWithRestaurantAddressEditVC:self data:_detailEntity.details.city_name completion:^(NSString *name, NSString *address, CLLocationCoordinate2D coordinate) {
                    NSDictionary *param = @{@"address":address, @"lon":@(coordinate.longitude), @"lat":@(coordinate.latitude)};
                    [self updateWithBaseData:param];
                }];
            } break;
            case EN_OPRT_INFO_BD_MOBILE_ROW:
            {// 联系方式
                NSDictionary *param = @{@"title":@"联系方式", @"data":objectNull(_detailEntity.details.mobile), @"placeholder":@"请输入联系方式", @"isNumber":@(YES)};
                [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            } break;
            case EN_OPRT_INFO_BD_INTRO_ROW:
            {// 餐厅介绍
                NSDictionary *param = @{@"title":@"餐厅介绍", @"data":objectNull(_detailEntity.details.intro), @"placeholder":@"请输入餐厅介绍", @"fontNum":@(0)};
                [MCYPushViewController showWithRestaurantIntroEditVC:self data:param completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            } break;
            case EN_OPRT_INFO_BD_AVERAGE_ROW:
            {// 人均消费
                NSString *str = [NSString stringWithFormat:@"%d", (int)_detailEntity.details.average];
                NSDictionary *param = @{@"title":@"人均消费", @"data":str, @"placeholder":@"请输入人均消费", @"isNumber":@(YES)};
                [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                    [self updateWithBaseData:data];
                }];
            }
            default:
                break;
        }
    }
    /*else if (indexPath.section == EN_OPRT_INFO_ACCOUNT_SECTION)
    {// 支付方式
        if (indexPath.row == EN_OPRT_INFO_THIRD_ACCOUNT_ROW)
        {// 支付方式
            [MCYPushViewController showWithPartPayChoiceVC:self data:_detailEntity.pay completion:^(id data) {
                [self updateWithPayType:data];
            }];
        }
    }*/
    
}

@end

























