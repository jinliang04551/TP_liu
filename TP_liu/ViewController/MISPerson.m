//
//  MISPerson.m
//  TP_liu
//
//  Created by liu on 2020/8/11.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISPerson.h"


@implementation MISPerson
+ (void)load {
    NSSLog(@"%s",__func__);
}

+ (void)initialize {
    NSSLog(@"%s",__func__);
}

- (instancetype)init {
    self = [super init];
    NSLog(@"%s [self class]:%@",__func__,NSStringFromClass([self class]));
    NSLog(@"%s [super  class]:%@",__func__,NSStringFromClass([super  class]));

    return self;
}

- (void)speak {
    NSLog(@"%s self.name:%@",__func__,self.name);
//    NSLog(@"%s",__func__);

}


@end
