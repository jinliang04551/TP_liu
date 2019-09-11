//
//  UIImage+MISScale.m
//  EDU
//
//  Created by Mao on 11/26/15.
//  Copyright (c) 2015 Aspire. All rights reserved.
//

#import "UIImage+MISScale.h"

@implementation UIImage(MISScale)

/**
 *  以ScaleToFill方式缩放图片到指定size
 *  生成size的比例，图片可能会变型
 *  生成size大小的图片
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleToFillInSize:(CGSize )size {
	UIGraphicsBeginImageContext(size);
	
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}

/**
 *  以ScaleAspectFit方式缩放图片到指定size
 *  生成原始比例大小的图片
 *  可用制做原始比例的缩略图
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFitInSize:(CGSize )size {
	return [self mis_imageScaleAspectFitInSize:size canZoom:YES];
}

/**
 *  以ScaleAspectFit方式缩放图片到指定size
 *  生成原始比例大小的图片
 *  可用制做原始比例的缩略图
 *
 *  @param size 指定size
 *  @param canZoom 能否放大适应
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFitInSize:(CGSize )size canZoom:(BOOL)flag{
	CGFloat scalex = size.width / self.size.width;
	CGFloat scaley = size.height / self.size.height;
	CGFloat scale = MIN(scalex, scaley);
	
	//能否放大适应
	if (scale >= 1.0 && !flag) {
		scale = 1.0; //保持原始大小
	}

	return [self mis_imageWithScale:scale];
}



/**
 *  以ScaleAspectFill方式缩放图片到指定size
 *  图片多佘部分被剪切，生成size大小的图片
 *  可用制做方图的缩略图
 *
 *  @param size 指定size
 *
 *  @return image obj
 */
- (UIImage *)mis_imageScaleAspectFillInSize:(CGSize )size {
	CGFloat scalex = size.width / self.size.width;
	CGFloat scaley = size.height / self.size.height;
	CGFloat scale = MAX(scalex, scaley);
	
	UIGraphicsBeginImageContext(size);
	
	CGFloat width = self.size.width * scale;
	CGFloat height = self.size.height * scale;
	
	float dwidth = ((size.width - width) / 2.0f);
	float dheight = ((size.height - height) / 2.0f);
	
	CGRect rect = CGRectMake(dwidth, dheight, self.size.width * scale, self.size.height * scale);
	[self drawInRect:rect];
	
	UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newimage;
}


/**
 *  保持长宽比的方式缩放图片
 *
 *  @param scale 缩放比例
 *
 *  @return image obj
 */
- (UIImage *)mis_imageWithScale:(CGFloat )scale {
	if (scale == 1.0) { //比例为1.0不用操作
		return self;
	}
	
	
	CGSize size = CGSizeMake(self.size.width * scale, self.size.height * scale);
	
	UIGraphicsBeginImageContext(size);
	
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return newImage;
}


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
- (UIImage *)mis_imageScaleFromMinSize:(CGSize)minSize toMaxSize:(CGSize )maxSize {
	CGFloat maxScalex = maxSize.width / self.size.width;
	CGFloat maxScaley = maxSize.height / self.size.height;
	CGFloat maxScale = MAX(maxScalex, maxScaley); //最大比例
	
	CGFloat minScalex = minSize.width / self.size.width;
	CGFloat minScaley = minSize.height / self.size.height;
	CGFloat minScale = MAX(minScalex, minScaley);//最大比例
	
	//原始比例
	CGFloat scale = 1.0;
	//超过MaxSize的大图-要缩小
	if (maxScale < 1.0) {
		scale = maxScale;
	}else if(minScale > 1.0) { //小于小图要放大
		scale = minScale;
	}

	return [self mis_imageWithScale:scale];
}

@end
