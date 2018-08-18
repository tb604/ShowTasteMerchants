//
//  ALAssetsLibrary+TYZAdd.h
//  CameraCollectionData
//
//  Created by 唐斌 on 2016/11/15.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>


// https://github.com/Kjuly/ALAssetsLibrary-CustomPhotoAlbum

@interface ALAssetsLibrary (TYZAdd)

/**
 *  @brief Write the image data to the assets library (camera roll).
 *
 *  @param image The target image to be saved
 *  @param albumName Custom album name
 *  @param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 *  @param failure Block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveWithImage:(UIImage *)image toAlbumName:(NSString *)albumName completion:(ALAssetsLibraryWriteImageCompletionBlock)completion failure:(ALAssetsLibraryAccessFailureBlock)failure;

/** 
 *  @brief write the video to the assets library (camera roll).
 *
 * @param videoUrl The target video to be saved
 * @param albumName Custom album name
 * @param completion Block to be executed when succeed to write the image data to the assets library (camera roll)
 * @param failure block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveWithVideo:(NSURL *)videoUrl toAlbumName:(NSString *)albumName completion:(ALAssetsLibraryWriteImageCompletionBlock)completion failure:(ALAssetsLibraryAccessFailureBlock)failure;

/**
 *  @brief Write the image data with meta data to the assets library (camera roll).
 *
 * @param imageData The image data to be saved
 * @param albumName Custom album name
 * @param metadata Meta data for image
 * @param completion Block to be executed when succeed to write the image data
 * @param failure block to be executed when failed to add the asset to the custom photo album
 */
- (void)saveWithImageData:(NSData *)imageData toAlbumName:(NSString *)albumName metadata:(NSDictionary *)metadata completion:(ALAssetsLibraryWriteImageCompletionBlock)completion failure:(ALAssetsLibraryAccessFailureBlock)failure;

/**
 *  @brief Write the asset to the assets library (camera roll).
 *
 * @param assetURL The asset URL
 * @param albumName Custom album name
 * @param completion Block to be executed when succeed
 * @param failure Block to be executed when failed to add the asset to the custom photo album
 */
- (void)addAssetURL:(NSURL *)assetURL toAlbumName:(NSString *)albumName completion:(ALAssetsLibraryWriteImageCompletionBlock)completion failure:(ALAssetsLibraryAccessFailureBlock)failure;

/**
 *  @brief Loads assets w/ desired property from the assets group (album)
 *
 * @param property   Property for the asset, refer to ALAsset.h, if not offered, just return instances of ALAsset
 * @param albumName  Custom album name
 * @param completion Block to be executed when succeed or failed to load assets from target album
 */
- (void)loadAssetsForProperty:(NSString *)property fromAlbum:(NSString *)albumName completion:(void (^)(NSMutableArray *array, NSError *error))completion;

/**
 *  @brief Loads assets from the assets group (album)
 *
 * @param albumName Custom album name
 * @param completion Block to be executed when succeed or failed to load images from target album
 */
- (void)loadImagesFromAlbum:(NSString *)albumName completion:(void (^)(NSMutableArray *array, NSError *error))completion;

@end



























