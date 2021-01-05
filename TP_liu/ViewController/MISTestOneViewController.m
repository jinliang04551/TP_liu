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
//    self.view.backgroundColor = UIColor.yellowColor;
    
    self.viewA = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    self.viewA.backgroundColor = UIColor.cyanColor;
    self.viewB = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.viewB.backgroundColor = UIColor.redColor;
    
    NSLog(@"%s viewA.bound:%@",__func__,NSStringFromCGRect(self.viewA.bounds));
    NSLog(@"%s viewB.bound:%@",__func__,NSStringFromCGRect(self.viewB.bounds));

//    [self.viewA addSubview:self.viewB];
//    [self.view addSubview:self.viewA];
    
    [self testPerson];
}

- (void)testPerson {
    id cls = [MISPerson class];
    NSLog(@"cls:%@",cls);
    void *obj = &cls;
    NSLog(@"obj:%@",obj);

    
    [(__bridge id)obj speak];
    
//    NSLog(@"ViewController = %@ , 􏱊􏱋 = %p", self, &self);
//    id cls = [MISPerson class];
//    NSLog(@"MISPerson class = %@ 􏱊􏱋 = %p", cls, &cls);
//    void *obj = &cls;
//    NSLog(@"Void *obj = %@ 􏱊􏱋 = %p", obj,&obj);
//    [(__bridge id)obj speak];
//
//    MISPerson *p1 = [[MISPerson alloc] init];
//    [p1 speak];
//    NSLog(@"p1= %@ 􏱊􏱋 = %p", p1,&p1);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frameA = self.viewA.frame;
        frameA.size.width = 200.0;
        frameA.size.height = 200.0;
        self.viewA.frame = frameA;
        CGRect boundA = self.viewA.bounds;
        boundA.origin.x = 10.0;
        boundA.origin.y = 10.0;
        self.viewA.bounds = boundA;
        
        NSLog(@"after viewA.bound:%@",NSStringFromCGRect(self.viewA.bounds));
        NSLog(@"viewB.bound:%@",NSStringFromCGRect(self.viewB.bounds));
        
        NSLog(@"after viewA.frame:%@",NSStringFromCGRect(self.viewA.frame));
        NSLog(@"viewB.frame:%@",NSStringFromCGRect(self.viewB.frame));
    }];
    
}
@end
