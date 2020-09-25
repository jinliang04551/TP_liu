//
//  main.m
//  TP_liu
//
//  Created by liu on 2018/5/31.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MISPerson.h"

int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
    @autoreleasepool {
        int res = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        NSSLog(@"-----");
        return res;
        NSSLog(@"%s",__func__);

    }

    
}
