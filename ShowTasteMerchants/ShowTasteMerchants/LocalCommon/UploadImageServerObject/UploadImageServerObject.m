//
//  UploadImageServerObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/16.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UploadImageServerObject.h"
#import "LocalCommon.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "QiniuSDK.h"
#import "QiNiuTokenObject.h"


@interface UploadImageServerObject ()

@property (nonatomic, strong) QiNiuTokenObject *tokenEntity;

- (void)uploadWithImageToQNFilePath:(NSString *)filePath token:(NSString *)token;


- (void)uploadWithTOQNFileData:(NSData *)data imageId:(NSInteger)imageId token:(NSString *)token fileName:(NSString *)fileName host:(NSString *)host complete:(void(^)(int status, NSString *host, NSString *filePath, NSInteger imageId))complete;

@end

@implementation UploadImageServerObject

- (void)getUploadFileToken:(UploadFileInputObject *)inputEntity complete:(void (^)(int, NSString *, NSString *, NSInteger))complete
{
//    debugLog(@"imageType=%d", (int)inputEntity.imageType);
    if (inputEntity.imageType == EN_UPLOAD_IMAGE_HEADER)
    {// 用户头像
        debugLog(@"用户头像");
        [HCSNetHttp requestWithUploadUserToken:inputEntity.userId extName:inputEntity.extName completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
    else if (inputEntity.imageType == EN_UPLOAD_IMAGE_FOOD_DETAIL)
    {// 菜品详情图片
        [HCSNetHttp requestWithUploadFoodDetailsToken:inputEntity completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
    else if (inputEntity.imageType == EN_UPLOAD_IMAGE_FOOD_RELATED)
    {// 菜品相关图片
        [HCSNetHttp requestWithUploadFoodToken:inputEntity completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
    else if (inputEntity.imageType == EN_UPLOAD_IMAGE_ORDER_COMMEND)
    {// 订单评论图片
//        debugLog(@"订单评论");
        [HCSNetHttp requestWithUploadCommentToken:inputEntity completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
    else if (inputEntity.imageType == EN_UPLOAD_IMAGE_COMMUNITY_COMMEND)
    {// 社区评论图片
        [HCSNetHttp requestWithUploadCommunityToken:inputEntity completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
    else
    {// 餐厅
        [HCSNetHttp requestWithUploadShopToken:inputEntity completion:^(id result) {
            [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
        }];
    }
//    [HCSNetHttp requestWithQiniuToken:inputEntity.sourceId imageType:inputEntity.imageType extName:inputEntity.extName completion:^(id result) {
//        [self getUploadFileTokenResponse:result inputEntity:inputEntity complete:complete];
//    }];
}

- (void)getUploadFileTokenResponse:(TYZRespondDataEntity *)respond inputEntity:(UploadFileInputObject *)inputEntity complete:(void(^)(int status, NSString *host, NSString *filePath, NSInteger imageId))complete
{
    if (respond.errcode == respond_success)
    {
        self.tokenEntity = respond.data;
        debugLog(@"token=%@", [_tokenEntity modelToJSONString]);
//        debugLog(@"fileName=%@", _tokenEntity.fname);
        NSString *name = nil;
//        if (inputEntity.imageType == EN_UPLOAD_IMAGE_HEADER)
//        {// 上传头像的时候，是临时处理
            name = _tokenEntity.temp_name;
//        }
//        else
//        {
            name = _tokenEntity.name;
//        }
        [self uploadWithTOQNFileData:inputEntity.data imageId:_tokenEntity.image_id token:_tokenEntity.token fileName:name host:_tokenEntity.host complete:complete];
    }
    else
    {
        [UtilityObject svProgressHUDError:respond viewContrller:nil];
    }
}

- (void)uploadWithImageToQNFilePath:(NSString *)filePath token:(NSString *)token
{
    // checkCrc 为NO时，服务端不会校验crc32值，为YES时，服务端会计算上传文件的crc32值，然后与用户提供的crc32参数值比较确认文件的完成性，如果校验失败会返回406错误。
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        debugLog(@"key=%@; percent=%.2f", key, percent);
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    [upManager putFile:filePath key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        debugLog(@"info=%@", info);
        debugLog(@"key=%@", key);
        debugLog(@"resp=%@", resp);
    } option:uploadOption];
}

- (void)uploadWithTOQNFileData:(NSData *)data imageId:(NSInteger)imageId token:(NSString *)token fileName:(NSString *)fileName host:(NSString *)host complete:(void(^)(int status, NSString *host, NSString *filePath, NSInteger imageId))complete
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        debugLog(@"key=%@; percent=%.2f", key, percent);
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    debugLog(@"token=%@; key=%@", token, fileName);
    [upManager putData:data key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        debugLog(@"info=%@", info);
        debugLog(@"statusCode=%d", info.statusCode);
        debugLog(@"host=%@", info.host);
        debugLog(@"serverIp=%@", info.serverIp);
        debugLog(@"key=%@", key);
        // http://upload.qiniu.com/user/20/1466056333.png
        debugLog(@"resp=%@", resp);
        if (!info.isOK)
        {
            debugLog(@"上传图片失败");
            return;
        }
        if (complete)
        {
            NSString *ret = resp[@"ret"];
            NSString *avatar = objectNull(resp[@"avatar"]);
            int status = 0; // 0表示失败
            if ([ret isEqualToString:@"success"])
            {
                [SVProgressHUD dismiss];
                status = 1; // 1表示成功
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"上传图片失败"];
            }
            if ([avatar isEqualToString:@""])
            {
                complete(status, host, [NSString stringWithFormat:@"%@%@", host, key], imageId);
            }
            else
            {
                complete(status, host, avatar, imageId);
            }
        }
    } option:uploadOption];
}
@end

























