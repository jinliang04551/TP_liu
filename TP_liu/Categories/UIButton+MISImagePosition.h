//
//  UIButton+MISImagePosition.h
//  ZHTY
//
//  Created by xiaochen on 2018/3/16.
//  Copyright © 2018年 Eduapp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /// 图片在左，文字在右
    MISImagePositionStyleDefault,
    /// 图片在右，文字在左
    MISImagePositionStyleRight,
    /// 图片在上，文字在下
    MISImagePositionStyleTop,
    /// 图片在下，文字在上
    MISImagePositionStyleBottom,
} MISImagePositionStyle;

@interface UIButton (MISImagePosition)

/**
 *  设置图片与文字样式
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 */
- (void)MIS_imagePositionStyle:(MISImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing;

/**
 *  设置图片与文字样式（推荐使用）
 *
 *  @param imagePositionStyle     图片位置样式
 *  @param spacing                图片与文字之间的间距
 *  @param imagePositionBlock     在此 Block 中设置按钮的图片、文字以及 contentHorizontalAlignment 属性
 */
- (void)MIS_imagePositionStyle:(MISImagePositionStyle)imagePositionStyle spacing:(CGFloat)spacing imagePositionBlock:(void (^)(UIButton *button))imagePositionBlock;


@end
