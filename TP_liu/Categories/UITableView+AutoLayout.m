//
//  UITableView+AutoLayout.m
//  EDU
//
//  Created by mao on 1/25/15.
//  Copyright (c) 2015 JXT. All rights reserved.
//

#import "UITableView+AutoLayout.h"

@implementation UITableView(AutoLayout)

+ (UITableView *)autoLayoutGroupedTableView {
	UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	tableView.translatesAutoresizingMaskIntoConstraints = NO;
	return tableView;
}

+ (UITableView *)autoLayoutPlainTableView {
	UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	tableView.translatesAutoresizingMaskIntoConstraints = NO;
	return tableView;
}


@end
