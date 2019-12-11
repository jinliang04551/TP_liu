//
//  MISTestListTableViewController.m
//  TP_liu
//
//  Created by liu on 2019/9/10.
//  Copyright © 2019 liu. All rights reserved.
//

#import "MISTestListTableViewController.h"
#import "MISTestBlockView.h"
#import "TPTestDrawView.h"
#import "TPConfig.h"
#import <objc/objc.h>
#import <objc/runtime.h>
#import "TPAlgorithmManager.h"
#import "TPMutiThreadOperation.h"


#define ItemTitleKey @"title"

#define ItemActionKey @"action"

@interface HLThread : NSThread

@end

@implementation HLThread
- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end


static NSString *UITableViewCellIndetifier = @"UITableViewCell";

@interface MISTestListTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;
//列表项
@property (nonatomic,strong)NSArray *items;

@property (nonatomic, assign)NSInteger count;

@property (nonatomic, strong)HLThread *subThread;

@end


@implementation MISTestListTableViewController
+ (void)load {
    NSSLog(@"%s",__func__);
}

+ (void)initialize {
    NSSLog(@"%s",__func__);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITE_COLOR;
    
    self.title = @"列表";
    [self.view addSubview:self.table];
    [self prepareItems];
    [self.table reloadData];
}


- (void)prepareItems {
    NSMutableArray *tempItems = [NSMutableArray array];
    [tempItems addObject:@{ItemTitleKey:@"地区",ItemActionKey:NSStringFromSelector(@selector(testNSLocale))}];
    [tempItems addObject:@{ItemTitleKey:@"testCopyMutableCopy",ItemActionKey:NSStringFromSelector(@selector(testCopyMutableCopy))}];
    [tempItems addObject:@{ItemTitleKey:@"testNSTimer",ItemActionKey:NSStringFromSelector(@selector(testNSTimer))}];
    [tempItems addObject:@{ItemTitleKey:@"timerUpdate",ItemActionKey:NSStringFromSelector(@selector(timerUpdate))}];
    [tempItems addObject:@{ItemTitleKey:@"threadTest",ItemActionKey:NSStringFromSelector(@selector(threadTest))}];
    [tempItems addObject:@{ItemTitleKey:@"testFunc",ItemActionKey:NSStringFromSelector(@selector(testFunc))}];
    [tempItems addObject:@{ItemTitleKey:@"testOperationQueue",ItemActionKey:NSStringFromSelector(@selector(testOperationQueue))}];
    [tempItems addObject:@{ItemTitleKey:@"syncMain",ItemActionKey:NSStringFromSelector(@selector(syncMain))}];
    [tempItems addObject:@{ItemTitleKey:@"asyncMain",ItemActionKey:NSStringFromSelector(@selector(asyncMain))}];
     [tempItems addObject:@{ItemTitleKey:@"asyn_barrier",ItemActionKey:NSStringFromSelector(@selector(asyn_barrier))}];
     [tempItems addObject:@{ItemTitleKey:@"testSinal",ItemActionKey:NSStringFromSelector(@selector(testSinal))}];
    [tempItems addObject:@{ItemTitleKey:@"testGroup",ItemActionKey:NSStringFromSelector(@selector(testGroup))}];
    [tempItems addObject:@{ItemTitleKey:@"testAlgorithm",ItemActionKey:NSStringFromSelector(@selector(testAlgorithm))}];
    
     [tempItems addObject:@{ItemTitleKey:@"testMutiOpeation",ItemActionKey:NSStringFromSelector(@selector(testMutiOpeation))}];
    
    self.items = [tempItems copy];
    
}

#pragma mark private method
- (void)testNSLocale {
    NSLocale *local = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    if (@available(iOS 10.0, *)) {
        NSString *currentCode  = local.currencyCode;
        NSString *countryCode = local.countryCode;
        NSSLog(@"currentCode:%@ countryCode:%@",currentCode,countryCode);
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)testDrawMutiPathView {
    TPTestDrawView *drawView = [[TPTestDrawView alloc] initWithFrame:CGRectMake(0, 0, 400.0, 300.0f)];
    [self.view addSubview:drawView];
}

- (void)testCopyMutableCopy {
    NSSLog(@"%s",__func__);
    [self testStr];
    [self testMutbleStr];
    [self testArray];
    [self testMutableArray];
    [self copyAndMutableCopy];
}

- (void)testStr {
    NSSLog(@"%s",__func__);
    NSString *str = @"123";
    NSString *strCopy = [str copy];
    NSMutableString *mustr = [str copy];
    NSMutableString *muCopy = [str mutableCopy];
//    [mustr appendString:@"4"];    //会直接崩溃
    [muCopy appendString:@"5"];
    NSLog(@"str = %@    strCopy = %@    mustr = %@    muCopy = %@",str,strCopy,mustr,muCopy);
    NSLog(@"str地址%p    strCopy地址%p    mustr地址%p     muCopy地址%p",str ,strCopy,mustr,muCopy);
}

- (void)testMutbleStr {
    NSSLog(@"%s",__func__);
    
    NSMutableString *mustr = [NSMutableString stringWithFormat:@"123"];
    NSString *strCopy = [mustr copy];
    NSMutableString *mutableStr = [mustr copy];
    NSMutableString *mutableStrCopy = [mustr mutableCopy];
//    [mutableStr appendString:@"5"];    //会崩溃
    [mutableStrCopy appendString:@"6"];
    NSLog(@"mustr = %@  strCopy = %@  mutableStr = %@   mutableStrCopy = %@",mustr,strCopy,mutableStr,mutableStrCopy);
    NSLog(@"mustr地址%p    strCopy地址%p    mutableStr地址%p     mutableStrCopy地址%p",mustr,strCopy,mutableStr,mutableStrCopy);

}

- (void)testArray {
    NSSLog(@"%s",__func__);

    NSArray *array = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
    NSArray *arrayCopy = [array copy];
    NSMutableArray *muarray = [array copy];
    NSMutableArray *copyArray = [array mutableCopy];
    NSLog(@"array地址%p     arrayCopy地址%p      muarray地址%p     copyArray地址%p",array,arrayCopy,muarray,copyArray);
}

- (void)testMutableArray {
    NSSLog(@"%s",__func__);

    NSMutableArray *muarray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    NSArray *array = [muarray copy];
    NSArray *mutableCopy = [muarray mutableCopy];
    NSMutableArray *muCopy = [muarray copy];
    NSMutableArray *arrayCopy = [muarray mutableCopy];
    NSLog(@"muarray地址%p   array地址%p   mutableCopy地址%p   muCopy地址%p   arrayCpy地址%p",muarray,array,mutableCopy,muCopy,arrayCopy);
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
    NSThread  *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:@"NSThread1"];
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
        NSLog(@"队列组：有一个耗时操作完成！");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"队列组：有一个耗时操作完成！");
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

- (void)testAlgorithm {
    [[TPAlgorithmManager manager] testAlgorithm];

}

- (void)testMutiOpeation {
    [[TPMutiThreadOperation mutiThreadOperation] testFun];
}

- (void)copyAndMutableCopy {
    NSArray *array = [NSArray arrayWithObjects:[NSMutableString stringWithString:@"1"],@"2",@"3", nil];
    NSArray *arrayCopy = [array copy];
    NSArray *arrayMutableCopy = [array mutableCopy];
    NSMutableArray *mutableArrayCopy = [array copy];
    NSMutableArray *mutableArrayMutableCopy = [array mutableCopy];
    NSLog(@"array地址%p     arrayCopy地址%p      arrayMutableCopy地址%p     mutableArrayCopy地址%p    mutableArrayCopy地址%p",array,arrayCopy,arrayMutableCopy,mutableArrayCopy,mutableArrayMutableCopy);
    NSLog(@"array = %@   arrayCopy = %@    arrayMutableCopy = %@   mutableArrayCopy =  %@    mutableArrayCopy =  %@",array,arrayCopy,arrayMutableCopy,mutableArrayCopy,mutableArrayMutableCopy);
    
    NSMutableString *mustr = array[0];
    [mustr appendString:@"2"];
    NSLog(@"array地址%p     arrayCopy地址%p      arrayMutableCopy地址%p     mutableArrayCopy地址%p    mutableArrayCopy地址%p",array,arrayCopy,arrayMutableCopy,mutableArrayCopy,mutableArrayMutableCopy);
    NSLog(@"array = %@   arrayCopy = %@    arrayMutableCopy = %@   mutableArrayCopy =  %@    mutableArrayCopy =  %@",array,arrayCopy,arrayMutableCopy,mutableArrayCopy,mutableArrayMutableCopy);
}


- (void)doSomething1:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"%@",object);
    NSLog(@"doSomething1：%@",[NSThread currentThread]);
}

- (void)doSomething2:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"%@",object);
    NSLog(@"doSomething1：%@",[NSThread currentThread]);
}

- (void)doSomething3:(NSObject *)object {
    // 传递过来的参数
    NSLog(@"%@",object);
    NSLog(@"doSomething1：%@",[NSThread currentThread]);
}

#pragma mark - Table view data source && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellIndetifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UITableViewCellIndetifier];
    }
    NSDictionary *item = self.items[indexPath.row];
    NSString *title = item[ItemTitleKey];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *actionName = item[ItemActionKey];
    SEL action = NSSelectorFromString(actionName);
    [self performSelector:action];
    
}

#pragma mark getter and setter
- (UITableView*)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundView = nil;
        _table.rowHeight = 44.0;
        _table.backgroundColor = WHITE_COLOR;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellIndetifier];
    }
    return _table;
}


@end

#undef ItemTitleKey

#undef ItemActionKey

