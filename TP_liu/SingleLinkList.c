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
#include <stdio.h>
#include <time.h>


//参考
/*
 * https://www.cnblogs.com/leaver/p/6718421.html
 * https://blog.csdn.net/sinat_40477296/article/details/78877547
 */

//初始化一个单链表，具有头指针，头结点，头结点->next=NULL;
Node * initList() {
   //头结点
    Node *linkHead = (Node*)malloc(sizeof(Node));
    linkHead->next = NULL;
    Node *tempNode = linkHead;
    for (int i = 1; i < 6; ++i) {
        Node *node = (Node *)malloc(sizeof(Node));
        printf("i=%d\n",i);
        
        node->data = i;
        node->next = NULL;
        
        tempNode->next = node;
        tempNode = tempNode->next;
    }
    
    return linkHead;
}



void displayLinkList(Node *node){
    Node *tempNode = node;
    while (tempNode->next) {
        printf("node->data:%d",tempNode->data);
        tempNode = tempNode->next;
        printf("\n");
    }

    printf("打印结束\n");
}


Node * reverseList(Node* pHead) {
     Node *root=pHead;
     Node *pre=NULL;
     Node *next=NULL;
     if(pHead==NULL) return NULL;
 while(root->next){
      next=root->next;
      root->next=pre;
      pre=root;
     root=next;
 }
     root->next=pre;
     return root;
 }

void singleList_main(void){
   Node *linkList = initList();
   displayLinkList(linkList);
   reverseList(linkList);
   printf("after reverse");

}

