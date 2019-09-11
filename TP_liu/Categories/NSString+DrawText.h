//
//  NSString+DrawText.h
//  ZHTY
//
//  Created by liu on 2018/3/14.
//  Copyright © 2018年 Eduapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DrawText)

/*
 * drawMarkText right or left -align
 * @ align -1: left 0: center 1: right
 */

- (void)drawMarkFont:(UIFont *)font
               color:(UIColor *)color
                rect:(CGRect)rect
               align:(int)align;

/**
 get textsize
 
 @param font context font
 @param color context color
 @return size
 */
- (CGSize)getSizeWithFont:(UIFont *)font
                textColor:(UIColor *)color;

@end
