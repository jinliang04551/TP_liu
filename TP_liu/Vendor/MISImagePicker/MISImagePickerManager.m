/***********************************************************
 //  MISImagePickerManager.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerManager.h"
#import <Photos/Photos.h>
#import "MISImagePickerAlbum.h"

@interface MISImagePickerManager()<PHPhotoLibraryChangeObserver>
@property (nonatomic, strong) NSArray* albums;
@end


@implementation MISImagePickerManager

+ (void)load {
	/**
	 *  预创建实例
	 */
	[[self class] defaultManager];
}

+ (MISImagePickerManager *)defaultManager {
	static MISImagePickerManager* manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[MISImagePickerManager alloc] init];
	});
	return manager;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self registerNotifacations];
	}
	return self;
}

- (void)dealloc
{
	[self unregisterNotifacations];
}

/**
 *  注册通知
 */
- (void)registerNotifacations {
	//内存警告时
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	
	//在程序启动完成时 和 进入前台时，获取相册数据
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDididFinishLaunchingNotification:) name:UIApplicationDidFinishLaunchingNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];

	//系统相册数据变动时，重置相册数据
	if ([self isAlbumAuthorized]) {
		[[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
	}
}

/**
 *  取消通知
 */
- (void)unregisterNotifacations {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if ([self isAlbumAuthorized]) {
		[[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
	}
}

#pragma mark - Notifacations
- (void)applicationDididFinishLaunchingNotification:(NSNotification *)notification {
	[self prepareAlbums];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification {
	[self prepareAlbums];
}

- (void)applicationDidReceiveMemoryWarningNotification:(NSNotification *)notification {
	self.albums = nil; //清空重置
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
	self.albums = nil; //清空重置;
}


/**
 *  准备相册（提前获取到数据）
 */
- (void)prepareAlbums {
	if (self.albums.count > 0) {
		return;
	}
	
	//如果已经授权过了，那么可以预加载列表
	if ([self isAlbumAuthorized]) {
		[self fetchAlbumsWithCompletion:^{
			//Nothing to do..
		}];
	}
}

/**
 *  获取相册列表信息
 *
 *  @param completion 完成回调
 */
- (void)fetchAlbumsWithCompletion:(void(^)(void))completion {
	[self fetchAlbumsInPHPhotoLibraryWithCompletion:^(NSArray *albums) {
		self.albums = albums; //取到内容
		
		//返回完成
		if (completion) {
			completion();
		}
	}];
}

/**
 *  从PHPhotoLibrary中获取图片
 */
- (void)fetchAlbumsInPHPhotoLibraryWithCompletion:(void(^)(NSArray* albums))completion {
	if (!completion) {
		return;
	}
	
	//开线程运行
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		//用户创建的相册
		PHFetchResult* userAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
		//系统创建的相册
		PHFetchResult* smartAlbumResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
		
		NSMutableArray* albums = [NSMutableArray array];
		[albums addObjectsFromArray:[self albumsFetchedFromResult:smartAlbumResult]];
		[albums addObjectsFromArray:[self albumsFetchedFromResult:userAlbumResult]];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completion([albums copy]);
		});
	});
}

/**
 *  获取相册从PHFetchResult
 *
 *  @param result 指定结果集
 *
 *  @return 相册数组
 */
- (NSArray *)albumsFetchedFromResult:(PHFetchResult *)result {
	NSMutableArray* albums = [NSMutableArray array];

	[result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		PHAssetCollection* collection = obj;
		
		PHFetchOptions *option = [[PHFetchOptions alloc] init];
		option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
		PHFetchResult *albumResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
		
		NSMutableArray* assets = [NSMutableArray array];
		[albumResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[assets addObject:obj];
		}];
		
		//过滤已删除的 + 视频
		BOOL isVideo  = (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos
						 || collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumSlomoVideos);
		BOOL isDelete = (collection.assetCollectionSubtype > 211);//删除的 subtype 很大

		//取有相片的相册
		if (assets.count > 0 &&
			!isVideo
			&& !isDelete) {
			//记录数据
			MISImagePickerAlbum* album = [[MISImagePickerAlbum alloc] init];
			album.title = collection.localizedTitle;
			album.assets = assets;
			[albums addObject:album];
			
			PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
			options.deliveryMode  = PHImageRequestOptionsDeliveryModeFastFormat;
			options.synchronous = YES;
			//MISImageGroupCell posterImage size is 55.0f; so it is 55.0f
			CGFloat sizeWH = [UIScreen mainScreen].scale * 55.0f;
			[[PHImageManager defaultManager] requestImageForAsset:[assets firstObject] targetSize:CGSizeMake(sizeWH, sizeWH) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
				album.posterImage = result;
			}];
		}
	}];
	
	return [albums copy];
}

/**
 *  获取图片
 *
 *  @param asset      指定asset
 *  @param completion 结果回调
 */
- (void)fetchImageForAsset:(id)asset
				completion:(void(^)(UIImage *result))completion {
	if (!completion) {
		return;
	}
	
	PHAsset* phAsset = asset;
	PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
	options.deliveryMode  = PHImageRequestOptionsDeliveryModeOpportunistic;
	CGSize size = [UIScreen mainScreen].bounds.size;
	[[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
		completion(result);//先返回小图 再返回大图
	}];
}

/**
 *  获取图片缩略图
 *
 *  @param asset      指定asset (PHAsset or ALAsset)
 *  @param targetSize 指定size
 *  @param completion 结果回调
 */
- (void)fetchThumbnailForAsset:(id)asset
					targetSize:(CGSize)targetSize
					completion:(void(^)(UIImage *result))completion {
	if (!completion) {
		return;
	}
	
	PHAsset* phAsset = asset;
	PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
	options.deliveryMode  = PHImageRequestOptionsDeliveryModeHighQualityFormat;
	[[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
		completion(result);//返回小图
	}];
}

/**
 *  缩放图片
 *
 *  @param assets     指定多张图片assets
 *  @param completion 完成后回调 返回 @[UIImage]
 */
- (void)scaleImagesForAssets:(NSArray *)assets
					 maxSize:(CGSize)maxSize
					   scale:(CGFloat)scale
				  completion:(void(^)(NSArray* images))completion {
	if (!completion) {
		return;
	}
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableArray* array = [NSMutableArray array];
		for (id asset in assets) {
			__block UIImage* originImage = nil;
			PHAsset* phAsset = asset;
			PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
			options.deliveryMode  = PHImageRequestOptionsDeliveryModeHighQualityFormat;
			options.synchronous = YES; //同步执行
			CGSize size = [UIScreen mainScreen].bounds.size;//取屏幕大小的图片
			[[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
				//取图片
				originImage = result;
			}];
			
			//缩放图片-代码优化过，1:1的情况下直接返回
			UIImage* scaledImage = nil;
			if (scale) {
				scaledImage = [self imageWithImage:originImage scale:scale];

			}else {
				scaledImage = [self imageScaleWithImage:originImage maxSize:maxSize];
			}
			
			//收集
			if (scaledImage) {
				[array addObject:scaledImage];
			}
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			completion([array copy]);
		});
	});
}

/**
 *  缩放图片
 *
 *  @param image      指定图片
 *  @param maxSize    指定最大高宽 (单位:Piexl)
 *  @param scale      指定缩放比 (非0时有效，与minSize maxSize冲突)
 *  @param completion 完成后回调 返回 UIImage
 */
- (void)scaleImage:(UIImage *)image
		 maxSize:(CGSize)maxSize
			 scale:(CGFloat)scale
		completion:(void(^)(UIImage* scaledImage))completion {
	if (!completion) {
		return;
	}
	
	UIImage* scaledImage = nil;
	if (scale) {
		scaledImage = [self imageWithImage:image scale:scale];
		
	}else {
		scaledImage = [self imageScaleWithImage:image maxSize:maxSize];
	}

	//返回
	completion(scaledImage);
}

/**
 *  编码视频
 *
 *  @param url AVURLAsset URL.
 *  @param completion 完成的回调  编码MP4后的文件路径:filePath 文件大小:fileSize 单位:kb 第一帧的图片：thumbnail 时长:duration
 */
- (void)encodeVideoWithURL:(NSURL *)url
				completion:(void(^)(NSString* filePath, NSInteger fileSize, UIImage* thumbnail, NSInteger duration))completion {
	if (!completion) {
		return;
	}
	
	NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey:@NO};
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:options];
	
	//计算时长
	NSInteger duration = 0;
	if (asset.duration.timescale) {
		duration = (NSInteger)(asset.duration.value / asset.duration.timescale);
	}
	
	//获取第一帧图
	UIImage* thumbnail = [self thumbImageForVedioWithAsset:asset];

	//转码开始
	AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:asset
																		  presetName:AVAssetExportPresetMediumQuality];
	//视频长了，截取
	if (duration > self.videoMaximumDuration) {
		duration = self.videoMaximumDuration;
		Float64 fduration = duration;
		CMTime start = CMTimeMakeWithSeconds(0.0f, 30);
		CMTime duration = CMTimeMakeWithSeconds(fduration, 30);
		exportSession.timeRange = CMTimeRangeMake(start, duration);
	}
	
	//文件名
	NSString* fileName = [NSString stringWithFormat:@"%f.mp4", [[NSDate date] timeIntervalSince1970]];
	NSString* mp4Path = [self.defaultCachePath stringByAppendingPathComponent:fileName];
	exportSession.outputURL = [NSURL fileURLWithPath: mp4Path];
	exportSession.shouldOptimizeForNetworkUse = YES;
	exportSession.outputFileType = AVFileTypeMPEG4;
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		switch ([exportSession status])
		{
			case AVAssetExportSessionStatusCompleted:
			{
				NSLog(@"%s, AVAssetExportSessionStatusCompleted", __FUNCTION__);
				NSInteger fileSize = [self fileSizeAtPath:mp4Path];
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(mp4Path, fileSize, thumbnail, duration);
				});
			}
				break;
			default:
			{
				NSLog(@"%s, AVAssetExportSessionStatusFaild", __FUNCTION__);
				dispatch_async(dispatch_get_main_queue(), ^{
					completion(@"", -1, nil, 0);
				});
			}
				break;
		}
	}];
}

/**
 *  获取文件大小
 *
 *  @param filePath 传入文件路径
 *
 *  @return 文件大小 单位:kb
 */
- (NSInteger) fileSizeAtPath:(NSString *)filePath {
	NSFileManager * filemanager = [[NSFileManager alloc]init];
	if([filemanager fileExistsAtPath:filePath]) {
		NSDictionary * attributes = [filemanager attributesOfItemAtPath:filePath error:nil];
		if (attributes) {
			NSNumber *fileSizeValue = [attributes objectForKey:NSFileSize];
			if (fileSizeValue) {
				return  (NSInteger)[fileSizeValue longLongValue] / 1024;
			}
		}
		return -1;
	}
	
	return -1;
}

/**
 *  获取视频的第一帧图片
 *
 *  @param asset 传入AVURLAsset
 *
 *  @return 图片UIImage
 */
- (UIImage*) thumbImageForVedioWithAsset:(AVURLAsset *)asset {
	AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
	assetImageGenerator.appliesPreferredTrackTransform = YES;
	assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
	
	UIImage* result = nil;
	NSError *error = nil;
	CGImageRef thumbImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(1, 60) actualTime:NULL error:&error];
	
	if (thumbImageRef) {
		result = [[UIImage alloc] initWithCGImage:thumbImageRef];
	}else {
		NSLog(@"thumbImageForVedioWithAssetError: %@", error);
	}
	
	return result;
}


/**
 *  相册授权申请
 *
 *  @param completion 结果
 */
- (void)albumAuthorizationWithAvailableCompletion:(void(^)(void))completion {
	[PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
		switch (status) {
			case PHAuthorizationStatusRestricted:
			case PHAuthorizationStatusDenied:
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self showAlbumUnAuthorizedAlert];
				});
			}
				break;
			case PHAuthorizationStatusNotDetermined:
			case PHAuthorizationStatusAuthorized:
			{
				dispatch_async(dispatch_get_main_queue(), ^{
					completion();
				});
			}
				break;
			default:
				break;
		}
	}];
}

/**
 *  检查相册是否已经授权申请
 *
 *  @param completion 结果
 */
- (BOOL)isAlbumAuthorized {
	return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}


/**
 * 照片未授权提示
 */
- (void)showAlbumUnAuthorizedAlert {
	NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString* message = [NSString stringWithFormat:@"请在iPhone的\"设置-稳私-照片\"选项中，允许%@访问你的手机相册。", appName];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"确定"
										 otherButtonTitles:nil, nil];
	[alert show];
}

/**
 * 相册未授权提示
 */
- (void)showCameraUnAuthorizedAlert {
	NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString* message = [NSString stringWithFormat:@"请在iPhone的\"设置-稳私-相机\"选项中，允许%@访问你的相机。", appName];
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
												   message:message
												  delegate:nil
										 cancelButtonTitle:@"确定"
										 otherButtonTitles:nil, nil];
	[alert show];
}

/**
 *  相机授权申请
 *
 *  @param completion 结果
 */
- (void)cameraAuthorizationWithAvailableCompletion:(void(^)(void))completion {
	NSString *mediaType = AVMediaTypeVideo;
	AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
	switch (authStatus) {
		case AVAuthorizationStatusDenied:
		case AVAuthorizationStatusRestricted:
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				[self showCameraUnAuthorizedAlert];
			});
		}
			break;
		case AVAuthorizationStatusNotDetermined:
		case AVAuthorizationStatusAuthorized:
		{
			dispatch_async(dispatch_get_main_queue(), ^{
				completion();
			});
		}
			break;
		default:
			break;
	}
}


#pragma mark - Getter & Setter

- (NSString *)defaultCachePath {
	if (!_defaultCachePath) {
		/*
		 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		 _defaultCachePath = [paths[0] stringByAppendingPathComponent:@"Cache"];
		 
		 if (![[NSFileManager defaultManager] fileExistsAtPath:_defaultCachePath])
		 {
			[[NSFileManager defaultManager] createDirectoryAtPath:_defaultCachePath
		 withIntermediateDirectories:YES
		 attributes:nil
		 error:NULL];
		 }
		 */
		_defaultCachePath = NSTemporaryDirectory();
	}
	
	return _defaultCachePath;
}


#pragma mark - Utils

/**
 *  以指定范围方式缩放图片到指定size
 *  保持图片比例
 *  图片大于 maxsize 时会被缩小
 *  @param maxSize 最大size 以ScaleAspectFit方式
 *
 *  @return image obj
 */
- (UIImage *)imageScaleWithImage:(UIImage *)image maxSize:(CGSize )maxSize {
	CGFloat scaleX = maxSize.width / image.size.width;
	CGFloat scaleY = maxSize.height / image.size.height;
	CGFloat scale = MIN(scaleX, scaleY); //最小比例
	
	return [self imageWithImage:image scale:scale];
}


/**
 *  保持长宽比的方式缩放图片
 *
 *  @param scale 缩放比例
 *
 *  @return image obj
 */
- (UIImage *)imageWithImage:(UIImage *)image scale:(CGFloat )scale {
	//Fix for webp 8 bytes width align
	NSInteger  width = (int )(image.size.width * scale) / 8 * 8;
	CGFloat fixScale = width / image.size.width;
	
	//直接返回
	if (fixScale == 1.0) {
		return image;
	}
	
	
	NSInteger  hegiht = (width / image.size.width) * image.size.height;
	
	CGSize size = CGSizeMake(width, hegiht);
	
	UIGraphicsBeginImageContext(size);
	
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}


@end
