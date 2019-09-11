//
//  UIViewController+MISHUD.m
//  MIS
//
//  Created by mao on 1/24/15.
//  Copyright (c) 2015 EDU. All rights reserved.
//

#import "UIViewController+MISHUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController(MISHUD)


- (void)showSucessMessage:(NSString *)message {
	[self hideWait];
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.customView = [[UIImageView alloc]
					  initWithImage:[UIImage imageNamed:@"hud_success"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = message;
	hud.minShowTime = 1.0;
	hud.removeFromSuperViewOnHide = YES;
	[hud show:YES];
	[hud hide:YES];
}


- (void)showInfoMessage:(NSString *)message {
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	
	if ([self.view isKindOfClass:[UIWindow class]])
	{
		CGRect frame = hud.frame;
		frame.size.height -= 64.0;
		frame.origin.y += 64.0;
		hud.frame = frame;
	}
	
	[self.view addSubview:hud];
	hud.customView = [[UIImageView alloc]
					  initWithImage:[UIImage imageNamed:@"hud_info"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = message;
	hud.minShowTime = 1.0;
	hud.removeFromSuperViewOnHide = YES;
	[hud show:YES];
	[hud hide:YES];
}

- (void)showErrorMessage:(NSString *)message {
	[self hideWait];
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	hud.customView = [[UIImageView alloc]
					  initWithImage:[UIImage imageNamed:@"hud_error"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = message;
	hud.minShowTime = 1.0;
	hud.removeFromSuperViewOnHide = YES;
	[hud show:YES];
	[hud hide:YES];
}

- (void)showWaitMessage:(NSString *)message {
	UIView *viewToRemove = nil;
	for (UIView *v in [self.view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewToRemove = v;
		}
	}
	if (viewToRemove != nil) {
		MBProgressHUD *hud = (MBProgressHUD *)viewToRemove;
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:NO];
	}
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	hud.labelText = message;
	hud.mode = MBProgressHUDModeIndeterminate;
	
	[self.view addSubview:hud];
	[hud show:YES];
    [hud hide:YES afterDelay:60];
}

- (void)showWait {
	[self showWaitMessage:@"加载中..."];
}

- (void)hideWait {
	UIView *viewToRemove = nil;
	for (UIView *v in [self.view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewToRemove = v;
		}
	}
	if (viewToRemove != nil) {
		MBProgressHUD *hud = (MBProgressHUD *)viewToRemove;
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES];
	}
}

@end
