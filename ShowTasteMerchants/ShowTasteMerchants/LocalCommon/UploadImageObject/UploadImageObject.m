//
//  UploadImageObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/5/27.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "UploadImageObject.h"
#import "LocalCommon.h"

@interface UploadImageObject() <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, assign) UIViewController *viewController;


- (void)initWithActionSheet;

/**
 *  打开照相机
 */
- (void)pickImageFromAlbum;

/**
 *  从相机获取图片
 */
- (void)pickImageFromCamera;

/**
 *  关闭相册和相机视图控制器后，传送数据
 *
 *  @param imgData     头像图片imgdata
 *  @param headImgName 头像图片的名称
 */
- (void)dismissPickerImgData:(NSData *)imgData headImgName:(NSString *)headImgName;

@end

@implementation UploadImageObject

- (id)init
{
    if (self = [super init])
    {
        _imgType = 1;// 默认是正方形
        [self initWithActionSheet];
    }
    return self;
}

- (void)initWithActionSheet
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [_actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
}

#pragma mark start private methods
- (void)pickImageFromAlbum
{
//    UIImagePickerControllerSourceTypePhotoLibrary // 来自图库
//    UIImagePickerControllerSourceTypeCamera // 来自相机
//    UIImagePickerControllerSourceTypeSavedPhotosAlbum // 来自相册
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
//    imagePicker.showsCameraControls = YES;
    [_viewController presentViewController:imagePicker animated:YES completion:NULL];
    //    CC_SAFE_RELEASE(imagePicker);
}

//从相机获取图片
- (void)pickImageFromCamera
{
    debugLog(@"相机");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate =self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
//        imagePicker.showsCameraControls = YES;
        [_viewController presentViewController:imagePicker animated:YES completion:NULL];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"相机不存在", @"")];
    }
}

/**
 *  关闭相册和相机视图控制器后，传送数据
 *
 *  @param imgData     头像图片imgdata
 *  @param headImgName 头像图片的名称
 */
- (void)dismissPickerImgData:(NSData *)imgData headImgName:(NSString *)headImgName
{
    if (_dissPickerHeadImgDataBlock)
    {
        _dissPickerHeadImgDataBlock(imgData, headImgName);
    }
}
#pragma mark end private methods

- (void)showActionSheet:(UIViewController *)vc
{
    self.viewController = vc;
    [self.actionSheet showInView:vc.view];
}

#pragma mark start delegate
#pragma mark start UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {// 拍照
        [self pickImageFromCamera];
    }
    else if (buttonIndex == 1)
    { // 从手机相册选择
        [self pickImageFromAlbum];
    }
}
#pragma mark end UIActionSheetDelegate
/*
 CGSize winsize = [[UIScreen mainScreen] bounds].size;
 CGSize size = image.size;
 CGFloat ratio = 0.0;
 if (size.width > size.height)
 {
 ratio = winsize.width / size.width;
 }
 else
 {
 ratio = winsize.height / size.height;
 }
 
 bigImage = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(ratio*size.width, ratio*size.height)];
 imageData = UIImageJPEGRepresentation(bigImage, 0.8);
 headImgName = [NSString stringWithFormat:@"img%@.jpg", [UtilityObject stringWithUUID]];
 */
#pragma mark start UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) blockSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *imageData = nil;
        UIImage *image = nil;
        UIImage *headImage = nil;
        if (_imgType == 1)
        {// 正方形
            // UIImagePickerControllerEditedImage 获取图片裁剪的图
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
            if (_imgSize.width == 0)
            {
                _imgSize = CGSizeMake(140, 140);
            }
            headImage = [image imageByResizeToSize:_imgSize];
        }
        else if (_imgType == 3)
        {// 指定的长方形大小
            debugLog(@"指定的长方形大小");
            image = [info objectForKey:UIImagePickerControllerCropRect];
            headImage = [image imageByResizeToSize:_imgSize];
        }
        else
        {// 长方形
            // UIImagePickerControllerOriginalImage 获取照片的原图
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            CGSize winsize = [[UIScreen mainScreen] bounds].size;
            CGSize size = image.size;
            CGFloat ratio = 0.0;
            if (size.width > size.height)
            {
                ratio = winsize.width / size.width;
            }
            else
            {
                ratio = winsize.height / size.height;
            }
            
            headImage = [image imageByResizeToSize:CGSizeMake(ratio*size.width, ratio*size.height)];
            //            headImage = [UIImage imageWithImageSimple:image scaledToSize:CGSizeMake(ratio*size.width, ratio*size.height)];
        }
        //        if (_imgSize.width == 0)
        //        {
        //            _imgSize = CGSizeMake(140, 140);
        //        }
        
        //        UIImage *headImage = [UIImage imageWithImageSimple:image scaledToSize:_imgSize];
//        imageData = UIImageJPEGRepresentation(headImage, 0.9);//UIImagePNGRepresentation(headImage);
        NSString *headImgName = nil;
        if ([_extName isEqualToString:@"png"])
        {
            imageData = UIImagePNGRepresentation(headImage);
            headImgName = [NSString stringWithFormat:@"image%@.%@", [UtilityObject getTimeAndRandom], _extName];
        }
        else if ([_extName isEqualToString:@"jpg"])
        {
            imageData = UIImageJPEGRepresentation(headImage, 0.9);
            headImgName = [NSString stringWithFormat:@"image%@.%@", [UtilityObject getTimeAndRandom], _extName];
        }
        else
        {
            imageData = UIImageJPEGRepresentation(headImage, 0.9);
            headImgName = [NSString stringWithFormat:@"image%@.jpg", [UtilityObject getTimeAndRandom]];
        }
        [blockSelf dismissPickerImgData:imageData headImgName:headImgName];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark end UIImagePickerControllerDelegate
#pragma mark end delegate



@end
