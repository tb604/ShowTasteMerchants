//
//  AddFoodRelatedInfoViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/7/12.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "AddFoodRelatedInfoViewController.h"
#import "LocalCommon.h"
#import "ResaurantAddFoodImageView.h"
#import "TYZPlaceholderTextView.h"
#import "TYZShowImageInfoObject.h" // 显示，选择相册还是相机视图
#import "UploadFileInputObject.h" // 上传图片出入参数
#import "UploadImageServerObject.h" // 上传到七牛平台
#import "UIImageView+WebCache.h"

@interface AddFoodRelatedInfoViewController () <UITextViewDelegate>
{
    UIScrollView *_contentView;
    
    /**
     *  是否添加
     */
    BOOL _isAdd;
    
    ResaurantAddFoodImageView *_thumalImgView;
    
    TYZPlaceholderTextView *_introTextView;
    
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

- (void)initWithContentView;

- (void)initWithThumalImgView;

- (void)initWithIntroTextView;

- (void)initWithShowImageObject;

@end

@implementation AddFoodRelatedInfoViewController


- (void)initWithVar
{
    [super initWithVar];
    
    _isAdd = NO;
    if (!_foodImageEntity)
    {
        _isAdd = YES;
        _foodImageEntity = [[ShopFoodImageEntity alloc] init];
    }
    
    [self initWithShowImageObject];
    
    _uploadFileInputEntity = [[UploadFileInputObject alloc] init];
    _uploadFileInputEntity.userId = [UserLoginStateObject getUserId];
    _uploadFileInputEntity.shopId = [UserLoginStateObject getCurrentShopId];
    _uploadFileInputEntity.imageType = EN_UPLOAD_IMAGE_FOOD_RELATED;
    
    _uploadImgServerObject = [[UploadImageServerObject alloc] init];
    

}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
    if (_isAdd)
    {
        self.title = @"添加";
    }
    else
    {
        self.title = @"编辑";
    }
    
    
    // 保存
    /*NSString *str = @"保存";
    CGFloat width = [str widthForFont:FONTSIZE_16];
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setTitle:str forState:UIControlStateNormal];
    btnSave.titleLabel.font = FONTSIZE_16;
    btnSave.frame = CGRectMake(0, 0, width, 30);
    [btnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(saveWithFoodImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemSave = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    self.navigationItem.rightBarButtonItem = itemSave;
     */
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithContentView];
    
    [self initWithThumalImgView];
    
    [self initWithIntroTextView];
}

- (void)clickedBack:(id)sender
{
    
//    if ([objectNull(_foodImageEntity.image) isEqualToString:@""])
//    {
//        [SVProgressHUD showErrorWithStatus:@"请上传相关图片"];
//        return;
//    }
    
    _foodImageEntity.descHeight = [UtilityObject mulFontHeights:objectNull(_foodImageEntity.desc) font:FONTSIZE_13 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
    
    if (self.popResultBlock)
    {
        if ([objectNull(_foodImageEntity.image) isEqualToString:@""])
        {
            self.popResultBlock(nil);
        }
        else
        {
            self.popResultBlock(_foodImageEntity);
        }
    }
    [super clickedBack:sender];
}

- (void)initWithContentView
{
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], [[UIScreen mainScreen] screenHeight] - STATUSBAR_HEIGHT - NAVBAR_HEIGHT);
    _contentView = [[UIScrollView alloc] initWithFrame:frame];
//    _contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_contentView];
}

- (void)initWithThumalImgView
{
    CGRect frame = CGRectMake(15, 10, [[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
    _thumalImgView = [[ResaurantAddFoodImageView alloc] initWithFrame:frame];
    _thumalImgView.backgroundColor = [UIColor whiteColor];
    _thumalImgView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    _thumalImgView.layer.borderWidth = 1;
    [_contentView addSubview:_thumalImgView];
    [_thumalImgView updateWithTitle:@"请上传相关菜品图片"];
    __weak typeof(self) weakSelf = self;
    _thumalImgView.touchUploadImageBlock = ^()
    {
        [weakSelf.view endEditing:YES];
        [weakSelf.showImageObject showActionSheet:weakSelf];
    };
}

- (void)initWithIntroTextView
{
    CGRect frame = CGRectMake(15, _thumalImgView.bottom + 5, [[UIScreen mainScreen] screenWidth] - 30, 60);
    _introTextView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _introTextView.delegate = self;
    _introTextView.placeholder = @"请添加文字备注";
    _introTextView.font = FONTSIZE_15;
    _introTextView.text = objectNull(_foodImageEntity.desc);
    _introTextView.textColor = [UIColor colorWithHexString:@"#323232"];
    _introTextView.returnKeyType = UIReturnKeyDone;
    _introTextView.keyboardType = UIKeyboardAppearanceDefault;
    [_contentView addSubview:_introTextView];
}

- (void)initWithShowImageObject
{
    __weak typeof(self)weakSelf = self;
    _showImageObject = [[TYZShowImageInfoObject alloc] init];
    _showImageObject.imgSize = CGSizeMake([[UIScreen mainScreen] screenWidth] - 30, [ResaurantAddFoodImageView getWithHeight]);
    _showImageObject.imgType = EN_IMAGE_LANDSCAPE_ACTION;
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
        debugLog(@"status=%d; filePath=%@", status, filePath);
        if (status == 1)
        {
            [weakSelf uploadImageResponse:status urlPath:filePath];
        }
    }];
}

- (void)uploadImageResponse:(int)status urlPath:(NSString *)urlPath
{
    if (_uploadFileInputEntity.imageType == EN_UPLOAD_IMAGE_FOOD_RELATED)
    {
        _foodImageEntity.image = urlPath;
        [self performSelector:@selector(refreshWithImage) withObject:nil afterDelay:0.5];
    }
    else
    {
        [_thumalImgView hiddenWithThumalImage:NO];
    }
}

- (void)refreshWithImage
{
    [_thumalImgView sd_setImageWithURL:[NSURL URLWithString:_foodImageEntity.image] placeholderImage:nil];
    [_thumalImgView hiddenWithThumalImage:YES];
}


- (void)saveWithFoodImage:(id)sender
{
    if ([objectNull(_foodImageEntity.image) isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"请上传相关图片"];
        return;
    }
    
    _foodImageEntity.descHeight = [UtilityObject mulFontHeights:objectNull(_foodImageEntity.desc) font:FONTSIZE_13 maxWidth:[[UIScreen mainScreen] screenWidth] - 30];
    
    if (self.popResultBlock)
    {
        self.popResultBlock(_foodImageEntity);
    }
    [self clickedBack:nil];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    debugMethod();
    CGFloat cheight = _contentView.height;
    CGFloat mut = cheight - _introTextView.bottom;
//    debugLog(@"mut=%.2f", mut);
    if (mut < 216+40)
    {
        _contentView.contentOffset = CGPointMake(0, mut);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    debugMethod();
    _contentView.contentOffset = CGPointMake(0, 0);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        _foodImageEntity.desc = textView.text;
        return YES;
    }
    return YES;
}

@end
