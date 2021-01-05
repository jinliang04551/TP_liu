
//
//  TPAlgorithmManager.m
//  TP_liu
//
//  Created by liu on 2018/6/4.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TPAlgorithmManager.h"
#import "algorithm.h"
#import "TPConfig.h"
#import "SingleLinkList.h"
#include "CombineSort.h"

//#include <stdio.h>

#define BEGIN_HEART_BEAT_WARNING_RATIO 0.65
#define STOP_HEART_BEAT_WARNING_RATIO  0.60


@interface TPAlgorithmManager()


@end



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
//    [self testBubbleSort];
    [self testQuickSort];
    [self testSingleList];
    [self testGetMaxCountOfCharInString];
    [self testCombineSort];
}


- (float)sigmoidFunc:(int)x {
    float sigmoidValue = 1/(1 + expf(-x));
    NSSLog(@"%s sigmoidValue:%@",__func__,@(sigmoidValue));
    return  sigmoidValue;
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
    int a[] = {88,33,90,33,29,11,5,45,67};
    int len = sizeof(a) / sizeof(int);
    quick_sort(a, 0, len - 1);
    for (int i = 0; i < len; ++i) {
        printf("\n i:%d value:%d\n",i,a[i]);
    }
    
   int pos = binarySearch(a, len, 5);
    printf("\n pos:%d \n",pos);

}


- (void)testSingleList {
    NSSLog(@"==============================================");
    singleList_main();
//    [self testLock];
}


- (void)testGetMaxCountOfCharInString {
    printf("%s",__func__);
    
    char *s = "kkk55555555sfffksaasssdf11";
    char keys[50] = "";
    int counts[50] = {};
    
    long len = strlen(s);
    printf("\nlen:%ld\n",len);

    for (int i = 0; i < len; ++i) {
        char key = s[i];
        printf("\nkey:%c\n",key);
        int indexOfKey = isContainCharInKeys(key, keys);
        if (indexOfKey >= 0) {
            counts[indexOfKey]++;
        }else {
            long currentIndex = strlen(keys);
            keys[currentIndex] = key;
            counts[currentIndex] = 1;
        }
    }

    printf("\n keys:%s\n",keys);

//    int index = indexOfMaxChar(counts);
//    printf("index %d",index);
    
    int keyNum = counts[0];
    int index = 0;
    for (int i = 0 ; i<50; ++i) {
        if (counts[i] > keyNum) {
            keyNum = counts[i];
            index = i;
        }
    }
    printf("index %d",index);
    printf("the max count of char is:%c\n count is :%d",keys[index],counts[index]);
    
    
    int b[50] = {1,2,3,4,5,6,7,8,9,0};

    int keyCount = sizeof(b)/sizeof(int);
    printf("\nkeyCount:%d",keyCount);

}

int isContainCharInKeys(char key,char *keys) {
    int result  = -1;
    for (int i = 0; i < strlen(keys); ++i) {
        char c = keys[i];
        if (c == key) {
            result = i;
            break;
        }
    }
    return result;
}

int indexOfMaxChar(int a[]){
    int index = -1;
    int keyNum = a[0];
    int keyCount = sizeof(a)/sizeof(int);

    for (int i = 0 ; i<keyCount; ++i) {
        if (a[i] > keyNum) {
            keyNum = a[i];
            index = i;
        }
    }
    return index;
}

- (void)testCombineSort {
    NSLog(@"=========================\n%s",__func__);
    
    combineSortMain();
}

@end

#undef BEGIN_HEART_BEAT_WARNING_RATIO
#undef STOP_HEART_BEAT_WARNING_RATIO
