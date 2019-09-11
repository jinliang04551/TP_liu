//
//  UITableView+HiddenExtraCellLine.m
//  YNJXT
//
//  Created by liu on 15/12/10.
//  Copyright © 2015年 Eduapp. All rights reserved.
//

#import "UITableView+HiddenExtraCellLine.h"

@implementation UITableView (HiddenExtraCellLine)
- (void)setExtraCellLineHidden {
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor clearColor];
	[self setTableFooterView:view];
}

@end
