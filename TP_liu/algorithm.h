//
//  algorithm.h
//  TP_liu
//
//  Created by liu on 2018/6/4.
//  Copyright © 2018年 liu. All rights reserved.
//

#ifndef algorithm_h
#define algorithm_h

#include <stdio.h>

////冒泡排序
void bubbleSort(int a[], int length);

//快速排序
void quick_sort(int a[], int l, int r);

//二分查找
int binarySearch(int *a,int len, int goal);

#endif /* algorithm_h */
