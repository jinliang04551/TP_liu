//
//  MISPerson+TestLoad.m
//  TP_liu
//
//  Created by liu on 2020/8/11.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISPerson+TestLoad.h"

@implementation MISPerson (TestLoad)
+ (void)load {
    NSSLog(@"%s",__func__);
}

+ (void)initialize {
    NSSLog(@"%s",__func__);
}

- (void)printLog {
    NSSLog(@"%s",__func__);
}


@end
