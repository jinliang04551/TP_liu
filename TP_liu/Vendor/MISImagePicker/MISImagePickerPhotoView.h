/***********************************************************
 //  MISImagePickerPhotoView.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/


#import <UIKit/UIKit.h>

static CGFloat MISImagePickerPhotoViewPadding      = 10.0f;
static NSUInteger MISImagePickerPhotoViewTagOffset = 1000;

@interface MISImagePickerPhotoView : UIScrollView <UIScrollViewDelegate>

/**
 *  asset
 */
@property (nonatomic) id asset;

/**
 *  image
 */
@property (nonatomic) UIImage* image;

/**
 *  tap 回调
 */
@property (nonatomic, copy) void(^tapBlock)(void);

/**
 *  复用
 */
- (void)prepareForReuse;

@end
