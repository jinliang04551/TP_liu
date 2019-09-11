//
//  UIView+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView(AutoLayout)

+ (UIView *)autoLayoutView {
	UIView* view = [[UIView alloc] init];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	return view;
}


@end
