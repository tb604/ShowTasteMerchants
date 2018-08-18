//
//  RestaurantAddFoodViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantAddFoodViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "ORestCommonSingleCell.h"
#import "ORestCommonMultsCell.h"
#import "ShopFoodInputEntity.h" // 添加菜品的传入参数
#import "ShopFoodDataEntity.h" // 菜品数据
#import "ShopFoodCategoryDataEntity.h"
#import "ResaurantAddFoodImageViewCell.h"
#import "TYZShowImageInfoObject.h" // 显示，选择相册还是相机视图
//#import "UploadImageObject.h" // 上传图片
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "UserLoginStateObject.h"
#import "ShopMouthDataEntity.h"
#import "AddFoodFooterView.h"
#import "ResaurantFoodRelatedImageViewCell.h"


@interface RestaurantAddFoodViewController ()
{
    /**
     *  相关菜品图片的数量
     */
    NSInteger _relatedImageCount;
    
    CGFloat _titleWidth;
    
    AddFoodFooterView *_footerView;
}

/**
 *  添加菜品的传入参数
 */
@property (nonatomic, strong) ShopFoodInputEntity *foodInputEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) TYZShowImageInfoObject *showImageObject;

//@property (nonatomic, strong) UploadImageObject *uploadImgObject;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;


/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

//- (void)initWithUploadImgObject;

- (void)initWithShowImageObject;

- (void)initWithFooterView;

@end

@implementation RestaurantAddFoodViewController

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
    
    debugLog(@"food=%@", [_foodEntity modelToJSONString]);
    
//    [self initWithUploadImgObject];
    
    [self initWithShowImageObject];
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    
    
    NSString *str = @"活动价格";
    _titleWidth = [str widthForFont:FONTSIZE_13];
    
    _foodInputEntity = [ShopFoodInputEntity new];
    _foodInputEntity.shopId = _uploadFileInputEntity.shopId;
    
    if (!_foodEntity)
    {
        _foodEntity = [ShopFoodDataEntity new];
        _foodEntity.introHeight = 20;
    }
    else
    {
        _foodEntity.introHeight = [UtilityObject mulFontHeights:objectNull(_foodEntity.intro) font:FONTSIZE_15 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
        
        _foodInputEntity.foodId = _foodEntity.id;
        _foodInputEntity.categoryId = _foodEntity.category_id;
        _foodInputEntity.printerId = _foodEntity.printer_id;
        _foodInputEntity.name = _foodEntity.name;
        _foodInputEntity.mode = _foodEntity.mode;
        _foodInputEntity.taste = _foodEntity.taste;
        _foodInputEntity.intro = _foodEntity.intro;
        _foodInputEntity.price = _foodEntity.price;
        _foodInputEntity.activityPrice = _foodEntity.activity_price;
        _foodInputEntity.unit = _foodEntity.unit;
        _foodInputEntity.image = _foodEntity.image;
        _foodInputEntity.remark = _foodEntity.remark;
        
    }
    
    if (!_foodEntity.content)
    {
        _foodEntity.content = [NSMutableArray array];
    }
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_type == 1)
    {
        self.title = @"添加菜品";
    }
    else
    {
        self.title = @"编辑菜品";
    }
    
    // 保存
    NSString *str = @"保存";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setTitle:str forState:UIControlStateNormal];
    btnSave.titleLabel.font = FONTSIZE_16;
    btnSave.frame = CGRectMake(0, 0, width, 30);
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveWithFood:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = itemSave;

}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self hiddenFooterView:YES];
    
    [self hiddenHeaderView:YES];
    
    [self initWithFooterView];
    
}

//- (void)clickedBack:(id)sender
//{
//    
//    
//    [super clickedBack:sender];
//}

- (void)initWithFooterView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kAddFoodFooterViewHeight);
    _footerView = [[AddFoodFooterView alloc] initWithFrame:frame];
    self.baseTableView.tableFooterView = _footerView;
    __weak typeof(self)weakSelf = self;
    _footerView.viewCommonBlock = ^(id data)
    {// 添加菜品相关图文
        [weakSelf addWithFoodRelate:data];
    };
}

// 添加图文介绍
- (void)addWithFoodRelate:(id)data_
{
    [MCYPushViewController showWithAddFoodRelatedInfoVC:self data:data_ completion:^(id data) {
        BOOL isAdd = YES;
        if (data_)
        {
            isAdd = NO;
        }
        [self addWithFoodRelatedResult:data isAdd:isAdd];
    }];
}

- (void)addWithFoodRelatedResult:(id)data isAdd:(BOOL)isAdd
{
    debugMethod();
    if (!data)
    {
        return;
    }
    ShopFoodImageEntity *imageEntity = data;
//    debugLog(@"ent=%@", [imageEntity modelToJSONString]);
    if (isAdd)
    {
        [_foodEntity.content addObject:imageEntity];
    }
    else
    {
        ShopFoodImageEntity *oldEntity = [_foodEntity.content objectOrNilAtIndex:_indexPath.row];
        oldEntity.image = imageEntity.image;
        oldEntity.desc = imageEntity.desc;
        oldEntity.descHeight = imageEntity.descHeight;
    }
    [self.baseTableView reloadData];
}

- (void)refreshWithCommonInfo:(id)data
{
    if (_indexPath.row == EN_RES_ADDFOOD_INFO_NAME_ROW)
    {// 菜名
        _foodInputEntity.name = data;
        _foodEntity.name = data;
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_CRAFT_ROW)
    {// 工艺
        _foodInputEntity.mode = data;
        _foodEntity.mode = data;
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_CASTE_ROW)
    {// 口味
        _foodInputEntity.taste = data;
        _foodEntity.taste = data;
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_INTRO_ROW)
    {// 介绍
        _foodInputEntity.intro = data;
        _foodEntity.intro = data;
        _foodEntity.introHeight = [UtilityObject mulFontHeights:objectNull(data) font:FONTSIZE(15) maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_PRICE_ROW)
    {// 价格(元/份)
//        NSDictionary *param = @{@"price":str, @"unit":unit};
        _foodInputEntity.price = [data[@"price"] floatValue];
        _foodEntity.price = [data[@"price"] floatValue];
        _foodInputEntity.unit = objectNull(data[@"unit"]);
        _foodEntity.unit = objectNull(data[@"unit"]);
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW)
    {// 活动价格(元/份)
        _foodInputEntity.activityPrice = [data[@"price"] floatValue];
        _foodEntity.activity_price = [data[@"price"] floatValue];
        _foodInputEntity.unit = objectNull(data[@"unit"]);
        _foodEntity.unit = objectNull(data[@"unit"]);
    }
    else if (_indexPath.row == EN_RES_ADDFOOD_INFO_IMAGE_ROW)
    {// 菜品图片，优惠活动
        _foodInputEntity.remark = data;
        _foodEntity.remark = data;
    }
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}

// 更新菜品类别
- (void)refreshWithCategory:(ShopFoodCategoryDataEntity *)categoryEnt
{
    _foodInputEntity.categoryId = categoryEnt.id;
    _foodEntity.category_id = categoryEnt.id;
    _foodEntity.category_name = categoryEnt.name;
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}

- (void)refreshWithShopPrinter:(ShopMouthDataEntity *)printEnt
{
    _foodInputEntity.printerId = printEnt.id;
    _foodEntity.printer_id = printEnt.id;
    _foodEntity.printer_name = printEnt.printer_name;
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}

// 点解上传图片
- (void)touchUploadFoodImage
{
    /*
     EN_IMAGE_SQUARE_ACTION, ///< 正方形
     EN_IMAGE_LANDSCAPE_ACTION,  ///< 扁的长方形(width>height)
     EN_IMAGE_PORTRAIT_ACTION
     */
    _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_FOOD_DETAIL;
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
    [_showImageObject showActionSheet:self];
}

/*- (void)initWithUploadImgObject
{
    __weak typeof(self)weakSelf = self;
    _uploadImgObject = [[UploadImageObject alloc] init];
    _uploadImgObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
    _uploadImgObject.imgType = 3;
    _uploadImgObject.extName = @"jpg";
    _uploadImgObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {// 保存图片
        UIImage *image = [UIImage imageWithData:data];
        debugLogSize(image.size);
//        [weakSelf uploadImageToServer:data imageName:imgName];
        weakSelf.foodEntity.imageData = image;
        [MCYPushViewController reloadWithTableView:weakSelf.baseTableView indexPath:weakSelf.indexPath reloadType:3];
    };
}*/

- (void)initWithShowImageObject
{
    __weak typeof(self)weakSelf = self;
    _showImageObject = [[TYZShowImageInfoObject alloc] init];
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
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
 *  保存菜品信息
 *
 *  @param sender sender
 */
- (void)saveWithFood:(id)sender
{
    if ([objectNull(_foodInputEntity.name) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写菜名！"];
        return;
    }
    if (_foodInputEntity.categoryId == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择类别！"];
        return;
    }
//    if (_foodInputEntity.printerId == 0)
//    {
//        [SVProgressHUD showErrorWithStatus:@"请选择档口！"];
//        return;
//    }
//    if ([objectNull(_foodInputEntity.mode) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请填写菜品工艺！"];
//        return;
//    }
//    if ([objectNull(_foodInputEntity.taste) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请填写菜品口味！"];
//        return;
//    }
//    if ([objectNull(_foodInputEntity.intro) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请填写菜品介绍！"];
//        return;
//    }
    if (_foodInputEntity.price == 0.0)
    {
        [SVProgressHUD showErrorWithStatus:@"请填写价格！"];
        return;
    }
//    if (_foodInputEntity.activityPrice == 0.0)
//    {
//        [SVProgressHUD showErrorWithStatus:@"请填写活动价格！"];
//        return;
//    }
    
    // http://test-img.xiuwei.chinatopchef.com/xw-test/food/10/05549148-29dc-e005-55c8-61399da6698e.jpg
    
    if ([objectNull(_foodInputEntity.image) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请上传菜品图片！"];
        return;
    }
    
    NSMutableArray *addList = [NSMutableArray new];
    for (ShopFoodImageEntity *imgEnt in _foodEntity.content)
    {
        /*
         "image": "abc1.png",
         "description": "使用了**食材"
         */
        NSDictionary *param = @{@"image":objectNull(imgEnt.image), @"description":objectNull(imgEnt.desc)};
        [addList addObject:param];
    }
    
    _foodInputEntity.content = [addList modelToJSONString];
    
    [SVProgressHUD showWithStatus:@"提交中"];
    if (_type == 1)
    {
        // 添加
        [HCSNetHttp requestWithFoodAdd:_foodInputEntity completion:^(id result) {
            [self responseWithFoodAdd:result];
        }];
    }
    else if (_type == 2)
    {
        // 修改
        [HCSNetHttp requestWithFoodSet:_foodInputEntity completion:^(id result) {
            [self responseWithFoodSet:result];
        }];
    }
}

// 增加菜品，到服务端，返回结果
- (void)responseWithFoodAdd:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        /*
         "data": {
         "food_id": 90
         }
         */
        _foodEntity.id = [respond.data[@"food_id"] integerValue];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        if (self.popResultBlock)
        {
            self.popResultBlock(_foodEntity);
        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.5];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

// 修改菜品，到服务端，返回结果
- (void)responseWithFoodSet:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD dismiss];
        
        if (self.popResultBlock)
        {
            self.popResultBlock(_foodEntity);
        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.5];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)uploadImageToServer:(NSData *)data imageName:(NSString *)imageName
{
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
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_FOOD_DETAIL)
    {
        _foodEntity.image = urlPath;
        _uploadFileInputEntity.imageUrl = urlPath;
        _foodInputEntity.image = urlPath;
    }
    [self performSelector:@selector(refreshWithImage) withObject:nil afterDelay:0.5];
    
}

- (void)refreshWithImage
{
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_RES_FOOD_INFO_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        count = EN_RES_ADDFOOD_INFO_MAX_ROW;
    }
    else if (section == EN_RES_FOOD_INFO_RELATED_SECTION)
    {
        count = [_foodEntity.content count];
    }
    return count;
}

/*
 EN_RES_ADDFOOD_INFO_NAME_ROW = 0, ///< 菜名
 EN_RES_ADDFOOD_INFO_CATEGORY_ROW, ///< 类别
 EN_RES_ADDFOOD_INFO_STALL_ROW, ///< 档口
 EN_RES_ADDFOOD_INFO_CRAFT_ROW, ///< 工艺
 EN_RES_ADDFOOD_INFO_CASTE_ROW, ///< 口味
 EN_RES_ADDFOOD_INFO_INTRO_ROW, ///< 介绍
 EN_RES_ADDFOOD_INFO_PRICE_ROW, ///< 价格(元/份)
 EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW, ///< 活动价格(元/份)
 EN_RES_ADDFOOD_INFO_IMAGE_ROW, ///< 菜品图片、优惠活动
 EN_RES_ADDFOOD_INFO_RELATED_IMAGE_ROW, ///< 相关菜品图片
 */

- (NSAttributedString *)getWithButed:(NSString *)value color:(UIColor *)color font:(UIFont *)font
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}];
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        if (indexPath.row == EN_RES_ADDFOOD_INFO_NAME_ROW)
        {// 菜名
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"菜名" color:[UIColor colorWithHexString:@"#646464"] font: FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.name);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请填写菜名";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            NSAttributedString *value = [self getWithButed:str color:color font: FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CATEGORY_ROW)
        {// 类别
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"类别" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.category_name);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请选择类别";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            NSAttributedString *value = [self getWithButed:str color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_STALL_ROW)
        {// 档口
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"档口" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.printer_name);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请选择档口";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            NSAttributedString *value = [self getWithButed:str color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CRAFT_ROW)
        {// 工艺
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"工艺" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.mode);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请填写菜品的工艺";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            NSAttributedString *value = [self getWithButed:str color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CASTE_ROW)
        {// 口味
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"口味" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.taste);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请填写菜品的口味";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            NSAttributedString *value = [self getWithButed:str color:color font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_INTRO_ROW)
        {// 介绍
            ORestCommonMultsCell *cell = [ORestCommonMultsCell cellForTableView:tableView];
            NSAttributedString *title = [self getWithButed:@"介绍" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = objectNull(_foodEntity.intro);
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            if ([str isEqualToString:@""])
            {
                str = @"请填写菜品介绍";
                color = [UIColor colorWithHexString:@"#cccccc"];
            }
            
            NSAttributedString *value = [self getWithButed:str color:color font:FONTSIZE(15)];
            debugLog(@"height=%.0f", _foodEntity.introHeight);
            [cell updateWithTitle:title value:value hiddenThanImgView:NO valueHeight:_foodEntity.introHeight];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_PRICE_ROW)
        {// 价格(元/份)
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSAttributedString *title = [self getWithButed:@"价格" color:[UIColor colorWithHexString:@"#646464"] font:FONTSIZE(13)];
            NSString *str = nil;
            if ([objectNull(_foodEntity.unit) isEqualToString:@""])
            {
                str = [NSString stringWithFormat:@"%.0f元", _foodEntity.price];
            }
            else
            {
                str = [NSString stringWithFormat:@"%.0f元/%@", _foodEntity.price, _foodEntity.unit];
            }
            NSAttributedString *value = [self getWithButed:str color:[UIColor colorWithHexString:@"#323232"] font:FONTSIZE(16)];
            [cell updateWithTitle:title titleWidth:_titleWidth value:value hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW)
        {// 活动价格(元/份)
            ORestCommonSingleCell *cell = [ORestCommonSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIColor *color = [UIColor colorWithHexString:@"#646464"];
            NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"活动价格" attributes:@{NSFontAttributeName: FONTSIZE(13), NSForegroundColorAttributeName: color}];
            
            color = [UIColor colorWithHexString:@"#ff5500"];
            NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
            NSString *str = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price];
            NSAttributedString *buted = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:buted];
            color = [UIColor colorWithHexString:@"#323232"];
            if ([objectNull(_foodEntity.unit) isEqualToString:@""])
            {
                str = @"元";
            }
            else
            {
                str = [NSString stringWithFormat:@"元/%@", _foodEntity.unit];
            }
            NSAttributedString *value = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(16), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:value];
            [cell updateWithTitle:title titleWidth:_titleWidth value:mas hiddenThanImgView:NO alignment:NSTextAlignmentCenter];
            return cell;
        }
        else if (indexPath.row == (EN_RES_ADDFOOD_INFO_IMAGE_ROW + _relatedImageCount))
        {// 菜品图片
            ResaurantAddFoodImageViewCell *cell = [ResaurantAddFoodImageViewCell cellForTableView:tableView];
            [cell updateCellData:_foodEntity];
            cell.baseTableViewCellBlock = ^(id data)
            {// 编辑优惠活动
                weakSelf.indexPath = indexPath;
                if ([data isEqualToString:@"请输入优惠活动"])
                {
                    data = nil;
                }
                NSDictionary *param = @{@"title":@"优惠活动", @"data":objectNull(data), @"placeholder":@"请输入菜品的优惠活动", @"isNumber":@(NO)};
                [MCYPushViewController showWithRestaurantSingleEditVC:weakSelf data:param completion:^(id data) {
                    [weakSelf refreshWithCommonInfo:data];
                }];
            };
            cell.touchUploadFoodImageBlock = ^()
            {// 点击上传图片
                weakSelf.indexPath = indexPath;
                [weakSelf touchUploadFoodImage];
            };
            return cell;
        }
    }
    else if (indexPath.section == EN_RES_FOOD_INFO_RELATED_SECTION)
    {
        ResaurantFoodRelatedImageViewCell *cell = [ResaurantFoodRelatedImageViewCell cellForTableView:tableView];
        [cell updateCellData:_foodEntity.content[indexPath.row]];
        return cell;
    }
    
    
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 46.0;
    if (indexPath.section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        if (indexPath.row == EN_RES_ADDFOOD_INFO_NAME_ROW)
        {// 菜名
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CATEGORY_ROW)
        {// 类别
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_STALL_ROW)
        {// 档口
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CRAFT_ROW)
        {// 工艺
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CASTE_ROW)
        {// 口味
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_INTRO_ROW)
        {// 介绍
            height = kORestCommonMultsCellMinHeight - 20 + _foodEntity.introHeight;
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_PRICE_ROW)
        {// 价格(元/份)
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW)
        {// 活动价格(元/份)
            
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_IMAGE_ROW)
        {// 菜品图片
            height = kResaurantAddFoodImageViewCellHeight;
        }
    }
    else if (indexPath.section == EN_RES_FOOD_INFO_RELATED_SECTION)
    {
        ShopFoodImageEntity *imageEnt = _foodEntity.content[indexPath.row];
        if ([objectNull(imageEnt.desc) isEqualToString:@""])
        {
            height = kResaurantFoodRelatedImageViewCellHeight;
        }
        else
        {
            height = kResaurantFoodRelatedImageViewCellHeight + imageEnt.descHeight + 10;
        }
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexPath = indexPath;
    
    if (indexPath.section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        if (indexPath.row == EN_RES_ADDFOOD_INFO_NAME_ROW)
        {// 菜名
            NSDictionary *param = @{@"title":@"菜名", @"data":objectNull(_foodEntity.name), @"placeholder":@"请输入菜名", @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CATEGORY_ROW)
        {// 类别
            [MCYPushViewController showWithChoiceFoodCategoryVC:self data:_menuList completion:^(id data) {
                [self refreshWithCategory:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_STALL_ROW)
        {// 档口
            [MCYPushViewController showWithChoicePrinterVC:self data:_mouthList completion:^(id data) {
                [self refreshWithShopPrinter:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CRAFT_ROW)
        {// 工艺
            NSDictionary *param = @{@"title":@"工艺", @"data":objectNull(_foodEntity.mode), @"placeholder":@"请输入菜品工艺", @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_CASTE_ROW)
        {// 口味
            NSDictionary *param = @{@"title":@"口味", @"data":objectNull(_foodEntity.taste), @"placeholder":@"请输入菜品口味", @"isNumber":@(NO)};
            [MCYPushViewController showWithRestaurantSingleEditVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_INTRO_ROW)
        {// 介绍
            // _foodEntity.intro
            NSString *intro = objectNull(_foodEntity.intro);
            NSDictionary *param = @{@"title":@"介绍", @"data":intro, @"placeholder":@"请输入介绍", @"fontNum":@(0)};
            [MCYPushViewController showWithRestaurantIntroEditVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_PRICE_ROW)
        {// 价格(元/份)
            NSString *str = [NSString stringWithFormat:@"%.0f", _foodEntity.price];
            NSDictionary *param = @{@"title":@"价格", @"data":str, @"unit":objectNull(_foodEntity.unit), @"placeholder":@"请输入价格"};
            [MCYPushViewController showWithAddFoodPriceVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
        else if (indexPath.row == EN_RES_ADDFOOD_INFO_ACTIVITY_PRICE_ROW)
        {// 活动价格(元/份)
            
            NSString *str = [NSString stringWithFormat:@"%.0f", _foodEntity.activity_price];
            NSDictionary *param = @{@"title":@"活动价格", @"data":str, @"unit":objectNull(_foodEntity.unit), @"placeholder":@"请输入活动价格"};
            [MCYPushViewController showWithAddFoodPriceVC:self data:param completion:^(id data) {
                [self refreshWithCommonInfo:data];
            }];
        }
//        else if (indexPath.row == (EN_RES_ADDFOOD_INFO_IMAGE_ROW + _relatedImageCount))
//        {// 菜品图片
//            
//        }
    }
    else
    {
        [self addWithFoodRelate:[_foodEntity.content objectOrNilAtIndex:indexPath.row]];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        return 0.01;
    }
    else
    {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == EN_RES_FOOD_INFO_RELATED_SECTION)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_13 labelTag:0 alignment:NSTextAlignmentLeft];
        title.text = @"相关菜品组图介绍";
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == EN_RES_FOOD_INFO_BASE_SECTION)
    {
        return 10;
    }
    else
    {
        return 0.01;
    }
}



@end
























