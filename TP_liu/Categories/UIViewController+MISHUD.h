//
//  UIViewController+MISHUD.h
//  MIS
//
//  Created by mao on 1/24/15.
//  Copyright (c) 2015 EDU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(MISHUD)

- (void)showSucessMessage:(NSString *)message;
- (void)showInfoMessage:(NSString *)message;
- (void)showErrorMessage:(NSString *)message;
- (void)showWaitMessage:(NSString *)message;
- (void)showWait;
- (void)hideWait;

@end
