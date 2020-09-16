//
//  MISTestOneViewController.m
//  TP_liu
//
//  Created by liu on 2020/8/11.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISTestOneViewController.h"
#import "MISPerson.h"

@interface MISTestOneViewController ()
@property (nonatomic,strong)UIView *viewA;
@property (nonatomic,strong)UIView *viewB;

@end

@implementation MISTestOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    
    self.viewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 500)];
    self.viewA.backgroundColor = UIColor.cyanColor;
    self.viewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    self.viewB.backgroundColor = UIColor.redColor;
    
    [self.viewA addSubview:self.viewB];
    [self.view addSubview:self.viewA];
    
    [self testPerson];
}

- (void)testPerson {
//    id cls = [MISPerson class];
//    NSLog(@"cls:%@",cls);
//    void *obj = &cls;
//    NSLog(@"obj:%@",obj);
//
//    [(__bridge id)obj speak];
    
    NSLog(@"ViewController = %@ , 􏱊􏱋 = %p", self, &self);
    id cls = [MISPerson class];
    NSLog(@"MISPerson class = %@ 􏱊􏱋 = %p", cls, &cls);
    void *obj = &cls;
    NSLog(@"Void *obj = %@ 􏱊􏱋 = %p", obj,&obj);
    [(__bridge id)obj speak];
    
    MISPerson *p1 = [[MISPerson alloc] init];
    [p1 speak];
    NSLog(@"p1= %@ 􏱊􏱋 = %p", p1,&p1);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
