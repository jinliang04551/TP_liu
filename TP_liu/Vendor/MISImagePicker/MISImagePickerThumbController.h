/***********************************************************
 //  MISImagePickerThumbController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@class MISImagePickerAlbum;
@interface MISImagePickerThumbController : UIViewController

/**
 *  点完成的回调
 */
@property (nonatomic, copy) void (^selectedFinishBlock)(NSArray* images);

/**
 *  选择最大时的回调 limit: 最大选择数 isAlert : 是否弹默认框 默认是 *isAlert = YES
 */
@property (nonatomic, copy) void (^seletedLimitBlock)(NSInteger limit, BOOL *isAlert);

/**
 *  最多可选。
 */
@property (nonatomic) NSInteger maxImageCount;


/**
 *  缩放图片最大尺寸
 */
@property (nonatomic) CGSize scaleAspectFitSize;

/**
 *  缩放图片最小尺寸
 */
@property (nonatomic) CGSize minScaleAspectFillSize;

/**
 *  缩放图片比例
 */
@property (nonatomic) CGFloat scale;

/**
 *  初始化
 *
 *  @param album 指定album
 *
 *  @return id
 */
- (instancetype)initWithAlbum:(MISImagePickerAlbum *)album;



@end
