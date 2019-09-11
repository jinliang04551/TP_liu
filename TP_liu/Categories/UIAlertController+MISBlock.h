//
//  UI+MISBlock.h
//  ZHTY
//
//  Created by Mao on 2018/4/20.
//  Copyright © 2018 Eduapp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController(MISBlock)

/**
 * create instance of alert controller with actionSheet style.
 * @title title of actionSheet
 * @completion callback
 * @cancelButtonTitle cancelButtonTitle of actionSheet
 * @destructiveButtonTitle destructiveButtonTitle of actionSheet
 */
+ (instancetype)mis_actionSheetControllerWithTitle:(nullable NSString *)title
											   completion:(nullable void(^)(NSInteger buttonIndex))completion
										cancelButtonTitle:(nullable NSString *)cancelButtonTitle
								   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
										otherButtonTitles:(nullable NSString *)otherButtonTitles, ... ;


/**
 * create instance of alert controller with alert style.
 * @title title of alert
 * @message message of alert
 * @completion callback
 * @cancelButtonTitle cancelButtonTitle of alert
 * @destructiveButtonTitle destructiveButtonTitle of alert
 */
+ (instancetype)mis_alertViewControllerWithTitle:(nullable NSString *)title
												message:(nullable NSString *)message
											 completion:(nullable void(^)(NSInteger buttonIndex))completion
									  cancelButtonTitle:(nullable NSString *)cancelButtonTitle
									  otherButtonTitles:(nullable NSString *)otherButtonTitles, ... ;

/*
 * present it in view controller for iPhone
 * @viewController target view controller which show actionsheet
 */
- (void)showInViewController:(nonnull UIViewController *)viewController;

/*
 * present it in view controller for iPad
 * @viewController target view controller which show actionsheet
 * @sourceView pin view
 * @sourceRect pin rect of view
 */
- (void)showInViewController:(nonnull UIViewController *)viewController
				  sourceView:(UIView *)sourceView
				  sourceRect:(CGRect)sourceRect;

@end

NS_ASSUME_NONNULL_END
