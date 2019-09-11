//
//  UIWebView+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UIWebView+AutoLayout.h"

@implementation UIWebView(AutoLayout)

+ (UIWebView *)autoLayoutWebView {
	UIWebView* webView = [[UIWebView alloc] init];
	webView.translatesAutoresizingMaskIntoConstraints = NO;
	return webView;
}

@end
