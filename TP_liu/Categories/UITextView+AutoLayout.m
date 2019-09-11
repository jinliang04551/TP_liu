//
//  UITextView+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UITextView+AutoLayout.h"

@implementation UITextView(AutoLayout)

+ (UITextView *)autoLayoutTextView {
	UITextView* textView = [[UITextView alloc] init];
	textView.translatesAutoresizingMaskIntoConstraints = NO;
	return textView;
}


@end
