//
//  NSDictionary+MISSafe.h
//  EDU
//
//  Created by MaoKebing on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(MISSafe)
- (char)charValueForKey:(NSString *)key;
- (short)shortValueForKey:(NSString *)key;
- (int)intValueForKey:(NSString *)key;
- (BOOL)boolValueForKey:(NSString *)key;
- (long)longValueForKey:(NSString *)key;
- (long long)longlongValueForKey:(NSString *)key;
- (float)floatValueForKey:(NSString *)key;
- (double)doubleValueForKey:(NSString *)key;
- (NSInteger)integerValueForKey:(NSString *)key;
- (NSString *)stringValueForKey:(NSString *)key;
- (NSTimeInterval)timeIntervalValueForKey:(NSString *)key;
- (NSArray *)arrayValueForKey:(NSString *)key;
- (NSDictionary *)dictValueForKey:(NSString *)key;

@end
