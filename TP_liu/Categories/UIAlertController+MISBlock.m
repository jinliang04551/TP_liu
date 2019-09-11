//
//  UI+MISBlock.m
//  ZHTY
//
//  Created by Mao on 2018/4/20.
//  Copyright © 2018 Eduapp. All rights reserved.
//

#import "UIAlertController+MISBlock.h"

NS_ASSUME_NONNULL_BEGIN
@implementation UIAlertController(MISBlock)

/**
 * create instance of alert controller with actionSheet style.
 * @title title of actionSheet
 * @completion callback
 * @cancelButtonTitle cancelButtonTitle of actionSheet
 * @destructiveButtonTitle destructiveButtonTitle of actionSheet
 */
+ (UIAlertController *)mis_actionSheetControllerWithTitle:(nullable NSString *)title
											   completion:(nullable void(^)(NSInteger buttonIndex))completion
										cancelButtonTitle:(nullable NSString *)cancelButtonTitle
								   destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
										otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
	//instance one
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
																		message:nil
																 preferredStyle:UIAlertControllerStyleActionSheet];
	NSInteger buttonIndex = 0;
	
	//mutable args
	if (otherButtonTitles) {
		UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			if (completion)
				completion(buttonIndex);
		}];
		[controller addAction:action];
		
		buttonIndex++;
		
		va_list list;
		va_start(list, otherButtonTitles);
		while (YES) {
			NSString *string = va_arg(list, NSString*);
			if (!string) {
				break;
			}
			UIAlertAction *action = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				if (completion)
					completion(buttonIndex);
			}];
			
			[controller addAction:action];
			buttonIndex++;
		}
		va_end(list);
	}
	
	//destructive action
	if (destructiveButtonTitle) {
		UIAlertAction *action = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			if (completion)
				completion(buttonIndex);
		}];
		
		[controller addAction:action];
		
		buttonIndex++;
	}
	
	//cancel action
	if (cancelButtonTitle) {
		UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			if (completion)
				completion(-1);
		}];
		
		[controller addAction:action];
	}
	
	return controller;
}

/**
 * create instance of alert controller with alert style.
 * @title title of alert
 * @message message of alert
 * @completion callback
 * @cancelButtonTitle cancelButtonTitle of alert
 * @destructiveButtonTitle destructiveButtonTitle of alert
 */
+ (UIAlertController *)mis_alertViewControllerWithTitle:(nullable NSString *)title
												message:(nullable NSString *)message
											 completion:(nullable void(^)(NSInteger buttonIndex))completion
									  cancelButtonTitle:(nullable NSString *)cancelButtonTitle
									  otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
	//instance one
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
																		message:message
																 preferredStyle:UIAlertControllerStyleAlert];
	NSInteger buttonIndex = 0;
	
	//mutable args
	if (otherButtonTitles) {
		UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			if (completion)
				completion(buttonIndex);
		}];
		[controller addAction:action];
		
		buttonIndex++;
		
		va_list list;
		va_start(list, otherButtonTitles);
		while (YES) {
			NSString *string = va_arg(list, NSString*);
			if (!string) {
				break;
			}
			UIAlertAction *action = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				if (completion)
					completion(buttonIndex);
			}];
			
			[controller addAction:action];
			buttonIndex++;
		}
		va_end(list);
	}
	
	//cancel action
	if (cancelButtonTitle) {
		UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			if (completion)
				completion(-1);
		}];
		
		[controller addAction:action];
	}
	
	return controller;
}

/*
 * present it in view controller for iPhone
 * @viewController target view controller which show actionsheet
 */
- (void)showInViewController:(nonnull UIViewController *)viewController {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		printf("%s\n", "API Misuse. Please Use -showInViewController:sourceView:sourceRect for iPad");
		return;
	}
	
	[viewController presentViewController:self animated:YES completion:nil];
}

/*
 * present it in view controller for iPad
 * @viewController target view controller which show actionsheet
 * @sourceView pin view
 * @sourceRect pin rect of view
 */
- (void)showInViewController:(nonnull UIViewController *)viewController
				  sourceView:(UIView *)sourceView
				  sourceRect:(CGRect)sourceRect {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		printf("%s\n", "API Misuse. Please Use -showInViewController for iPhone");
		return;
	}

	self.popoverPresentationController.sourceRect = sourceRect;
	self.popoverPresentationController.sourceView = sourceView;
	[viewController presentViewController:self animated:YES completion:nil];
}




@end

NS_ASSUME_NONNULL_END
