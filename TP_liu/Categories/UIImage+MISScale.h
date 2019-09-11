//
//  UIImage+MISScale.h
//  EDU
//
//  Created by Mao on 11/26/15.
//  Copyright (c) 2015 Aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(MISScale)

/**
 *  以ScaleToFill方式缩放图片到指定size
 *  生成size的比例，图片可能会变型
 *  生成size大小的图片
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleToFillInSize:(CGSize )size;

/**
 *  以ScaleAspectFit方式缩放图片到指定size
 *  生成原始比例大小的图片
 *  可用制做原始比例的缩略图
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFitInSize:(CGSize )size;


/**
 *  以ScaleAspectFit方式缩放图片到指定size
 *  生成原始比例大小的图片
 *  可用制做原始比例的缩略图
 *
 *  @param size 指定size
 *  @param flag 能否放大图片适应（放大会失真）
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFitInSize:(CGSize )size canZoom:(BOOL)flag;

/**
 *  以ScaleAspectFill方式缩放图片到指定size
 *  图片多佘部分被剪切，生成size大小的图片
 *  可用制做方图的缩略图
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFillInSize:(CGSize )size;


/**
 *  保持长宽比的方式缩放图片
 *
 *  @param scale 缩放比例
 *
 *  @return image obj
 */
- (UIImage *)mis_imageWithScale:(CGFloat )scale;


/**
 *  以指定范围方式缩放图片到指定size
 *  保持图片比例
 *  图片小于 minsize 时会被放大
 *  图片大于 maxsize 时会被缩小
 *  @param minSize 最小size 以保持原始比例的方式 Scale
 *  @param maxSize 最大size 以ScaleAspectFit方式
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleFromMinSize:(CGSize)minSize toMaxSize:(CGSize )maxSize;


@end
