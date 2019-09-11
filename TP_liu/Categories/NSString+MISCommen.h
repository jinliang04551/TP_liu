//  NSString的扩展类
//  NSString+MISCommen.h
//  edua
//
//  Created by CM on 15/9/8.
//  Copyright (c) 2015年 aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MISCommen)

#pragma mark - 得到字符的大小

/**
 *  得到单行字符串的size
 *
 *  @param font 字体
 *
 *  @return 实际的大小
 */
- (CGSize)mis_sizeWithFont:(UIFont*)font;

/**
 *  得到字符串的size
 *
 *  @param font 字体
 *  @param size 规定的大小
 *
 *  @return 实际的大小
 */
- (CGSize)mis_sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

/**
 *  得到字符串的实际高度
 *
 *  @param font 字体
 *  @param size 大小
 *
 *  @return 实际高度
 */
- (CGFloat)mis_heightWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

/**
 *  得到字符串的实际宽度
 *
 *  @param font 字体
 *  @param size 大小
 *
 *  @return 实际宽度
 */
- (CGFloat)mis_widthWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

#pragma mark - 常规

/**
 *  是否为空
 *
 *  @param value 要检验的字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString*)value;

/**
 *  integer转换成string
 *
 *  @param value integer的值
 *
 *  @return 转换后的字符串
 */
+ (NSString*)stringWithInteger:(NSInteger)value;

/**
 *  long转换成字符串
 *
 *  @param value float的值
 *
 *  @return 转换后的字符串
 */
+ (NSString*)stringWithLong:(long)value;

/**
 *  longlong转换成字符串
 *
 *  @param value longlong的值
 *
 *  @return 转换后的字符串
 */
+ (NSString*)stringWithLongLong:(int64_t)value;

/**
 *  float转换成字符串
 *
 *  @param value float的值
 *
 *  @return 转换后的字符串
 */
+ (NSString*)stringWithFloat:(float)value;

/**
 *  double转换成字符串
 *
 *  @param value double的值
 *
 *  @return 转换后的字符串
 */
+ (NSString*)stringWithDouble:(double)value;

@end
