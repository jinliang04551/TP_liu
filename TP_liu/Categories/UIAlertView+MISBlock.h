//
//  UIAlertView+Block.h
//  LNJXT
//
//  Created by MaoKebing on 4/16/15.
//  Copyright (c) 2015 Eduapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertView(MISBlock)<UIAlertViewDelegate>

- (void)showWithCompletion:(void(^)(NSInteger buttonIndex))completion;

@end
