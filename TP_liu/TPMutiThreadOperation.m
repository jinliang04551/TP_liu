//
//  TPMutiThreadOperation.m
//  TP_liu
//
//  Created by liu on 2019/7/16.
//  Copyright © 2019 liu. All rights reserved.
//

#import "TPMutiThreadOperation.h"
#import <libkern/OSSpinLockDeprecated.h>


static TPMutiThreadOperation *instance = nil;
@implementation TPMutiThreadOperation
+ (instancetype)mutiThreadOperation {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)testFun {
    [self testLock];
    [self testSemphore];
}

- (void)testLock {
    [self testRecursiveLock];
    [self testSpinLock];
}

- (void)testRecursiveLock {
    NSSLog(@"%s",__func__);
    //    NSLock *lock = [[NSLock alloc] init];
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod) (int);
        RecursiveMethod = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"value = %d",value);
                sleep(1);
                RecursiveMethod(value -1);
            }
            [lock unlock];
        };
        RecursiveMethod(5);
    });
    
}


/**
 自旋锁
 */
- (void)testSpinLock {
    __block OSSpinLock theLock = OS_SPINLOCK_INIT;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&theLock);
        NSLog(@"需要线程同步的操作1 开始");
        sleep(3);
        NSLog(@"需要线程同步的操作1 结束");
        OSSpinLockUnlock(&theLock);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&theLock);
        sleep(1);
        NSLog(@"需要线程同步的操作2");
        OSSpinLockUnlock(&theLock);
        
    });
    
}

- (void)testSemphore {
//    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_CURRENT_QUEUE_LABEL);
//    dispatch_async(queue, ^{
//        NSLog(@"111:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"222:%@",[NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"333:%@",[NSThread currentThread]);
//    });
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(3);
        NSSLog(@"========1========= thread:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSSLog(@"========2========= thread:%@",[NSThread currentThread]);
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSSLog(@"========3========= thread:%@",[NSThread currentThread]);
    });
    
}


@end
