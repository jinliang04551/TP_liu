//
//  UISearchBar+AutoLayout.m
//  CQJXT
//
//  Created by Mac on 15/6/17.
//  Copyright (c) 2015年 Eduapp. All rights reserved.
//

#import "UISearchBar+AutoLayout.h"

@implementation UISearchBar (AutoLayout)

+ (UISearchBar *)autoLayoutUISearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    return searchBar;
}

@end
