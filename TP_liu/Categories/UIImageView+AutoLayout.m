//
//  UIImageView+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UIImageView+AutoLayout.h"

@implementation UIImageView(AutoLayout)

+ (UIImageView *)autoLayoutImageView {
	UIImageView* imageView = [[UIImageView alloc] init];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	return imageView;
}

@end
