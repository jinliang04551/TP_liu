
/***********************************************************
 //  MISImagePickerAlbum.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISImagePickerAlbum : NSObject
/**
 *  相册标题
 */
@property (nonatomic, copy) NSString* title;

/**
 *  相册封面图
 */
@property (nonatomic, strong) UIImage* posterImage;

/**
 *  相册资源列表
 */
@property (nonatomic, copy) NSArray* assets;

@end


