/***********************************************************
 //  MISImagePickerStyle.h
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import <UIKit/UIKit.h>

@interface MISImagePickerStyle : NSObject

/**
 *  定制选中图片正常
 *
 *  @return UIImage
 */
+ (UIImage *)checkBtnImage;

/**
 *  定制选中图片选中
 *
 *  @return UIImage
 */
+ (UIImage *)checkBtnHLImage;


/**
 *  预览界面返回按钮
 *
 *  @return UIImage
 */
+ (UIImage *)previewNavigationBackBtnImage;


/**
 *  定制删除图片选中
 *
 *  @return UIImage
 */
+ (UIImage *)deleteBtnImage;

/**
 *  选中数徽标颜色
 *
 *  @return UIColor
 */
+ (UIColor *)badgeLabelColor;

/**
 *  预览接钮字颜色
 *
 *  @return UIColor
 */
+ (UIColor *)previewBtnColor;

/**
 *  完成接钮字颜色
 *
 *  @return UIColor
 */
+ (UIColor *)finishBtnColor;


/**
 *  显示最多选中的提示框
 *
 *  @param count 最大数
 */
+ (void)showMaxSeleteAlertWithCount:(NSInteger )count;

@end
