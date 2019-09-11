
/***********************************************************
 //  MISImagePickerAlbumsController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISImagePickerCropPreviewViewController : UIViewController

/**
 *  输入图片
 */
@property (nonatomic, strong) UIImage* image;

/**
 *  裁切完成回调
 */
@property (nonatomic, copy) void(^cropFinishBlock)(UIImage *image);

@end