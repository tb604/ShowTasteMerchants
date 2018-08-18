//
//  TYZShowImageInfoObject.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/11.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "TYZShowImageInfoObject.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "TYZImageEditorViewController.h"
#import "TYZKit.h"

@interface TYZShowImageInfoObject () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, assign) UIViewController *viewController;

@property (nonatomic, strong) ALAssetsLibrary *library;

@property (nonatomic, strong) TYZImageEditorViewController *imageEditor;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

/**
 *  1表示相册；2表示相机
 */
@property (nonatomic, assign) NSInteger pickerType;


- (void)initWithActionSheet;

- (void)initWithImageEditor;

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

@implementation TYZShowImageInfoObject

- (id)init
{
    if (self = [super init])
    {
        _imgType = EN_IMAGE_NONE_ACTION;// 默认是正方形
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        self.library = library;
        [self initWithActionSheet];
        
        [self initWithImageEditor];
    }
    return self;
}

- (void)initWithActionSheet
{
    _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [_actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
}

- (void)initWithImageEditor
{
//    NSLog(@"%s", __func__);
    _imageEditor = [[TYZImageEditorViewController alloc] initWithNibName:nil bundle:nil];
    _imageEditor.checkBounds = YES;
    _imageEditor.rotateEnabled = NO;
    __weak typeof(self)weakSelf = self;
//    _imageEditor.view.backgroundColor = [UIColor purpleColor];
    _imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled)
    {
        [weakSelf imageEditorDoneCancel:editedImage canceled:canceled];
    };
}

/*** 生成随机数  时间+随机数值 */
+ (NSString *)getTimeAndRandom
{
    int iRandom=arc4random();
    if (iRandom<0)
    {
        iRandom=-iRandom;
    }
    
    //    NSDateFormatter *tFormat=[[[NSDateFormatter alloc] init] autorelease];
    //    [tFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [NSDate date];
    NSString *str = [date stringWithFormat:@"yyyyMMddHHmmssSSS"];
    NSString *tResult=[NSString stringWithFormat:@"%@%d",str, iRandom];
    return tResult;
}

- (void)imageEditorDoneCancel:(UIImage *)editedImage canceled:(BOOL)canceled
{
    __weak typeof(self)weakSelf = self;
    if (editedImage && !canceled)
    {
        [_imagePicker dismissViewControllerAnimated:YES completion:^{
            UIImage *image = [editedImage imageByResizeToSize:_imgSize];
            NSData *imageData = nil;
            NSString *headImgName = nil;
            if ([_extName isEqualToString:@"png"])
            {
                imageData = UIImagePNGRepresentation(image);
                headImgName = [NSString stringWithFormat:@"image%@.%@", [[self class] getTimeAndRandom], _extName];
            }
            else if ([_extName isEqualToString:@"jpg"])
            {
                imageData = UIImageJPEGRepresentation(image, 0.9);
                headImgName = [NSString stringWithFormat:@"image%@.%@", [[self class] getTimeAndRandom], _extName];
            }
            else
            {
                imageData = UIImageJPEGRepresentation(image, 0.9);
                headImgName = [NSString stringWithFormat:@"image%@.jpg", [[self class] getTimeAndRandom]];
            }
            if (weakSelf.dissPickerHeadImgDataBlock)
            {
                weakSelf.dissPickerHeadImgDataBlock(imageData, headImgName);
            }
        }];
    }
    else
    {
        // 取消
        debugLog(@"取消了");
        if (self.pickerType == 1)
        {// 相册
            [_imagePicker popToRootViewControllerAnimated:YES];
        }
        else
        {// 相机
            // 返回后有点问题，暂时这样处理下
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate =self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.allowsEditing = NO;
            __weak typeof(self)weakSelf = self;
            [_viewController dismissViewControllerAnimated:NO completion:^{
                weakSelf.imagePicker.delegate = nil;
                weakSelf.imagePicker = nil;
                [weakSelf.viewController presentViewController:imagePicker animated:NO completion:NULL];
            }];
//            _imagePicker.delegate = nil;
//            _imagePicker = nil;
//            [_viewController presentViewController:imagePicker animated:NO completion:NULL];
            self.imagePicker = imagePicker;
        }
    }
    [_imagePicker setNavigationBarHidden:NO animated:YES];
}

#pragma mark start private methods
- (void)pickImageFromAlbum
{
    self.pickerType = 1;
    //    UIImagePickerControllerSourceTypePhotoLibrary // 来自图库
    //    UIImagePickerControllerSourceTypeCamera // 来自相机
    //    UIImagePickerControllerSourceTypeSavedPhotosAlbum // 来自相册
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    [_viewController presentViewController:imagePicker animated:YES completion:NULL];
    self.imagePicker = imagePicker;
}

//从相机获取图片
- (void)pickImageFromCamera
{
    self.pickerType = 2;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate =self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        [_viewController presentViewController:imagePicker animated:YES completion:NULL];
        self.imagePicker = imagePicker;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"相机不存在" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
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
#pragma mark start UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        _imageEditor.sourceImage = image;
        _imageEditor.previewImage = preview;
        // debugLogSize(preview.size);
        UIImage *empImg = _imageEditor.previewImage;
        // debugLogSize(empImg.size);
        [_imagePicker pushViewController:_imageEditor animated:YES];
        [_imagePicker setNavigationBarHidden:YES animated:NO];
        
        if (_imgType == EN_IMAGE_SQUARE_ACTION)
        {
            [_imageEditor squareWithAction];
        }
        else if (_imgType == EN_IMAGE_LANDSCAPE_ACTION)
        {
            [_imageEditor landscapeWithAction];
        }
        else if (_imgType == EN_IMAGE_PORTRAIT_ACTION)
        {
            [_imageEditor portraitWithAction];
        }
        else
        {
            [_imageEditor reset:NO];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get asset from library");
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

















