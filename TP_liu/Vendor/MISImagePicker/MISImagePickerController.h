
/***********************************************************
 //  MISImagePickerController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

/**
 *  库类型选择
 */
typedef NS_ENUM(NSInteger, MISImagePickerSorceType) {
	/**
	 *  多选相册
	 */
	MISImagePickerSorceTypeMulti = 0,
	/**
	 *  系统相册-单选
	 */
	MISImagePickerSorceTypeAlbums = 1,
	/**
	 *  相机-选择
	 */
	MISImagePickerSorceTypeCamera = 2,
	/**
	 *  相机-录视频
	 */
	MISImagePickerSorceTypeVideo  = 3,
	/**
	 *  自定相机-拍照-裁剪-横屏
	 */
	MISImagePickerSorceTypeCustomHorizontalCamera  = 4,
	
	/**
	 *  系统相-单选视频
	 */
	MISImagePickerSorceTypeAlbumVideo = 5
};


@interface MISImagePickerController : NSObject

/**
 *  点完成的回调-图片为原图较大 @[UIImage]
 */
@property (nonatomic, copy) void (^selectedFinishBlock)(NSArray* images);


/**
 *  最多可选(MISImagePickerSorceTypeMulti 时有效) 默认9张
 */
@property (nonatomic) NSInteger maxImageCount;

/**
 *  允许编辑-（MISImagePickerSorceTypeMulti 时无效）默认为NO
 */
@property (nonatomic) BOOL allowsEditing;

/**
 *  相册库类型 -默认为: MISImagePickerSorceTypeMulti
 */
@property (nonatomic) MISImagePickerSorceType sourceType;


/**
 *  缩放图片最大尺寸- 默认为 CGSize(1280, 1280)
 */
@property (nonatomic) CGSize scaleAspectFitSize;


/**
 *  缩放图片比例- 默认为 0.0f, 如果设定，则scaleAspectFitSize无效
 */
@property (nonatomic) CGFloat scale;


/**
 *  视频录制最大时长 单位:秒 默认为:60秒
 */
@property (nonatomic) NSInteger videoMaximumDuration;


/**
 *  录视频完成后的回调
 */
@property (nonatomic, copy) void (^pickVideoFinishBlock)(NSString* filePath, NSInteger fileSize, UIImage* thumbnail, NSInteger duration);


/**
 *  默认缓存目录-持久保存 默认 /Documents/Cache
 */
@property (nonatomic, copy) NSString* defaultCachePath;


/**
 *  选择最大时的回调 limit: 最大选择数 isAlert : 是否弹默认框 默认是 *isAlert = YES
 */
@property (nonatomic, copy) void (^seletedLimitBlock)(NSInteger limit, BOOL *isAlert);



/**
 *  裁切完成回调 image:切完后的图片
 */
@property (nonatomic, copy) void(^cropFinishBlock)(UIImage *image);

/**
 *  是否能用相册
 *
 *  @return BOOL
 */
+ (BOOL)isPhotosLibraryAvailable;

/**
 *  是否能用相机-拍照+录视频
 *
 *  @return BOOL
 */
+ (BOOL)isCameraAvailable;


/**
 *  显示imagePicker
 *
 *  @param viewController 调用者
 */
- (void)presentImagePickerInViewController:(UIViewController *)viewController;



@end
