//
//  MISTestClass.m
//  TP_liu
//
//  Created by liu on 2020/1/19.
//  Copyright © 2020 liu. All rights reserved.
//

#import "MISTestClass.h"


@implementation MISTestClass

+(void)load {
    NSLog(@"%s",__func__);
}
+ (void)initialize {
    NSLog(@"%s",__func__);
}

- (void)startFun {
    NSLog(@"%s",__func__);
}

@end

@implementation MISTestClassSubA
+(void)load {
    NSLog(@"%s",__func__);
}
+ (void)initialize {
    NSLog(@"%s",__func__);
}

- (void)startFun {
    NSLog(@"%s",__func__);
}

@end

@implementation MISTestClassSubB
+(void)load {
    NSLog(@"%s",__func__);
}
+ (void)initialize {
    NSLog(@"%s",__func__);
}

- (void)startFun {
    NSLog(@"%s",__func__);
}

@end

@implementation MISTestClass (Start)
+(void)load {
    NSLog(@"%s",__func__);
}
- (void)startFun {
    NSLog(@"%s",__func__);
}
@end

@implementation MISTestClassSubA (Start)
+(void)load {
    NSLog(@"%s",__func__);
}
- (void)startFun {
    NSLog(@"%s",__func__);
}
@end

@implementation MISTestClassSubB (Start)
+(void)load {
    NSLog(@"%s",__func__);
}
- (void)startFun {
    NSLog(@"%s",__func__);
}
@end
