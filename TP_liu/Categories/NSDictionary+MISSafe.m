//
//  NSDictionary+MISSafe.m
//  EDU
//
//  Created by MaoKebing on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "NSDictionary+MISSafe.h"

@implementation NSDictionary(BDSafe)
- (char)charValueForKey:(NSString *)key {
	char value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(charValue)])
	{
		value = [object charValue];
	}
	return value;
}

- (short)shortValueForKey:(NSString *)key {
	short value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(shortValue)])
	{
		value = [object shortValue];
	}
	return value;
}
- (int)intValueForKey:(NSString *)key {
	int value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(intValue)])
	{
		value = [object intValue];
	}
	return value;
}

- (BOOL)boolValueForKey:(NSString *)key {
	BOOL value = NO;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(boolValue)])
	{
		value = [object boolValue];
	}
	return value;
}

- (long)longValueForKey:(NSString *)key {
	long value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(longValue)])
	{
		value = [object longValue];
	}
	return value;
}
- (long long)longlongValueForKey:(NSString *)key {
	long long value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(longLongValue)])
	{
		value = [object longLongValue];
	}
	return value;
}
- (float)floatValueForKey:(NSString *)key {
	float value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(floatValue)])
	{
		value = [object floatValue];
	}
	return value;
}

- (double)doubleValueForKey:(NSString *)key {
	double value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(doubleValue)])
	{
		value = [object doubleValue];
	}
	return value;
}
- (NSInteger)integerValueForKey:(NSString *)key {
	NSInteger value = 0;
	
	id object = self[key];
	
	if ([object respondsToSelector:@selector(integerValue)])
	{
		value = [object integerValue];
	}
	return value;
}
- (NSString *)stringValueForKey:(NSString *)key {
	NSString* value = @"";
	
	id object = self[key];
	
	if ([object isKindOfClass:[NSString class]])
	{
		value = object;
	}
	else if ([object respondsToSelector:@selector(stringValue)])
	{
		value = [object stringValue];
	}
	
	return value;
}

- (NSTimeInterval)timeIntervalValueForKey:(NSString *)key{
	return [self doubleValueForKey:key];
}
- (NSArray *)arrayValueForKey:(NSString *)key {
	NSArray* value = @[];
	
	id object = self[key];
	
	if ([object isKindOfClass:[NSArray class]])
	{
		value = object;
	}
	
	return value;
}
- (NSDictionary *)dictValueForKey:(NSString *)key {
	NSDictionary* value = @{};
	
	id object = self[key];
	
	if ([object isKindOfClass:[NSDictionary class]])
	{
		value = object;
	}
	
	return value;
}
@end
