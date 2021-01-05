//
//  CombineSort.c
//  TP_liu
//
//  Created by liu on 2021/1/5.
//  Copyright © 2021年 liu. All rights reserved.
//

#include "CombineSort.h"
#include<stdio.h>

#define LEN 12   // 宏定义数组的大小
static int tmp[LEN] = {0};// 设置临时数组

    // 打印数组
void print_array(int *array)
{
    int index = 0;
    printf("\narray:\n");
    for (; index < LEN; index++){
        printf(" %d, ", *(array + index));
    }
    printf("\n");
}

    // 把两个有序的数组排序成一个数组
void _mergeSort(int *array, int start, int middle, int end)
{
    int first = start;
    int second = middle + 1;
    int index = start;
    while ((first <= middle) && (second <= end)){
        if (array[first] >= array[second])
            tmp[index++] = array[second++];
        else
            tmp[index++] = array[first++];
    }
    while(first <= middle) tmp[index++] = array[first++];
    while(second <= end) tmp[index++] = array[second++];
    
    for (first = start; first <= end; first++)
        array[first] = tmp[first];
}

    // 递归划分数组
void mergeSort(int *array, int start, int end)
{
    if (start >= end)
        return;
    int middle = ((end + start) >> 1);
    mergeSort(array, start, middle);// 递归划分左边的数组
    mergeSort(array, middle+1, end);// 递归划分右边的数组
    _mergeSort(array, start, middle, end);// 对有序的两个数组进行合并成一个有序的数组
}

int combineSortMain(void){
    int array[LEN] = {2, 1, 4, 0, 12, 520, 2, 9, 5, 3, 13, 14};
    print_array(array);
    mergeSort(array, 0, LEN-1);
    print_array(array);
    return 0;
}
