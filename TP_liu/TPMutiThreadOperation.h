//
//  TPMutiThreadOperation.h
//  TP_liu
//
//  Created by liu on 2019/7/16.
//  Copyright © 2019 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPMutiThreadOperation : NSObject

/**
 创建单例

 @return TPMutiThreadOperation
 */
+ (instancetype)mutiThreadOperation;


/**
 测试函数
 */
- (void)testFun;

@end

NS_ASSUME_NONNULL_END
