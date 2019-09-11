//
//  NSString+MISLength.h
//  EPlus
//
//  Created by Mao on 29/10/2017.
//  Copyright © 2017 Eduapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MISLength)

/**
 * 字符长度（中文算两个，英文算一个）
 */
- (NSUInteger)mis_characterLength;


/**
 * 限制字符长度（中文算两个，英文算一个）
 */
- (NSString *)mis_stringWithLimit:(NSUInteger)limit;

@end
