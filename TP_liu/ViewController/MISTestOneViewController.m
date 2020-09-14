//
//  MISTestOneViewController.m
//  TP_liu
//
//  Created by liu on 2020/8/11.
//  Copyright © 2020年 liu. All rights reserved.
//

#import "MISTestOneViewController.h"

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
