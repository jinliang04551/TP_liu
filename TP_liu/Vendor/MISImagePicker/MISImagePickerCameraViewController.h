
/***********************************************************
 //  MISImagePickerAlbumsController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISImagePickerCameraViewController : UIViewController

/**
 *  裁切完成回调
 */
@property (nonatomic, copy) void(^cropFinishBlock)(UIImage *image);

@end

