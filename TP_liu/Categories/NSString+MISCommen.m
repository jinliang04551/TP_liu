//  NSString的扩展类
//  NSString+MISCommen.m
//  edua
//
//  Created by CM on 15/9/8.
//  Copyright (c) 2015年 aspire. All rights reserved.
//

#import "NSString+MISCommen.h"

@implementation NSString (MISCommen)


- (CGSize)mis_sizeWithFont:(UIFont*)font {
	return [self mis_sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight)];
}

- (CGSize)mis_sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : font } context:nil].size;
    }
    else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self mis_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}

- (CGFloat)mis_heightWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    return [self mis_sizeWithFont:font constrainedToSize:size].height;
}

- (CGFloat)mis_widthWithFont:(UIFont*)font constrainedToSize:(CGSize)size
{
    return [self mis_sizeWithFont:font constrainedToSize:size].width;
}

#pragma mark - 常规

+ (BOOL)isEmpty:(NSString*)value
{
    BOOL isEmpty = NO;
    if (value == nil || value == (NSString*)[NSNull null] || value.length == 0) {
        isEmpty = YES;
    }
    return isEmpty;
}

+ (NSString*)stringWithInteger:(NSInteger)value
{
    NSNumber* number = [NSNumber numberWithInteger:value];
    return [number stringValue];
}

+ (NSString*)stringWithLong:(long)value
{
    NSNumber* number = [NSNumber numberWithLong:value];
    return number.stringValue;
}

+ (NSString*)stringWithLongLong:(int64_t)value
{
    NSNumber* number = [NSNumber numberWithLongLong:value];
    return number.stringValue;
}

+ (NSString*)stringWithFloat:(float)value
{
    NSNumber* number = [NSNumber numberWithFloat:value];
    return number.stringValue;
}

+ (NSString*)stringWithDouble:(double)value
{
    NSNumber* number = [NSNumber numberWithDouble:value];
    return number.stringValue;
}

@end
