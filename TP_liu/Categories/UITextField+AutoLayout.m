//
//  UITextField+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UITextField+AutoLayout.h"

@implementation UITextField(AutoLayout)

+ (UITextField *)autoLayoutTextField {
	UITextField* textField = [[UITextField alloc] init];
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	return textField;
}

@end
