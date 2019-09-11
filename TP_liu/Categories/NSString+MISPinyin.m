//
//  NSString+MISPinyin.m
//  edua
//
//  Created by mao on 11/13/15.
//  Copyright © 2015 aspire. All rights reserved.
//

#import "NSString+MISPinyin.h"
#import <MISPinyin/MISPinyin.h>

@implementation NSString(MISPinyin)

- (NSString *)pinyin {
/*
	NSMutableString *mString = [self mutableCopy];
	if (CFStringTransform((__bridge CFMutableStringRef)mString, NULL, kCFStringTransformMandarinLatin, NO)) {
		if (CFStringTransform((__bridge CFMutableStringRef)mString, NULL, kCFStringTransformStripDiacritics, NO)) {
			return [mString stringByReplacingOccurrencesOfString:@" " withString:@""];
		}
	}
	return @"";
 */
 
	return [MISPinyin pinyinWithHanzi:self];
}


@end
