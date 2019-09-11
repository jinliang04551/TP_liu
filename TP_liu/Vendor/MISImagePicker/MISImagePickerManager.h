
/***********************************************************
 //  MISImagePickerManager.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/


#import <UIKit/UIKit.h>

@interface MISImagePickerManager : NSObject

/**
 *  相册列表数据
 */
@property(nonatomic, strong, readonly)NSArray* albums;

/**
 *  默认缓存目录-默认 /tmp
 */
@property (nonatomic, copy) NSString* defaultCachePath;

/**
 *  视频录制最大时长 单位:秒 默认为:60秒
 */
@property (nonatomic) NSInteger videoMaximumDuration;

/**
 *  唯一入口
 *
 *  @return 单例
 */
+ (MISImagePickerManager *)defaultManager;


/**
 *  获取相册列表信息
 *
 *  @param completion 完成回调
 */
- (void)fetchAlbumsWithCompletion:(void(^)(void))completion;


/**
 *  准备相册（提前获取到数据）
 */
- (void)prepareAlbums;


/**
 *  获取图片
 *
 *  @param asset      指定asset (PHAsset or ALAsset)
 *  @param completion 结果回调
 */
- (void)fetchImageForAsset:(id)asset
				completion:(void(^)(UIImage *result))completion;

/**
 *  获取图片缩略图
 *
 *  @param asset      指定asset (PHAsset or ALAsset)
 *  @param targetSize 指定size  (ALAsset 无效)
 *  @param completion 结果回调
 */
- (void)fetchThumbnailForAsset:(id)asset
					targetSize:(CGSize)targetSize
					completion:(void(^)(UIImage *result))completion;


/**
 *  缩放图片
 *
 *  @param assets     指定多张图片assets
 *  @param maxSize    指定最大高宽 (单位:Piexl)
 *  @param scale      指定缩放比 (非0时有效，与maxSize冲突)
 *  @param completion 完成后回调 返回 @[UIImage]
 */
- (void)scaleImagesForAssets:(NSArray *)assets
					 maxSize:(CGSize)maxSize
					   scale:(CGFloat)scale
				  completion:(void(^)(NSArray* images))completion;

/**
 *  缩放图片
 *
 *  @param image      指定图片
 *  @param maxSize    指定最大高宽 (单位:Piexl)
 *  @param scale      指定缩放比 (非0时有效，与maxSize冲突)
 *  @param completion 完成后回调 返回 UIImage
 */
- (void)scaleImage:(UIImage *)image
		   maxSize:(CGSize)maxSize
			 scale:(CGFloat)scale
		completion:(void(^)(UIImage* scaledImage))completion;


/**
 *  编码视频
 *
 *  @param url AVURLAsset URL.
 *  @param completion 完成的回调  编码MP4后的文件路径:filePath 文件大小:fileSize 单位:kb 第一帧的图片：thumbnail 时长:duration
 */
- (void)encodeVideoWithURL:(NSURL *)url
				completion:(void(^)(NSString* filePath, NSInteger fileSize, UIImage* thumbnail, NSInteger duration))completion;


/**
 *  相册授权申请
 *
 *  @param completion 可用的结果
 */
- (void)albumAuthorizationWithAvailableCompletion:(void(^)(void))completion;


/**
 *  相机授权申请
 *
 *  @param completion 可用的结果
 */
- (void)cameraAuthorizationWithAvailableCompletion:(void(^)(void))completion;

@end
