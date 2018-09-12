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
//    [self testString];
    
//    [self testDrawMutiPathView];
    
//    NSLog(@"%@",NSHomeDirectory());
    
    NSSLog(@"++++1+++++");

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSSLog(@"++++2+++++");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSSLog(@"++++3+++++");
        });
        NSSLog(@"++++4+++++");

    });
    NSSLog(@"++++5+++++");

}



- (void)testDrawMutiPathView {
    TPTestDrawView *drawView = [[TPTestDrawView alloc] initWithFrame:CGRectMake(0, 0, 400.0, 300.0f)];
    [self.view addSubview:drawView];
}

- (void)testString {

    NSString *str1 = @"abc";
    NSString *str2 = @"abc";
    NSString *str3 = [[NSString alloc] initWithFormat:@"abc"];
    NSString *str4 = [str1 copy];
    NSString *str5 = [str1 mutableCopy];
    NSString *str6 = [NSString stringWithString:@"abc"];

    NSMutableString *mustr1 = [NSMutableString stringWithString:@"123"];
    NSString *str7 = [mustr1 copy];
    NSString *str8 = mustr1;
    [mustr1 appendString:@"456"];
    
    
    
    NSLog(@"str1 address: %p",str1);
    NSLog(@"str2 address: %p",str2);
    NSLog(@"str3 address: %p",str3);
    NSLog(@"str4 address: %p",str4);
    NSLog(@"str5 address: %p",str5);
    NSLog(@"str6 address: %p",str6);
    NSLog(@"str7 address: %p value:%@",str7,str7);
    NSLog(@"str8 address: %p value:%@",str8,str8);
    NSLog(@"mustr1 address: %p value:%@",mustr1,mustr1);


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
//    /** 方法一，需要start */
//NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:@"NSThread1"];
//    // 线程加入线程池等待CPU调度，时间很快，几乎是立刻执行
//    [thread1 start];
//
//    /** 方法二，创建好之后自动启动 */
//    [NSThread detachNewThreadSelector:@selector(doSomething2:) toTarget:self withObject:@"NSThread2"];
//
//    /** 方法三，隐式创建，直接启动 */
//   [self performSelectorInBackground:@selector(doSomething3:) withObject:@"NSThread3"];

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
    
    [queue addOperation:invocationOperation];
    [queue addOperation:blockOperation];
}


- (void)invocationOperationAddOperation {
    NSLog(@"invocationOperation===aaddOperation把任务添加到队列====%@", [NSThread currentThread]);
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
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步2   %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            NSLog(@"主队列异步3   %@",[NSThread currentThread]);
        }
    });
    
}

-(void)doSomething1:(NSObject *)object {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
