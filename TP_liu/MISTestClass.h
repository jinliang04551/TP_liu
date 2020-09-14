//
//  MISTestClass.h
//  TP_liu
//
//  Created by liu on 2020/1/19.
//  Copyright © 2020 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MISTestClass : NSObject
- (void)startFun;

@end

@interface MISTestClassSubA : MISTestClass
- (void)startFun;

@end

@interface MISTestClassSubB : MISTestClass
- (void)startFun;

@end

@interface MISTestClass (Start)
- (void)startFun;
@end

@interface MISTestClassSubA (Start)
- (void)startFun;

@end

@interface MISTestClassSubB (Start)
- (void)startFun;
@end

NS_ASSUME_NONNULL_END
