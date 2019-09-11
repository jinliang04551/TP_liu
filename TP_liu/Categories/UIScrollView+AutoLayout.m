//
//  UIScrollView+AutoLayout.m
//  CQJXT
//
//  Created by Mao on 3/31/15.
//  Copyright (c) 2015 Eduapp. All rights reserved.
//

#import "UIScrollView+AutoLayout.h"

@implementation UIScrollView(AutoLayout)

+ (UIScrollView *)autoLayoutScrollView {
	UIScrollView* view = [[UIScrollView alloc] init];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	return view;
}

@end
