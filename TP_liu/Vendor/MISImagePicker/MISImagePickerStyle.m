/***********************************************************
 //  MISImagePickerStyle.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerStyle.h"

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#endif

@implementation MISImagePickerStyle

/**
 *  定制选中图片正常
 *
 *  @return UIImage
 */
+ (UIImage *)checkBtnImage {
	return [UIImage imageNamed:@"MISImagePicker.bundle/mis_photo_thumb_check"];
}

/**
 *  定制选中图片选中
 *
 *  @return UIImage
 */
+ (UIImage *)checkBtnHLImage {
	return [UIImage imageNamed:@"MISImagePicker.bundle/mis_photo_thumb_check_hl"];
}


/**
 *  预览界面返回按钮
 *
 *  @return UIImage
 */
+ (UIImage *)previewNavigationBackBtnImage {
	return [UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_button_back"];
}

/**
 *  定制删除图片选中
 *
 *  @return UIImage
 */
+ (UIImage *)deleteBtnImage {
//	return @"MISNavigationButtonAdd";
	return nil;
}

/**
 *  选中数徽标颜色
 *
 *  @return UIColor
 */
+ (UIColor *)badgeLabelColor {
	return UIColorFromRGB(0x3289E4);
}

/**
 *  预览接钮字颜色
 *
 *  @return UIColor
 */
+ (UIColor *)previewBtnColor {
	return [UIColor blackColor];
}

/**
 *  预览接钮字不可用时的颜色
 *
 *  @return UIColor
 */
+ (UIColor *)previewBtnDisableColor {
	return [UIColor lightGrayColor];
}

/**
 *  完成接钮字颜色
 *
 *  @return UIColor
 */
+ (UIColor *)finishBtnColor {
	return UIColorFromRGB(0x3289E4);
}

/**
 *  显示最多选中的提示框
 *
 *  @param count 最大数
 */
+ (void)showMaxSeleteAlertWithCount:(NSInteger )count {
	NSString* title = [NSString stringWithFormat:@"你最多只能选择%@张照片", @(count)];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
	[alert show];
}


@end
