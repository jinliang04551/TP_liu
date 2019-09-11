/***********************************************************
 //  MISImagePickerPreviewController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISImagePickerBottomBar : UIView

@property (nonatomic) NSInteger count;

@property (nonatomic, copy) void (^confirmBlock)(void);
@property (nonatomic, copy) void (^previewBlock)(void);

@end

@interface MISImagePickerPreviewController : UIViewController <UIScrollViewDelegate>

/**
 *  图片的数组
 */
@property (nonatomic, copy) NSArray* assets;


/**
 *  选中图片的数组
 */
@property (nonatomic, strong) NSMutableArray* selectedAssets;

/**
 *  当前显示的序号
 */
@property (nonatomic) NSInteger currentIndex;


/**
 *  点完成的回调
 */
@property (nonatomic, copy) void (^selectedFinishBlock)(void);

/**
 *  选择最大时的回调 limit: 最大选择数 isAlert : 是否弹默认框 默认是 *isAlert = YES
 */
@property (nonatomic, copy) void (^seletedLimitBlock)(NSInteger limit, BOOL *isAlert);

/**
 *  最多可选
 */
@property (nonatomic) NSInteger maxImageCount;


@end

