//
//  Header.h
//  TP_liu
//
//  Created by liu on 2018/7/12.
//  Copyright © 2018年 liu. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define MIS_ONE_PX (1.0f / [UIScreen mainScreen].scale)


#define NSSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#endif /* Header_h */
