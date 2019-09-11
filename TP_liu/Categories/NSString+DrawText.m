//
//  NSString+DrawText.m
//  ZHTY
//
//  Created by liu on 2018/3/14.
//  Copyright © 2018年 Eduapp. All rights reserved.
//

#import "NSString+DrawText.h"

@implementation NSString (DrawText)
/*
 * drawMarkText right or left -align
 * @ align -1: left 0: center 1: right
 */

- (void)drawMarkFont:(UIFont *)font
               color:(UIColor *)color
                rect:(CGRect)rect
               align:(int)align {
    //attributes
    NSDictionary* attributes = @{
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color
                                 };
    CGSize size = [self boundingRectWithSize: CGSizeMake(200, 200)  options: NSStringDrawingUsesLineFragmentOrigin attributes: attributes context: nil].size;
    
    //right align && vetical center && final draw text
    
    //left
    CGFloat xPoint = rect.origin.x;
    
    if (align > 0) {
        //right
        xPoint = rect.origin.x + (rect.size.width - size.width);
    }else if (align == 0) {
        //center
        xPoint = rect.origin.x + ((rect.size.width - size.width) / 2.0f);
    }
    
    CGRect textRect = CGRectMake(xPoint, rect.origin.y + ((rect.size.height - size.height) / 2.0), size.width, size.height);
    [self drawInRect:textRect withAttributes:attributes];
}

/**
 get textsize
 
 @param font context font
 @param color context color
 @return size
 */
- (CGSize)getSizeWithFont:(UIFont *)font
                textColor:(UIColor *)color {
    
    NSDictionary* attributes = @{
                                 NSFontAttributeName: font,
                                 NSForegroundColorAttributeName: color
                                 };
    
    CGSize contextSize = [self boundingRectWithSize: CGSizeMake(200, 200)  options: NSStringDrawingUsesLineFragmentOrigin attributes: attributes context: nil].size;
    return contextSize;
}

@end
