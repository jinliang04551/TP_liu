//
//  UILabel+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UILabel+AutoLayout.h"

@implementation UILabel(AutoLayout)

+ (UILabel *)autoLayoutLabel {
	UILabel* label = [[UILabel alloc] init];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	return label;
}


@end
