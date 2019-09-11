//
//  NSString+MISEmoji.m
//  EDU
//
//  Created by MaoKebing on 6/3/15.
//  Copyright (c) 2015 Edu. All rights reserved.
//

#import "NSString+MISEmoji.h"

@implementation NSString(MISEmoji)

- (NSString *)stringByReplacingEmojiWithString:(NSString *)string {
	NSString* outString = [self copy];

	@autoreleasepool {
		NSRange range;
		NSMutableSet* emojiSet = [NSMutableSet set];
		
		//找出emoji
		for(NSInteger i = 0; i < self.length; i += range.length) {
			range = [self rangeOfComposedCharacterSequenceAtIndex:i];
			NSString *codeString = [self substringWithRange:range];
			
			NSMutableString* hexString = [NSMutableString string];
			for (int i = 0; i < codeString.length; ++i) {
				[hexString appendFormat:@"%02x", [codeString characterAtIndex:i]];
			}
			
			NSScanner* scanner = [NSScanner scannerWithString:hexString];
			UInt64 code = 0x00;
			[scanner scanHexLongLong: &code];
			if (![self isNotEmoji:code]) {
				[emojiSet addObject:codeString];
			}
		}
		
		//替换emoji
		for (NSString* emojiString in emojiSet) {
			outString = [outString stringByReplacingOccurrencesOfString:emojiString withString:string];
		}
	}

	return outString;
}

- (BOOL)isNotEmoji:(UInt64) codePoint {
	return (codePoint == 0x0)
	|| (codePoint == 0x9)
	|| (codePoint == 0xA)
	|| (codePoint == 0xD)
	|| ((codePoint >= 0x20) && (codePoint <= 0xD7FF))
	|| ((codePoint >= 0xFF00) && (codePoint <=
								  0xFFFF));
}

- (int)numEmoji {
    int count = 0;
    
    @autoreleasepool {
        NSRange range;
        
        //找出emoji
        for(NSInteger i = 0; i < self.length; i += range.length) {
            range = [self rangeOfComposedCharacterSequenceAtIndex:i];
            NSString *codeString = [self substringWithRange:range];
            
            NSMutableString* hexString = [NSMutableString string];
            for (int i = 0; i < codeString.length; ++i) {
                [hexString appendFormat:@"%02x", [codeString characterAtIndex:i]];
            }
            
            NSScanner* scanner = [NSScanner scannerWithString:hexString];
            UInt64 code = 0x00;
            [scanner scanHexLongLong: &code];
            if (![self isNotEmoji:code]) {
                ++count;
            }
        }
    }
    
    return count;
}

@end
