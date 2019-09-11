/***********************************************************
 //  MISImagePickerPhotoView.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerPhotoView.h"
#import "MISImagePickerManager.h"


@interface MISImagePickerPhotoView ()

@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation MISImagePickerPhotoView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.imageView];
	}
	return self;
}



#pragma mark - Getter & Setter

- (UIImageView *)imageView {
	if (_imageView == nil) {
		_imageView = [[UIImageView alloc] init];
	}
	return _imageView;
}

- (void)setAsset:(id)asset {
	__weak __typeof(&*self) weakSelf = self;
	[[MISImagePickerManager defaultManager] fetchImageForAsset:asset completion:^(UIImage *result) {
		weakSelf.imageView.image = result;
		[weakSelf showImage];
	}];
}

- (void)setImage:(UIImage *)image {
	self.imageView.image = image;
	[self showImage];
}

#pragma mark - Private Methods

- (void)showImage {
	// 基本尺寸参数
	CGSize  boundsSize   = self.bounds.size;
	CGFloat boundsWidth  = boundsSize.width;
	CGFloat boundsHeight = boundsSize.height;
	
	CGSize  imageSize    = self.imageView.image.size;
	if (imageSize.height == 0
		||imageSize.width == 0) {
		return;
	}
	
	CGFloat imageWidth   = imageSize.width;
	CGFloat imageHeight  = imageSize.height;
	
	// 设置伸缩比例
	CGFloat widthRatio  = boundsWidth/imageWidth;
	CGFloat heightRatio = boundsHeight/imageHeight;
	CGFloat minScale    = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	
	if (minScale >= 1) {
		minScale = 0.8;
	}
	
	self.maximumZoomScale = 1.5;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
	
	CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
	// 内容尺寸
	self.contentSize = CGSizeMake(0, imageFrame.size.height);
	
	// 宽大
	if (imageWidth <= imageHeight &&
		imageHeight <  boundsHeight) {
		imageFrame.origin.x = floorf((boundsWidth   - imageFrame.size.width ) / 2.0) * minScale;
		imageFrame.origin.y = floorf((boundsHeight  - imageFrame.size.height) / 2.0) * minScale;
	} else {
		imageFrame.origin.x = floorf((boundsWidth   - imageFrame.size.width ) / 2.0);
		imageFrame.origin.y = floorf((boundsHeight  - imageFrame.size.height ) / 2.0);
	}
	
	self.imageView.frame = imageFrame;
}

- (void)prepareForReuse {
	self.imageView.image = nil;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	
	return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	CGFloat boundsWidth   = scrollView.bounds.size.width;
	CGFloat boundsHeight  = scrollView.bounds.size.height;
	CGFloat sizeWidth     = scrollView.contentSize.width;
	CGFloat sizeHeight    = scrollView.contentSize.height;
	CGFloat offsetX       = boundsWidth  - sizeWidth;
	CGFloat offsetY       = boundsHeight - sizeHeight;
	
	offsetX = offsetX > 0 ? offsetX: 0.0f;
	offsetY = offsetY > 0 ? offsetY: 0.0f;
	
	self.imageView.center = CGPointMake((sizeWidth + offsetX) /2.0f,
										(sizeHeight + offsetY) /2.0f);
}

#pragma mark - Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == self) {
		if ([touch tapCount] == 2) {
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapSelf) object:nil];
			[self zoomToLocation:[touch locationInView:self]];
		}
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == self) {
		if ([touch tapCount] == 1) {
			[self performSelector:@selector(tapSelf) withObject:nil afterDelay:0.20];
		}
	}
}

- (void)tapSelf {
	if (self.tapBlock) {
		self.tapBlock();
	}
}

- (void)zoomToLocation:(CGPoint)location {
	if (self.zoomScale == self.maximumZoomScale){
		[self setZoomScale:self.minimumZoomScale animated:YES];
	}else{
		[self zoomToRect:CGRectMake(location.x, location.y, 1, 1) animated:YES];
	}
}

@end
