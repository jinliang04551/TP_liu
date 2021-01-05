//
//  algorithm.c
//  TP_liu
//
//  Created by liu on 2018/6/4.
//  Copyright © 2018年 liu. All rights reserved.
//

#include "algorithm.h"

//冒泡排序
void bubbleSort(int a[], int length) {
    for (int i = 0; i < length; ++i) {
        for (int j = i; j < length; j++) {
            if (a[i] > a[j]) {
                int temp = a[i];
                a[i] = a[j];
                a[j] = temp;
            }
        }
    }
    
}

//快速排序
void quick_sort(int a[], int l, int r) {
    if (l < r) {

        int i = l, j = r, x = a[l];
        while (i < j) {
            while(i < j && a[j] >= x) {
                j--;
            }
            
            if (i < j) {
                a[i] = a[j];
            }
            
            while(i < j && a[i] < x) {
                i++;
            }
            
            if (i < j) {
                a[j] = a[i];
            }
        }
        a[i] = x;
        printf("\n位置%d %d",i,a[i]);
        
        quick_sort(a, i + 1, r);
        quick_sort(a, l, i - 1);
    }
}

int binarySearch(int *a,int len, int goal) {
    printf("%s",__func__);
    
    int low = 0;
    int high = len - 1;
    
    while (low <= high) {
        int middle = (high - low)/ 2 + low;
        
        if (a[middle] == goal) {
            return middle;
        }else if (a[middle] > goal) {
            high = middle -1;
        }else {
            low = middle + 1;
        }
    }
    return -1;
}

