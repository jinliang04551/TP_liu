//
//  MISTestBlockView.m
//  ZHTY
//
//  Created by liu on 2018/5/31.
//  Copyright © 2018年 Eduapp. All rights reserved.
//

#import "MISTestBlockView.h"


@implementation MISTestBlockView

- (void)testFunc {
    
    int  i = 10;
    NSString *strongStr = @"123_string";
    __block int a = 1;
    void (^testBlock)(void) = ^{
        int c = i + a;
        NSLog(@"c:%@",@(c));
        NSLog(@"strongStr:%@",strongStr);
    };
    a = 2;
    testBlock();
}

@end
