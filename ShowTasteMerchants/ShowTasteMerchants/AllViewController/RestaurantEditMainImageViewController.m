//
//  RestaurantEditMainImageViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/4.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantEditMainImageViewController.h"
#import "LocalCommon.h"
#import "TYZBaseTableViewCell.h"
#import "RestaurantEditMainImageHeaderView.h"
#import "RestaurantEditMainImageSingleCell.h"
#import "RestaurantEditMainImageMultsCell.h"
#import "RestaurantImageEntity.h"
#import "UploadImageObject.h" // 上传图片
#import "UploadFileInputObject.h"
#import "UploadImageServerObject.h"
#import "UserLoginStateObject.h"


@interface RestaurantEditMainImageViewController ()

@property (nonatomic, strong) RestaurantImageEntity *selectedEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UploadImageObject *uploadImgObject;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;


/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

- (void)initWithUploadImgObject;

@end

@implementation RestaurantEditMainImageViewController

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
    
    [self initWithUploadImgObject];
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = _detailEntity.details.shopId;
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"餐厅组图";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(_detailEntity);
    }
    [super clickedBack:sender];
}

- (void)initWithUploadImgObject
{
    __weak typeof(self)weakSelf = self;
    _uploadImgObject = [[UploadImageObject alloc] init];
    _uploadImgObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth] - 20, [RestaurantEditMainImageSingleCell getWithCellHeight] - 20);
    _uploadImgObject.imgType = 1;
    _uploadImgObject.extName = @"jpg";
    _uploadImgObject.dissPickerHeadImgDataBlock = ^(NSData *data, NSString *imgName)
    {// 保存图片
        [weakSelf uploadImageToServer:data imageName:imgName];
    };
}

- (void)uploadImageToServer:(NSData *)data imageName:(NSString *)imageName
{
    [SVProgressHUD showWithStatus:@"上传中"];
    _uploadFileInputEntity.data = data;
    _uploadFileInputEntity.extName = _uploadImgObject.extName;
    
//    debugLog(@"inputEnt=%@", [_uploadFileInputEntity modelToJSONString]);
    
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
     N_UPLOAD_IMAGE_SHOP_FIRST = 2000, ///< 餐厅首图 1张
     EN_UPLOAD_IMAGE_SHOP_HALL, ///< 餐厅大厅图 2张
     EN_UPLOAD_IMAGE_SHOP_ROOMS, ///< 餐厅包间图  2张
     EN_UPLOAD_IMAGE_SHOP_LANDSCAPE, ///< 餐厅景观图 1张
     )*/
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_SHOP_FIRST)
    {// 餐厅首图 1张
        _detailEntity.mainImageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_SHOP_HALL)
    {// 餐厅大厅图 2张
        NSInteger index = 0;
        if (_selectedEntity.tag == 101)
        {
            index = 1;
        }
        RestaurantImageEntity *imageEntity = [_detailEntity.hallImageList objectOrNilAtIndex:index];
        imageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_SHOP_ROOMS)
    {// 餐厅包间图  2张
        NSInteger index = 0;
        if (_selectedEntity.tag == 101)
        {
            index = 1;
        }
        RestaurantImageEntity *imageEntity = [_detailEntity.roomImageList objectOrNilAtIndex:index];
        imageEntity.name = urlPath;
    }
    else if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_SHOP_LANDSCAPE)
    {// 餐厅景观图 1张
        _detailEntity.landscapeImageEntity.name = urlPath;
    }
    [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:3];
}



- (void)touchImageView:(NSInteger)imageType indexPath:(NSIndexPath *)indexPath imageEntity:(RestaurantImageEntity *)imageEntity
{
//    debugLog(@"imagetype=%d", (int)imageType);
    self.indexPath = indexPath;
    self.selectedEntity = imageEntity;
//    debugLog(@"imageent=%@", [imageEntity modelToJSONString]);
    _uploadFileInputEntity.imageType = imageType;
    _uploadFileInputEntity.imageId = imageEntity.id;
    [_uploadImgObject showActionSheet:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EN_SHOP_IMAGE_MAX_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    switch (indexPath.section)
    {
        case EN_SHOP_IMAGE_IMAGE_SECTION:
        {// 形象照片1张
            RestaurantEditMainImageSingleCell *cell = [RestaurantEditMainImageSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:_detailEntity.mainImageEntity title:@"该图片将用于餐厅首图或搜索页"];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf touchImageView:EN_UPLOAD_IMAGE_SHOP_FIRST indexPath:indexPath imageEntity:data];
            };
            return cell;
        } break;
        case EN_SHOP_IMAGE_HALL_SECTION:
        {// 大堂照片2张
            RestaurantEditMainImageMultsCell *cell = [RestaurantEditMainImageMultsCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:_detailEntity.hallImageList titleOne:@"请上传大堂代表性图片(1)" titleTwo:@"请上传大堂代表性图片(2)"];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf touchImageView:EN_UPLOAD_IMAGE_SHOP_HALL indexPath:indexPath imageEntity:data];
            };
            return cell;
        } break;
        case EN_SHOP_IMAGE_ROOM_SECTION:
        {// 包间照片2张
            RestaurantEditMainImageMultsCell *cell = [RestaurantEditMainImageMultsCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:_detailEntity.roomImageList titleOne:@"请上传餐厅大包间图片" titleTwo:@"请上传餐厅小包间图片"];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf touchImageView:EN_UPLOAD_IMAGE_SHOP_ROOMS indexPath:indexPath imageEntity:data];
            };
            return cell;
        } break;
        case EN_SHOP_IMAGE_LANDSCAPE_SECTION:
        {// 餐厅景观照片一张
            RestaurantEditMainImageSingleCell *cell = [RestaurantEditMainImageSingleCell cellForTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell updateCellData:_detailEntity.landscapeImageEntity title:@"请上传一张餐厅代表性景观图片"];
            cell.baseTableViewCellBlock = ^(id data)
            {
                [weakSelf touchImageView:EN_UPLOAD_IMAGE_SHOP_LANDSCAPE indexPath:indexPath imageEntity:data];
            };
            return cell;
        } break;
            
        default:
            break;
    }
    TYZBaseTableViewCell *cell = [TYZBaseTableViewCell cellForTableView:tableView];
    
    // RestaurantEditMainImageSingleCell
    // RestaurantEditMainImageMultsCell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 80;
    switch (indexPath.section)
    {
        case EN_SHOP_IMAGE_IMAGE_SECTION:
        {// 形象照片
            height = [RestaurantEditMainImageSingleCell getWithCellHeight];
        } break;
        case EN_SHOP_IMAGE_HALL_SECTION:
        {// 大堂照片
            height = [RestaurantEditMainImageMultsCell getWithCellHeight];
        } break;
        case EN_SHOP_IMAGE_ROOM_SECTION:
        {// 包间照片
            height = [RestaurantEditMainImageMultsCell getWithCellHeight];
        } break;
        case EN_SHOP_IMAGE_LANDSCAPE_SECTION:
        {// 餐厅景观照片
            height = [RestaurantEditMainImageSingleCell getWithCellHeight];
        } break;
            
        default:
            break;
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kRestaurantEditMainImageHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RestaurantEditMainImageHeaderView *view = [[RestaurantEditMainImageHeaderView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], kRestaurantEditMainImageHeaderViewHeight)];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] init];
    switch (section)
    {
        case EN_SHOP_IMAGE_IMAGE_SECTION:
        {// 形象照片
            NSString *str = @"形象组图";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            str = @"（门头或者背景墙等）";
            color = [UIColor colorWithHexString:@"#999999"];
            butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        case EN_SHOP_IMAGE_HALL_SECTION:
        {// 大堂照片
            NSString *str = @"大堂照片";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            str = @"（限2张不同角度的照片）";
            color = [UIColor colorWithHexString:@"#999999"];
            butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        case EN_SHOP_IMAGE_ROOM_SECTION:
        {// 包间照片
            NSString *str = @"包间照片";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            str = @"（大包间、小包间各一张）";
            color = [UIColor colorWithHexString:@"#999999"];
            butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
        case EN_SHOP_IMAGE_LANDSCAPE_SECTION:
        {// 餐厅景观照片
            NSString *str = @"餐厅景观";
            UIColor *color = [UIColor colorWithHexString:@"#323232"];
            NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
            str = @"（限1张）";
            color = [UIColor colorWithHexString:@"#999999"];
            butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(12), NSForegroundColorAttributeName: color}];
            [mas appendAttributedString:butedStr];
        } break;
            
        default:
            break;
    }
    [view updateViewData:mas];
    return view;
}

/*
 NSString *str = @"餐厅组图";
 UIColor *color = [UIColor colorWithHexString:@"#323232"];
 NSAttributedString *butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
 [mas appendAttributedString:butedStr];
 str = @"（限6张）";
 color = [UIColor colorWithHexString:@"#999999"];
 butedStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: FONTSIZE(11), NSForegroundColorAttributeName: color}];
 [mas appendAttributedString:butedStr];
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
