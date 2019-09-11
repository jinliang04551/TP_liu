//
//  NSData+MISJSON.m
//  edua
//
//  Created by Mao on 11/9/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import "NSData+MISJSON.h"

@implementation NSData(MISJSON)

- (id)mis_JSONObject {
	NSError* error = nil;
	
	id obj = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
	
	if (!obj) {
		NSLog(@"%@", error);
	}
	
	return obj;
}

- (id)mis_mutableJSONObject {
	NSError* error = nil;
	
	id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
	
	if (!obj) {
		NSLog(@"%@", error);
	}
	
	return obj;
}

@end
