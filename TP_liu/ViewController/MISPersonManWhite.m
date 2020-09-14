//
//  MISPersonManWhite.m
//  TP_liu
//
//  Created by liu on 2020/8/24.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISPersonManWhite.h"

@implementation MISPersonManWhite

- (void)testLog {
    NSLog(@"%s self.class:%@ super.class:%@ super.super.class:%@",__func__,NSStringFromClass(self.class),NSStringFromClass(self.superclass),NSStringFromClass(self.superclass.superclass));
}


@end
