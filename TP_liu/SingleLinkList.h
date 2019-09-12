//
//  SingleLinkList.h
//  TP_liu
//
//  Created by liu on 2018/9/6.
//  Copyright © 2018年 liu. All rights reserved.
//

#ifndef SingleLinkList_h
#define SingleLinkList_h

#include <stdio.h>

//初始化单链表
typedef int ElemType;
typedef struct Node {
    ElemType data;
    struct Node * next;
}Node;

//所有操作调用入口
void singleList_main(void);


#endif /* SingleLinkList_h */
