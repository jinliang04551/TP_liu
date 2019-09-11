/***********************************************************
 //  MISSelectedImagePreviewController.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISSelectedImagePreviewController : UIViewController

/**
 *  选中图片的数组-引用
 */
@property (nonatomic, strong) NSMutableArray* selectedImages;

/**
 *  当前显示的序号
 */
@property (nonatomic) NSInteger currentIndex;

/**
 *  图片删除操作时的回调
 */
@property (nonatomic, copy) void (^imageDidChangeBlock)(void);


@end
