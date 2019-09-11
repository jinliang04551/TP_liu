//
//  UIButton+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UIButton+AutoLayout.h"

@implementation UIButton(AutoLayout)

+ (UIButton *)autoLayoutButton {
	UIButton* button = [[UIButton alloc] init];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	return button;
}


@end
