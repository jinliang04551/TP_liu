//
//  MISDrawViewController.m
//  TP_liu
//
//  Created by liu on 2019/12/19.
//  Copyright © 2019年 liu. All rights reserved.
//

#import "MISDrawViewController.h"

@interface MISDrawViewController ()



@end

@implementation MISDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addGrid:self.view];
}

- (void)addGrid:(UIView *)view {
//    CGFloat widthView = view.frame.size.width;
//    CGFloat heightView = view.frame.size.height;
//    CGFloat size = 50;
//
//    void (^addLineWidthRect)(CGRect rect) = ^(CGRect rect) {
//        CALayer *layer = [[CALayer alloc] init];
//        [view.layer addSublayer:layer];
//        layer.frame = rect;
//        layer.backgroundColor = [[UIColor redColor] CGColor];
//    };
//
//    for (int i=0; i<widthView; i+=size) {
//        addLineWidthRect(CGRectMake(i, 0, 1, heightView));
//    }
//    for (int i=0; i<heightView; i+=size) {
//        addLineWidthRect(CGRectMake(0, i, widthView, 1));
//    }
    
    [self drawLine:self.view];
}


- (void)drawLine:(UIView*)view {
    CGFloat widthView = view.frame.size.width;
    CGFloat heightView = view.frame.size.height;
    CGFloat size = 50;

    UIBezierPath *pathLine = [UIBezierPath bezierPath];
    
    CGFloat startX = 100;
    CGFloat startY = 100;

    for (NSInteger i = 0; i < 10; ++i) {
        startY = size*i;
        [pathLine moveToPoint:CGPointMake(startX, startY)];
        [pathLine addLineToPoint:CGPointMake(startX+size, startY)];
    }
  
    for (NSInteger i = 0; i < 10; ++i) {
        startX = size*i;
        [pathLine moveToPoint:CGPointMake(startX, startY)];
        [pathLine addLineToPoint:CGPointMake(startX, startY+size)];
    }

    
//    void (^addLineWidthRect)(CGPoint rect,CGPoint rects) = ^(CGPoint rect,CGPoint rects) {
//        [pathLine moveToPoint:rect];
//        [pathLine addLineToPoint:rects];
//    };
//    for (int i=0; i<widthView; i+=size) {
//        addLineWidthRect(CGPointMake(i, 0),CGPointMake(i, heightView));
//    }
//    for (int i=0; i<heightView; i+=size) {
//        addLineWidthRect(CGPointMake(0, i),CGPointMake(widthView, i));
//    }
    CAShapeLayer *layerLine= [CAShapeLayer layer];
    layerLine.path=pathLine.CGPath;
    layerLine.lineWidth=0.5;
    layerLine.lineCap=kCALineCapRound;
    layerLine.strokeColor=[UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layerLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
