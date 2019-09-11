//
//  UIImage+MISColor.h
//  Mao
//
//  Created by mao on 1/24/15.
//  Copyright (c) 2015 EDU. All rights reserved.
//

#import "UIImage+MISColor.h"

@implementation UIImage(MISColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

@end
