//
//  MISTestTwoViewController.m
//  TP_liu
//
//  Created by liujinliang on 2020/8/29.
//  Copyright © 2020 liu. All rights reserved.
//

#import "MISTestTwoViewController.h"

@interface MISTestTwoViewController ()
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) NSString *str;

@end

@implementation MISTestTwoViewController

- (void)viewDidLoad {
    self.str = @"111";
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        __strong typeof(self) strongSelf = weakSelf;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", strongSelf.str);
        });
    };
    self.block();
}

@end
