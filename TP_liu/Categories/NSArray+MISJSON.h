//
//  NSArray+MISJSON.h
//  edua
//
//  Created by Mao on 11/9/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(MISJSON)

/**
 *  字典转成JSON串
 *
 *  @return JSON串
 */
- (NSString *)mis_JSONString;

/**
 *  字典转成JSON串-UTF8编码成Data
 *
 *  @return Data
 */
- (NSData *)mis_JSONData;

@end
