//
//  NSDictionary+MISJSON.m
//  edua
//
//  Created by Mao on 11/9/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import "NSDictionary+MISJSON.h"

@implementation NSDictionary(MISJSON)

- (NSString *)mis_JSONString {
	NSData* data = [self mis_JSONData];
	
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (NSData *)mis_JSONData {
	NSError* error = nil;
	
	NSData* data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
	
	if (!data) {
		NSLog(@"%@", error);
	}
	
	return data;
}

@end
