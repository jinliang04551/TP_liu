//
//  ViewController.m
//  TP_liu
//
//  Created by liu on 2018/5/31.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ViewController.h"
#import "MISTestBlockView.h"
#import "TPTestDrawView.h"
#import "TPConfig.h"
#import <objc/objc.h>
#import <objc/runtime.h>

//信号量机制article
/*
 *
 * https://www.jianshu.com/p/05be855d654d
 */

@interface HLThread : NSThread

@end

@implementation HLThread

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end


@interface ViewController ()
@property (nonatomic, strong)HLThread *subThread;
@property (nonatomic, assign)NSInteger count;

@end

@implementation ViewController
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(jkviewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class,originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class,swizzledSelector);
        
        //judge the method named  swizzledMethod is already existed.
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        // if swizzledMethod is already existed.
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)jkviewDidLoad {
    NSLog(@"替换的方法");
    
    [self jkviewDidLoad];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    NSLog(@"%p",self.view);

  
//    MISTestBlockView *blockView = [MISTestBlockView new];
//    [blockView testFunc];
    
//    [self testFunc];
//    [self asyncMain];
//    [self testOperationQueue];
//    [self threadTest];
//    [self testNSTimer];
    
//    [self testDrawMutiPathView];
    
//    NSLog(@"%@",NSHomeDirectory());
    
//    [self asyn_barrier];
//    [self testGroup];
    
//    [self testSinal];
    
//    [self testSingal2];
    
<<<<<<< HEAD
//    NSSLog(@"========1=====");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        sleep(1);
//        NSSLog(@"========2=====");
//        sleep(1);
//        NSSLog(@"========3=====");
//
//    });
//
//    NSSLog(@"========4=====");
//    sleep(2);
//    NSSLog(@"========5=====");
//
//    NSSLog(@"========6=====");

//    [self testCopyMutableCopy];
    
    [self testString];

=======
//    [self testCopyMutableCopy];
>>>>>>> 333bb04ab6f6f7981527c917b34109f8fec995e0
}

- (void)testCopyMutableCopy {
    NSString *str1 = @"abc";
    NSString *str2 = [str1 copy];
    NSString *str3 = [str1 mutableCopy];
    NSMutableString *str4 = [str1 copy];
    NSMutableString *str5 = [str1 mutableCopy];
    
    NSSLog(@"str1 address:%p", str1);
    NSSLog(@"str2 address:%p", str2);
    NSSLog(@"str3 address:%p", str3);
    NSSLog(@"str4 address:%p", str4);
    NSSLog(@"str5 address:%p", str5);

}


- (void)testNSLocale {
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *currentCode  = local.currencyCode;
    NSString *countryCode = local.countryCode;
    NSSLog(@"currentCode:%@",currentCode);
    NSSLog(@"NSArray:%@",countryCode);

}

- (void)testDrawMutiPathView {
    TPTestDrawView *drawView = [[TPTestDrawView alloc] initWithFrame:CGRectMake(0, 0, 400.0, 300.0f)];
    [self.view addSubview:drawView];
}

- (void)testString {

    NSString *str1 = @"abc";
    NSString *str2 = @"abc";
    NSString *str3 = [[NSString alloc] initWithFormat:@"abc"];
    NSString *str31 = [[NSString alloc] initWithString:@"abc"];
    NSString *str4 = [str1 copy];
    NSString *str5 = [str1 mutableCopy];
    NSString *str6 = [NSString stringWithString:@"abc"];
    NSString *str61 = [NSString stringWithFormat:@"abc"];
    NSMutableString *mustr1 = [NSMutableString stringWithString:@"123"];
    NSString *str7 = [mustr1 copy];
    NSString *str8 = mustr1;
    [mustr1 appendString:@"456"];
    
    NSMutableString *str9 = [NSMutableString stringWithString:@"abc"];
    NSString *str10 = [[NSMutableString alloc] initWithString:@"abc"];
    NSString *str11 = [[NSMutableString alloc] initWithString:@"abc"];

    
    NSLog(@"str1 address: %p",str1);
    NSLog(@"str2 address: %p",str2);
    NSLog(@"str3 address: %p",str3);
    NSLog(@"str31 address: %p",str31);
    NSLog(@"str4 address: %p",str4);
    NSLog(@"str5 address: %p",str5);
    NSLog(@"str6 address: %p",str6);
    NSLog(@"str61 address: %p",str61);
    NSLog(@"str7 address: %p value:%@",str7,str7);
    NSLog(@"str8 address: %p value:%@",str8,str8);
    NSLog(@"mustr1 address: %p value:%@",mustr1,mustr1);
    NSLog(@"str9 address: %p",str9);
    NSLog(@"str10 address: %p",str10);
    NSLog(@"str11 address: %p",str11);

    
}

- (void)testNSTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [timer fire];
}

- (void)timerUpdate
{
    NSLog(@"当前线程：%@",[NSThread currentThread]);
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    //    NSLog(@"currentRunLoop:%@",[NSRunLoop currentRunLoop]);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.count ++;
        NSString *timerText = [NSString stringWithFormat:@"计时器:%ld",self.count];
        NSLog(@"timerText：%@",timerText);
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(subThreadOpetion) onThread:self.subThread withObject:nil waitUntilDone:NO];
    [self performSelector:@selector(testSelWithObj:obj2:) withObject:@"1" withObject:@(2)];
    
}

- (void)testSelWithObj:(id)obj1 obj2:(id)obj2 {
    NSLog(@"obj1:%@ obj2:%@",obj1, obj2);
}

- (void)threadTest
{
    HLThread *subThread = [[HLThread alloc] initWithTarget:self selector:@selector(subThreadEntryPoint) object:nil];
    [subThread setName:@"HLThread"];
    [subThread start];
    self.subThread = subThread;
}

/**
 子线程启动后，启动runloop
 */
- (void)subThreadEntryPoint
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

    //如果注释了下面这一行，子线程中的任务并不能正常执行
    [runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
    NSLog(@"启动RunLoop前--%@",runLoop.currentMode);

    [runLoop run];
}

/**
 子线程任务
 */
- (void)subThreadOpetion
{
    NSLog(@"启动RunLoop后--%@",[NSRunLoop currentRunLoop].currentMode);
    NSLog(@"%@----子线程任务开始",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:3.0];
    NSLog(@"%@----子线程任务结束",[NSThread currentThread]);
}


- (void)testFunc {
    /** 方法一，需要start */
NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:@"NSThread1"];
    // 线程加入线程池等待CPU调度，时间很快，几乎是立刻执行
    [thread1 start];

    /** 方法二，创建好之后自动启动 */
    [NSThread detachNewThreadSelector:@selector(doSomething2:) toTarget:self withObject:@"NSThread2"];

    /** 方法三，隐式创建，直接启动 */
   [self performSelectorInBackground:@selector(doSomething3:) withObject:@"NSThread3"];

}

- (void)testOperationQueue {
    // 创建队列，默认并发
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 创建操作，NSInvocationOperation
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAddOperation) object:nil];
    // 创建操作，NSBlockOperation
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"addOperation把任务添加到队列======%@", [NSThread currentThread]);
        }
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@" addExecutionBlock 1把任务添加到队列======%@", [NSThread currentThread]);
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@" addExecutionBlock 2把任务添加到队列======%@", [NSThread currentThread]);
    }];
    
//    [invocationOperation start];
//    [blockOperation start];
    
    [queue addOperation:invocationOperation];
    [queue addOperation:blockOperation];
    
    [queue cancelAllOperations];
    
}


- (void)invocationOperationAddOperation {
    NSLog(@"invocationOperation===aaddOperation把任务添加到队列====%@", [NSThread currentThread]);
}

/** 主队列同步 */
- (void)syncMain {
    
    NSLog(@"\n\n**************主队列同步，放到主线程会死锁***************\n\n");
    
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列同步3   %@",[NSThread currentThread]);
        }
    });
}

/** 主队列异步 */
- (void)asyncMain {
    
    NSLog(@"\n\n**************主队列异步***************\n\n");
    
    // 主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步1   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"主队列异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步3   %@",[NSThread currentThread]);
        }
    });
    
}

- (void)asyn_barrier {
    dispatch_queue_t queue = dispatch_queue_create("test",DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"栅栏 并发异步1%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"栅栏 并发异步2%@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"栅栏 并发异步%@",[NSThread currentThread]);
        NSSLog(@"3,4一定是在1，2之后");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"栅栏 并发异步3%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; ++i) {
            NSLog(@"栅栏 并发异步4%@",[NSThread currentThread]);
        }
    });
    
}

- (void)testGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组1：有一个耗时操作完成！");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组2：有一个耗时操作完成！");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"刷新UI");
    });
}

- (void)testSinal {
    //创建一个为1信号量的信号
    // 打印输出：<OS_dispatch_semaphore: semaphore[0x174099b40] = { xrefcnt = 0x1, refcnt = 0x1, port = 0x0, value = 1, orig = 1 }>
    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
    
    __block long x = 0;
    NSLog(@"0_x:%ld",x);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        NSLog(@"waiting");
        
        //此时信号量为0 对signal增加1 信号量变为1，
        x = dispatch_semaphore_signal(signal);
        NSLog(@"1_x:%ld",x);
        
        sleep(2);
        NSLog(@"waking");
        
        x = dispatch_semaphore_signal(signal);
        NSLog(@"2_x:%ld",x);
    });
    
    //此时信号量为1 所以执行下边，对signal减掉1，然后信号量为0
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSLog(@"3_x:%ld",x);
    
    //此时信号量为0，永远等待，在等待的时候执行block了，在等待block时候block内对信号量增加了1，然后开始执行下边，并且信号量再次减掉1 变为0
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    NSLog(@"wait 2");
    NSLog(@"4_x:%ld",x);
    
    //此时信号量为0，永远等待，在等待的时候执行block了，在等待block时候block内对信号量增加了1，然后开始执行下边，并且信号量再次减掉1 变为0
    x = dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    
    NSLog(@"wait 3");
    NSLog(@"5_x:%ld",x);
    
    sleep(2);
    
    x = dispatch_semaphore_signal(signal);
    NSLog(@"6_x:%ld",x);
    
}

- (void)testSingal2 {
    
}


- (void)doSomething1:(NSObject *)object {
       // 传递过来的参数
    NSLog(@"%@",object);
    NSLog(@"doSomething1：%@",[NSThread currentThread]);
}

- (void)doSomething2:(NSObject *)object {
      NSLog(@"%@",object);
      NSLog(@"doSomething2：%@",[NSThread currentThread]);
}

- (void)doSomething3:(NSObject *)object {
     NSLog(@"%@",object);
     NSLog(@"doSomething3：%@",[NSThread currentThread]);
}

- (void)testAsynQueue {
    NSSLog(@"========1=====");
    dispatch_async(dispatch_get_main_queue(), ^{
        sleep(1);
        NSSLog(@"========2=====");
        sleep(1);
        NSSLog(@"========3=====");
        
    });
    
    NSSLog(@"========4=====");
    sleep(2);
    NSSLog(@"========5=====");
    
    NSSLog(@"========6=====");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
