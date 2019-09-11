//
//  NSString+MISLength.m
//  EPlus
//
//  Created by Mao on 29/10/2017.
//  Copyright © 2017 Eduapp. All rights reserved.
//

#import "NSString+MISLength.h"

@implementation NSString(MISLength)


/**
 * 字符长度（中文算两个，英文算一个）
 */
- (NSUInteger)mis_characterLength {
	NSUInteger output = 0;
	for (NSInteger i = 0; i < self.length; ++i) {
		NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
		if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
			output += 2;
		} else {
			output += 1;
		}
	}
	return output;
}


/**
 * 限制字符长度（中文算两个，英文算一个）
 */
- (NSString *)mis_stringWithLimit:(NSUInteger)limit {
	NSString* output = self;
	NSUInteger sum = 0;
	for (NSInteger i = 0; i < self.length; ++i) {
		NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
		if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
			sum += 2;
		} else {
			sum += 1;
		}
		
		if (sum == limit) {
			output = [self substringToIndex:i + 1];
			break;
		}else if (sum > limit) {
			output = [self substringToIndex:i];
			break;
		}
	}
	return output;
}


@end
