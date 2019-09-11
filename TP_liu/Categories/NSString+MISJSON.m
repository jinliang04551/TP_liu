//
//  NSString+MISJSON.m
//  edua
//
//  Created by Mao on 11/9/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import "NSString+MISJSON.h"

@implementation NSString(MISJSON)

- (id)mis_JSONObject {
	NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
	
	if (!data) {
		NSLog(@"It is not in UTF-8 encoding!");
		return nil;
	}
	
	NSError* error = nil;
	
	id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	
	if (!obj) {
		NSLog(@"%@", error);
	}
	
	return obj;
}


@end
