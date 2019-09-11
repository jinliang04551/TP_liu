//
//  UIProgressView+ArcCorner.m
//  ZHTY
//
//  Created by liu on 2018/3/26.
//  Copyright © 2018年 Eduapp. All rights reserved.
//

#import "UIProgressView+ArcCorner.h"

@implementation UIProgressView (ArcCorner)
- (void)setArcCornerWithRadius:(CGFloat)radius {
    for (UIImageView *subview in self.subviews) {
        subview.layer.cornerRadius = radius;
        subview.clipsToBounds = YES;
    }
}

@end
