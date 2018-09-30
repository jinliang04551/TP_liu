//
//  TPSocketServer.cpp
//  TP_liu
//
//  Created by liu on 2018/9/30.
//  Copyright © 2018年 liu. All rights reserved.
//

//source code from
//https://blog.csdn.net/m0_37947204/article/details/80489431
#include "TPSocketServer.hpp"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main() {
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    bind(serv_sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    //进入监听，等待用户发起请求
    listen(serv_sock, 20);
    //接受客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_addr, &clnt_addr_size);
    
    //向客户端发送数据
    char str[] = "hello client";
    write(clnt_sock, str, sizeof(str));
    
    //关闭套接字
    
    close(clnt_sock);
    close(serv_sock);
    
    return 0;
    
}
