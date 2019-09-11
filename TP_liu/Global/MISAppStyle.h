//
//  MISAppStyle.h
//  edua
//
//  Created by Mao on 9/6/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISAppStyle : NSObject

/**
 *  App整体的Style
 */
+ (void)setupStyle;


/**
 *  登出 红包button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)logoutBtnWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title;


/**
 *  登录-注册 黑色提示button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)loginNoteButtonWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title;

/**
 *  登录短button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)loginBtnWithTarget:(id)target
						  action:(SEL)action
						   title:(NSString *)title;


/**
 *  登录短button size
 *  @return UIButton
 */
+ (CGSize)loginBtnSize;

/**
 * 主题黑色
 */
+ (UIColor *)mainBlackColor;

/**
 * 主题橙色
 */
+ (UIColor *)mainOringeColor;

/**
 * 主题蓝色
 */
+ (UIColor *)mainBlueColor;

/**
 所有页面的背景的白色
 
 @return 白色
 */
+ (UIColor *)backgroundViewWhiteColor;

/**
 所有页面的背景的灰色

 @return 灰色
 */
+ (UIColor *)backgroundViewGrayColor;

/**
 边框的灰色
 */
+ (UIColor *)borderGrayColor;


+ (UIColor *)mainGrayColor;

/**
 *  通用 底部橙色button 样式
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)bottomOringeBtnWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title;


/**
 *  登录短button size
 *  @return UIButton
 */
+ (CGSize)bottomOringeBtnSize;


/**
 * 通用分割线颜色
 */
+ (UIColor *)separateLineColor;


+ (UIBarButtonItem *)navigationButtonWithImage:(UIImage *)image
										target:(id)target
										action:(SEL)action;


+ (UIBarButtonItem *)navigationButtonWithTitle:(NSString* )title
										target:(id)target
										action:(SEL)action;

@end
