//
//  MISPersonMan.m
//  TP_liu
//
//  Created by liu on 2020/8/11.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISPersonMan.h"

@implementation MISPersonMan
+ (void)load {
    NSSLog(@"%s",__func__);
}

+ (void)initialize {
    NSSLog(@"%s",__func__);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"%@",NSStringFromClass([self class]));
        NSLog(@"%@",NSStringFromClass([super  class]));

    }
    return self;
}
@end
