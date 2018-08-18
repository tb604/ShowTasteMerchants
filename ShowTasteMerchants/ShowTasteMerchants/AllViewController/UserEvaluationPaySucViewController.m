//
//  UserEvaluationPaySucViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/22.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UserEvaluationPaySucViewController.h"
#import "LocalCommon.h"
#import "DinersOrderDetailBottomView.h"
#import "UserEvaluationServiceViewCell.h"
#import "ShopAddLabelViewCell.h"
#import "ShopEvaluationContentViewCell.h"
#import "CellCommonDataEntity.h"
#import "TYZShowImageInfoObject.h" // 显示，选择相册还是相机视图
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "CommentInputDataEntity.h" // 评论传入参数
#import "RestaurantImageEntity.h"
#import "OrderMealContentEntity.h"
#import "CommentClassifyEntity.h"

@interface UserEvaluationPaySucViewController ()
{
    
    DinersOrderDetailBottomView *_bottomView;
    
    CommentInputDataEntity *_commentInputEntity;
}

@property (nonatomic, strong) TYZShowImageInfoObject *showImageObject;

/**
 *  上传图片到服务器
 */
@property (nonatomic, strong) UploadImageServerObject *uploadImgServerObject;


/**
 *  上传图片的传入参数
 */
@property (nonatomic, strong) UploadFileInputObject *uploadFileInputEntity;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)initWithBottomView;

- (void)initWithShowImageObject;

@end

@implementation UserEvaluationPaySucViewController

- (void)initWithVar
{
    [super initWithVar];
    
    _commentInputEntity = [CommentInputDataEntity new];
    _commentInputEntity.userId = [UserLoginStateObject getUserId];
    _commentInputEntity.shopId = _orderDetailEnt.order.shop_id;
    _commentInputEntity.orderId = _orderDetailEnt.order.order_id;
    _commentInputEntity.images = [NSMutableArray array];
    _commentInputEntity.classList = [NSMutableArray array];
    _commentInputEntity.vote = 5;
    _commentInputEntity.score1 = 5;
    _commentInputEntity.score2 = 5;
    _commentInputEntity.score3 = 5;
    
//    debugLog(@"count=%d", [_boradTypeList count]);
    for (OrderMealContentEntity *mEnt in _boradTypeList)
    {
        CellCommonDataEntity *ent = [CellCommonDataEntity new];
        ent.tag = mEnt.cId;
        ent.title = mEnt.name;
        ent.isCheck = NO;
        [self.baseList addObject:ent];
    }
    
    /*CellCommonDataEntity *ent = [CellCommonDataEntity new];
    ent.tag = 1;
    ent.title = @"亲朋聚聚好去处";
    ent.isCheck = NO;
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.tag = 2;
    ent.title = @"商务活动好选择";
    ent.isCheck = NO;
    [self.baseList addObject:ent];
    
    ent = [CellCommonDataEntity new];
    ent.tag = 3;
    ent.title = @"情侣约会理想地";
    ent.isCheck = NO;
    [self.baseList addObject:ent];*/
    
    
    [self initWithShowImageObject];
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = _orderDetailEnt.order.shop_id;
    _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_ORDER_COMMEND;
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    self.title = @"评价";
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBottomView];
}

- (void)initWithBottomView
{
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - statusHeight - navBarHeight - TABBAR_HEIGHT);
    self.baseTableView.frame = frame;
    __weak typeof(self)blockSelf = self;
    if (!_bottomView)
    {
        _bottomView = [[DinersOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, frame.size.height, [[UIScreen mainScreen] screenWidth], TABBAR_HEIGHT)];
        [self.view addSubview:_bottomView];
    }
    _bottomView.bottomClickedBlock = ^(NSString *title, NSInteger tag)
    {
        [blockSelf bottomViewClicked:title tag:tag];
    };
    [_bottomView updateWithBottom:_orderDetailEnt buttonWidthType:1 buttonTitle:@"确定"];
}

- (void)bottomViewClicked:(NSString *)title tag:(NSInteger)tag
{
//    debugLog(@"comment=%@", [_commentInputEntity modelToJSONString]);
//    return;
    if ([objectNull(_commentInputEntity.content) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"提交中"];
    [HCSNetHttp requestWithCommentAdd:_commentInputEntity completion:^(id result) {
        [self responseWithCommentAdd:result];
    }];
}

- (void)responseWithCommentAdd:(TYZRespondDataEntity *)respond
{
    if (respond.errcode == respond_success)
    {
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        
        _orderDetailEnt.order.status = NS_ORDER_ORDER_COMPLETE_STATE;
        _orderDetailEnt.order.comment_status = 1;
        _orderDetailEnt.order.comment_status_desc = @"已评论";
        if (self.popResultBlock)
        {
            self.popResultBlock(_orderDetailEnt);
        }
        [self performSelector:@selector(clickedBack:) withObject:nil afterDelay:0.3];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:self];
    }
}

- (void)selectedCheck
{
//    for (CellCommonDataEntity *comEnt in self.baseList)
//    {
//        comEnt.isCheck = NO;
//    }
    
    CellCommonDataEntity *ent = self.baseList[_indexPath.row];
    
//    OrderMealContentEntity
//    OrderMealContentEntity *mEnt in _boradTypeList
    
    ent.isCheck = !ent.isCheck;
//    ent.isCheck = YES;
    [self.baseTableView reloadData];
    
    if (ent.isCheck)
    {
        BOOL isEx = NO;
        for (CommentClassifyEntity *cEnt in _commentInputEntity.classList)
        {
            if (cEnt.classify_id == ent.tag)
            {
                isEx = YES;
                break;
            }
        }
        if (!isEx)
        {
            CommentClassifyEntity *classifyEnt = [CommentClassifyEntity new];
            classifyEnt.classify_id = ent.tag;
            classifyEnt.classify_name = ent.title;
            [_commentInputEntity.classList addObject:classifyEnt];
        }
    }
    else
    {
        NSInteger index = -1;
        for (NSInteger i=0; i<[_commentInputEntity.classList count]; i++)
        {
            CommentClassifyEntity *cEnt = _commentInputEntity.classList[i];
            if (cEnt.classify_id == ent.tag)
            {
                index = i;
                break;
            }
        }
        if (index != -1)
        {
            [_commentInputEntity.classList removeObjectAtIndex:index];
        }
    }
    
    //"classify_id": 40001,
//    "classify_name": "亲朋聚餐好去处"
//
//    _commentInputEntity.classId = ent.tag;
    
}

//editStateBlock
/**
 *  编辑开始结束
 *
 *  @param state 1表示开始；2表示结束
 */
- (void)editWithState:(NSInteger)state
{
    if (state == 1)
    {// 开始
        self.baseTableView.contentOffset = CGPointMake(0, 280);
        return;
    }
    [self.view endEditing:YES];
    self.baseTableView.contentOffset = CGPointMake(0, 0);
}

// 添加评论图片
- (void)addWithImage
{
    [self editWithState:2];
    [self.showImageObject showActionSheet:self];
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
//        UIImage *image = [UIImage imageWithData:data];
//        debugLogSize(image.size);
        [weakSelf uploadImageToServer:data imageName:imgName];
    };
}

- (void)uploadImageToServer:(NSData *)data imageName:(NSString *)imageName
{
    [SVProgressHUD showWithStatus:@"上传中"];
    _uploadFileInputEntity.data = data;
    _uploadFileInputEntity.extName = _showImageObject.extName;
    
//    debugLog(@"inputEnt=%@", [_uploadFileInputEntity modelToJSONString]);
    
    __weak typeof(self)weakSelf = self;
    [_uploadImgServerObject getUploadFileToken:_uploadFileInputEntity complete:^(int status, NSString *host, NSString *filePath, NSInteger imageId) {
//        debugLog(@"status=%d; filePath=%@", status, filePath);
        if (status == 1)
        {
            [weakSelf uploadImageResponse:status urlPath:filePath imaegId:imageId];
        }
    }];
}

- (void)uploadImageResponse:(int)status urlPath:(NSString *)urlPath imaegId:(NSInteger)imageId
{
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_ORDER_COMMEND)
    {
        RestaurantImageEntity *imageEnt = [RestaurantImageEntity new];
        imageEnt.id = imageId;
        imageEnt.name = urlPath;
        [_commentInputEntity.images addObject:imageEnt];
        
        [MCYPushViewController reloadWithTableView:self.baseTableView indexPath:_indexPath reloadType:2];
    }
}

// 总体、口味、服务、环境
- (void)scoreWithStarPercent:(CGFloat)percent tag:(NSInteger)tag
{
    if (tag == 100)
    {// 总体
        _commentInputEntity.vote = 5 * percent;
    }
    else if (tag == 101)
    {// 口味
        _commentInputEntity.score1 = 5 * percent;
    }
    else if (tag == 102)
    {// 服务
        _commentInputEntity.score2 = 5 * percent;
    }
    else if (tag == 103)
    {// 环境
        _commentInputEntity.score3 = 5 * percent;
    }
}

- (void)commentWithContent:(id)comment
{
    _commentInputEntity.content = comment;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return [self.baseList count];
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0)
    {// 总体、口味、服务、环境
        UserEvaluationServiceViewCell *cell = [UserEvaluationServiceViewCell cellForTableView:tableView];
        [cell updateCellData:_commentInputEntity];
        cell.scoreWithStarPercentBlock = ^(CGFloat percent, NSInteger tag)
        {// 评论值
            [weakSelf scoreWithStarPercent:percent tag:tag];
        };
        return cell;
    }
    else if (indexPath.section == 1)
    {// 标签
        ShopAddLabelViewCell *cell = [ShopAddLabelViewCell cellForTableView:tableView];
        [cell updateCellData:self.baseList[indexPath.row]];
        return cell;
    }
    else
    {// 评论内容、图片
        ShopEvaluationContentViewCell *cell = [ShopEvaluationContentViewCell cellForTableView:tableView];
        [cell updateCellData:_commentInputEntity];
        cell.baseTableViewCellBlock = ^(id data)
        {// 评论内容
            [weakSelf commentWithContent:data];
        };
        cell.editStateBlock = ^(NSInteger state)
        {// 编辑开始、结束
            [weakSelf editWithState:state];
        };
        cell.addImageBlock = ^()
        {// 添加评论图片
            weakSelf.indexPath = indexPath;
            [weakSelf addWithImage];
            
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return kUserEvaluationServiceViewCellHeight;
    }
    else if (indexPath.section == 1)
    {
        return kShopAddLabelViewCellHeight;
    }
    else
    {
        return [ShopEvaluationContentViewCell getWithCellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.001;
    }
    else
    {
        return 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    else if (section == 1)
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"给餐厅添加标签吧";
        return view;
    }
    else
    {
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], 30);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor colorWithHexString:@"#ffeee5"];
        UILabel *label = [TYZCreateCommonObject createWithLabel:view labelFrame:CGRectMake(15, 5, [[UIScreen mainScreen] screenWidth] - 30, 20) textColor:[UIColor colorWithHexString:@"#999999"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentLeft];
        label.text = @"评论";
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 10;
    }
    else
    {
        return 0.001;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.indexPath = indexPath;
    if (indexPath.section == 1)
    {
        [self selectedCheck];
    }
}

@end













