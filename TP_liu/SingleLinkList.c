//
//  SingleLinkList.c
//  TP_liu
//
//  Created by liu on 2018/9/6.
//  Copyright © 2018年 liu. All rights reserved.
//

//单链表
#include "SingleLinkList.h"
#include <stdlib.h>

//初始化一个单链表，具有头指针，头结点，头结点->next=NULL;
int initList(linkList *L) {
    (*L) = (linkList)malloc(sizeof(Node));
    (*L)->next = NULL;
    printf("链表初始化成功!");
    return 1;
}

//头插法创建一个链表，链表长度为n；
int createListHead(linkList *L, int n) {
    
}

//尾插法创建一个链表，链表长度为n；
int createListTail(linkList *L, int n) {
    
    
}

//获取单链表的长度；
int getlength(linkList *L) {
    
    
}

//打印整个链表；
int printList(linkList *L) {
    
}

//获取链表中第i个位置处节点的数据元素；
int getElem(linkList *L,int i,ElemType *elem) {
    
}

//在链表的指定位置（i节点）插入一个节点，i的范围为1~length（链表总长度）；
int insertList(linkList *, int i, ElemType data);
//给链表追加一个节点，在最末尾处增加；
int insertListTail(linkList *, ElemType data);
//删除指定位置（i节点）处的节点，i的范围为1~length（链表总长度）；
int deleteList(linkList *, int i, ElemType *data);
//删除整个链表，使头结点->next=NULL;
int clearList(linkList *);


