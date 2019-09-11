//
//  UISwitch+AutoLayout.m
//  LNJXT
//
//  Created by Mao on 3/6/15.
//  Copyright (c) 2015 Eduapp. All rights reserved.
//

#import "UISwitch+AutoLayout.h"

@implementation UISwitch(AutoLayout)

+ (UISwitch *)autoLayoutSwitch {
	UISwitch* aSwitch = [[UISwitch alloc] init];
	aSwitch.translatesAutoresizingMaskIntoConstraints = NO;
	return aSwitch;
}


@end
