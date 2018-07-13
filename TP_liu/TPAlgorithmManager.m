
//
//  TPAlgorithmManager.m
//  TP_liu
//
//  Created by liu on 2018/6/4.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TPAlgorithmManager.h"
#import "algorithm.h"

@implementation TPAlgorithmManager
+ (instancetype)manager {
    static TPAlgorithmManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)testAlgorithm {
    [self testBubbleSort];
    [self testQuickSort];
}


- (void)testBubbleSort {
    NSLog(@"%s",__func__);

    int a[] = {23,33,90,29,11,5,45,67};
    int ArrLength = sizeof(a) / sizeof(int);
    bubbleSort(a, ArrLength);
    for (int i = 0; i < ArrLength; ++i) {
        printf("i:%d value:%d\n",i,a[i]);
    }
    
}


- (void)testQuickSort {
    NSLog(@"%s",__func__);
    int a[] = {23,33,90,29,11,5,45,67};
    int len = sizeof(a) / sizeof(int);
    quick_sort(a, 0, len - 1);
    for (int i = 0; i < len; ++i) {
        printf("i:%d value:%d\n",i,a[i]);
    }
    
   int pos = binarySearch(a, len, 29);
    printf("pos:%d \n",pos);

}



@end
