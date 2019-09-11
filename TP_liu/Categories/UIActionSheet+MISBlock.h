//
//  UIActionSheet+Block.h
//  EDU
//
//  Created by mao on 3/11/15.
//  Copyright (c) 2015 EDU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface UIActionSheet(MISBlock)<UIActionSheetDelegate>

-(void)showInView:(UIView *)view
	   completion:(void (^)(NSInteger buttonIndex))completion;

-(void)showFromToolbar:(UIToolbar *)view
			completion:(void (^)(NSInteger buttonIndex))completion;

-(void)showFromTabBar:(UITabBar *)view
		   completion:(void (^)(NSInteger buttonIndex))completion;

-(void)showFromRect:(CGRect)rect
			 inView:(UIView *)view
		   animated:(BOOL)animated
		 completion:(void (^)(NSInteger buttonIndex))completion;

-(void)showFromBarButtonItem:(UIBarButtonItem *)item
					animated:(BOOL)animated
				  completion:(void (^)(NSInteger buttonIndex))completion;

@end
