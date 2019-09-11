
/***********************************************************
 //  MISImagePickerAlbumsController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerCropPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>


static CGFloat MISImagePickerCropFooterViewHeight = 80.0f;
static CGFloat MISImagePickerCropViewPadding      = 25.0f;
static CGFloat MISImagePickerCropViewPointSize    = 15.0f;
static CGFloat MISImagePickerCropViewTouchSize    = 40.0f;
static NSInteger MISImagePickerCropViewTagOffset  = 1000;

@interface MISImagePickerCropPreviewViewController()

@property (nonatomic) CGFloat imageScale;             //图像缩放比
@property (nonatomic) CGPoint startPoint;             //起始点
@property (nonatomic, strong) UIView* contentView;    //容器 view
@property (nonatomic, strong) UIImageView* imageView; //图片承载 view
@property (nonatomic, strong) UIView* footerView;     //按钮区 view
@property (nonatomic, strong) UIView* cropView;       //裁剪区 view
@property (nonatomic, strong) UIView* cropMaskView;   //黑色蒙板

/**
 *  四角点
 */
@property (nonatomic, strong) UIView* point1;
@property (nonatomic, strong) UIView* point2;
@property (nonatomic, strong) UIView* point3;
@property (nonatomic, strong) UIView* point4;

/**
 *  手势响应view 左，上，右，下 左上，右上，左下，右下
 */
@property (nonatomic, strong) UIView* topLeft;
@property (nonatomic, strong) UIView* topRight;
@property (nonatomic, strong) UIView* bottomRight;
@property (nonatomic, strong) UIView* bottomLeft;
@property (nonatomic, strong) UIView* left;
@property (nonatomic, strong) UIView* top;
@property (nonatomic, strong) UIView* bottom;
@property (nonatomic, strong) UIView* right;

@end

@implementation MISImagePickerCropPreviewViewController
#pragma mark life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
        [self addListenNotify];
    }
    return self;
}

- (void)addListenNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:@"didEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive:) name:@"didBecomeActive" object:nil];
}

- (void)didEnterBackground:(NSNotification *) notification {
    
}

- (void)didBecomeActive:(NSNotification *) notification {
    
}

- (void)dealloc {
    REMOVE_NOTIFY(self);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	/*
	 * 添加子 view - 整体按横屏布局-
	 * 由各个子 view 调整其 transform
	 */
	
	//内容区域
	[self.view addSubview:self.contentView];
	
	//按钮区域
	[self.view addSubview:self.footerView];
	
	//加载图片
	[self loadImage];
}

#pragma mark - OverWrite

- (BOOL)prefersStatusBarHidden {
	return YES;
}


#pragma mark - Private Methods

/**
 *  加载图片+让 imageView 跟图片一样的比例显示-AspectFit 在 contentView 里面
 */
- (void)loadImage {
	//设定图片
	self.imageView.image = self.image;
	
	//预设大小
	self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
	
	//计算比例
	CGRect frame = self.imageView.frame;
	CGFloat scalex = CGRectGetWidth(self.contentView.frame) / self.image.size.width;
	CGFloat scaley = CGRectGetHeight(self.contentView.frame) / self.image.size.height;
	CGFloat scale = MIN(scalex, scaley);

	if (scale >= 1.0) {
		scale = 1.0; //保持原始大小
	}
	
	frame.size.width = self.image.size.width * scale;
	frame.size.height = self.image.size.height * scale;

	/**
	 *  设定图片跟 imageView 同比例
	 */
	self.imageView.frame = frame;
	CGPoint center = self.imageView.center;
	center.x = CGRectGetWidth(self.contentView.frame) / 2.0;
	center.y = CGRectGetHeight(self.contentView.frame) / 2.0;
	self.imageView.center = center;
	
	
	//计算
	self.imageScale = self.image.size.width / CGRectGetWidth(self.imageView.frame);
	
	/**
	 *  设定默认的裁剪区域
	 */
	[self resizeCropView];
	
	/**
	 *  设定默认的裁剪mask
	 */
	[self resetCropMask];
	
	/**
	 *  设定 touch 点
	 */
	[self resetPointViews];
	
	/**
	 *  设定 touch 区域
	 */
	[self resetTouchArea];
}

/**
 *  设定默认的裁剪区域
 */
- (void)resizeCropView {
	CGRect frame = self.cropView.frame;

	CGFloat imageHWFactor = self.image.size.height / self.image.size.width;
	if(imageHWFactor <= 1) {
		frame.size.width = CGRectGetWidth(self.imageView.frame) * 0.5;
		frame.size.height = CGRectGetHeight(self.imageView.frame) * 1.0;
	}
	else {
		frame.size.width = CGRectGetWidth(self.imageView.frame) * 0.5;
		frame.size.height = CGRectGetHeight(self.imageView.frame) * 0.75;
	}
	
	self.cropView.frame = frame;
	self.cropView.center = self.imageView.center;
}

/**
 *  重设裁剪mask
 */
- (void)resetCropMask {
	
	//iOS 8.0+
	UIBezierPath *path = nil;
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		path = [UIBezierPath bezierPathWithRect: self.cropMaskView.bounds];
		UIBezierPath *clearPath = [[UIBezierPath bezierPathWithRect: self.cropView.frame] bezierPathByReversingPath];
		[path appendPath: clearPath];
	}else { //for fix iOS 7.0 bug 否则会出现一个三角形
		CGFloat minX = CGRectGetMinX(self.cropView.frame);
		CGFloat minY = CGRectGetMinY(self.cropView.frame);
		CGFloat maxX = CGRectGetMaxX(self.cropView.frame);
		CGFloat maxY = CGRectGetMaxY(self.cropView.frame);
		
		CGPoint p1 = CGPointMake(minX, minY);
		CGPoint p2 = CGPointMake(maxX, minY);
		CGPoint p3 = CGPointMake(maxX, maxY);
		CGPoint p4 = CGPointMake(minX, maxY);
		
		path = [[UIBezierPath alloc] init];
		[path moveToPoint:p2];
		[path addLineToPoint:p1];
		[path addLineToPoint:p4];
		[path addLineToPoint:p3];
		[path addLineToPoint:p2];
		[path closePath];
		
		minX = CGRectGetMinX(self.cropMaskView.frame);
		minY = CGRectGetMinY(self.cropMaskView.frame);
		maxX = CGRectGetMaxX(self.cropMaskView.frame);
		maxY = CGRectGetMaxY(self.cropMaskView.frame);
		
		p1 = CGPointMake(minX, minY);
		p2 = CGPointMake(maxX, minY);
		p3 = CGPointMake(maxX, maxY);
		p4 = CGPointMake(minX, maxY);
		
		[path moveToPoint:p2];
		[path addCurveToPoint:p3 controlPoint1:p2 controlPoint2:p3];
		[path addLineToPoint:p4];
		[path addLineToPoint:p1];
		[path addLineToPoint:p2];
		[path addLineToPoint:p2];
		[path closePath];
	}
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.cropMaskView.layer.mask;
	if(!shapeLayer) {
		shapeLayer = [CAShapeLayer layer];
		[self.cropMaskView.layer setMask: shapeLayer];
	}
	shapeLayer.path = path.CGPath;
}

/**
 *  创建 touchView Point
 *
 *  @return UIView
 */
- (UIView *)pointView {
	UIView* touch = [[UIView alloc] init];
	touch.frame = CGRectMake(0, 0, MISImagePickerCropViewPointSize, MISImagePickerCropViewPointSize);
	touch.clipsToBounds = YES;
	touch.layer.cornerRadius = MISImagePickerCropViewPointSize / 2.0f;
	touch.backgroundColor = [UIColor whiteColor];
	touch.layer.borderColor = [UIColor blackColor].CGColor;
	touch.layer.borderWidth = 0.5;
	return touch;
}


#pragma mark - Recognizer

- (void)moveWithRecognizer:(UIGestureRecognizer *)recognizer {
	if(recognizer.state == UIGestureRecognizerStateBegan) {
		_startPoint = [recognizer locationInView:self.contentView];
		[self resetTouchArea];
		[self disableOtherTouchViewFromView:recognizer.view];
	} else if(recognizer.state == UIGestureRecognizerStateChanged) {
		[self recognizerStateChanged:recognizer];
	}else if(recognizer.state == UIGestureRecognizerStateEnded) {
		[self resetTouchArea];
		[self enableAllTouchViews];
	}else if(recognizer.state == UIGestureRecognizerStateCancelled) {
		[self resetTouchArea];
		[self enableAllTouchViews];
	}else if (recognizer.state == UIGestureRecognizerStateFailed) {
		[self enableAllTouchViews];
	}
}

/**
 *  移动目标
 *
 *  @param recognizer 手势
 */
- (void)recognizerStateChanged:(UIGestureRecognizer *)recognizer {
	//设定边界
	CGFloat minX = CGRectGetMinX(self.imageView.frame);
	CGFloat minY = CGRectGetMinY(self.imageView.frame);
	CGFloat maxX = CGRectGetMaxX(self.imageView.frame);
	CGFloat maxY = CGRectGetMaxY(self.imageView.frame);
	
	UIView* pointView = nil;
	if(recognizer.view == self.topLeft
	   || recognizer.view == self.left
	   || recognizer.view == self.top) {
		pointView = self.point1;
		maxX = CGRectGetMidX(self.point4.frame) - MISImagePickerCropViewPointSize;
		maxY = CGRectGetMidY(self.point4.frame) - MISImagePickerCropViewPointSize;
	}
	else if(recognizer.view == self.bottomLeft) {
		pointView = self.point2;
		maxX = CGRectGetMidX(self.point3.frame) - MISImagePickerCropViewPointSize;
		minY = CGRectGetMidY(self.point3.frame) + MISImagePickerCropViewPointSize;
	}
	else if(recognizer.view == self.topRight) {
		pointView = self.point3;
		minX = CGRectGetMidX(self.point2.frame) + MISImagePickerCropViewPointSize;
		maxY = CGRectGetMidY(self.point2.frame) - MISImagePickerCropViewPointSize;
	}
	else if(recognizer.view == self.bottomRight
			|| recognizer.view == self.bottom
			|| recognizer.view == self.right) {
		pointView = self.point4;
		minX = CGRectGetMidX(self.point1.frame) + MISImagePickerCropViewPointSize;
		minY = CGRectGetMidY(self.point1.frame) + MISImagePickerCropViewPointSize;
	}else if(recognizer.view == self.cropView) {
		maxX -= CGRectGetMidX(self.point3.frame) - CGRectGetMidX(self.point1.frame);
		maxY -= CGRectGetMidY(self.point2.frame) - CGRectGetMidY(self.point1.frame);
	}
	
	//移动选框
	if (recognizer.view == self.cropView) {
		CGPoint endPoint = [recognizer locationInView:self.contentView];
		CGRect frame = recognizer.view.frame;
		frame.origin.x += endPoint.x - _startPoint.x;
		frame.origin.y += endPoint.y - _startPoint.y;
		frame.origin.x = MIN(maxX, MAX(frame.origin.x, minX));
		frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
		recognizer.view.frame = frame;
		_startPoint = endPoint;
		
		//设定四点
		[self resetPointViews];
		
		//设定裁剪遮罩
		[self resetCropMask];
		
		//移动四角
	} else if (recognizer.view == self.topLeft
			   || recognizer.view == self.topRight
			   || recognizer.view == self.bottomLeft
			   || recognizer.view == self.bottomRight){
		CGPoint endPoint = [recognizer locationInView:self.contentView];
		CGPoint center = pointView.center;
		center.x += endPoint.x - _startPoint.x;
		center.y += endPoint.y - _startPoint.y;
		center.x = MIN(maxX, MAX(center.x, minX));
		center.y = MIN(maxY, MAX(center.y, minY));
		pointView.center = center;
		_startPoint = endPoint;
		
		//移动其它点
		[self movePointsFollowPointView:pointView];
		
		//设定裁剪区域
		[self resizeCropViewFollowPoints];
		
		//设定裁剪遮罩
		[self resetCropMask];
		
		//设定手势区域
		[self resetTouchArea];
		
		//移动左右边
	} else if (recognizer.view == self.left
			   || recognizer.view == self.right) {
		CGPoint endPoint = [recognizer locationInView:self.contentView];
		CGPoint center = pointView.center;
		center.x += endPoint.x - _startPoint.x;
		center.x = MIN(maxX, MAX(center.x, minX));
		pointView.center = center;
		_startPoint = endPoint;
		
		//移动其它点
		[self movePointsFollowPointView:pointView];
		
		//设定裁剪区域
		[self resizeCropViewFollowPoints];
		
		//设定裁剪遮罩
		[self resetCropMask];
		
		//设定手势区域
		[self resetTouchArea];
		
		//移动上下边
	} else if (recognizer.view == self.top
			   || recognizer.view == self.bottom) {
		CGPoint endPoint = [recognizer locationInView:self.contentView];
		CGPoint center = pointView.center;
		center.y += endPoint.y - _startPoint.y;
		center.y = MIN(maxY, MAX(center.y, minY));
		pointView.center = center;
		_startPoint = endPoint;
		
		//移动其它点
		[self movePointsFollowPointView:pointView];
		
		//设定裁剪区域
		[self resizeCropViewFollowPoints];
		
		//设定裁剪遮罩
		[self resetCropMask];
		
		//设定手势区域
		[self resetTouchArea];
	}
}

/**
 *  禁用其它手势view
 *
 *  @param view 当前响应view
 */
- (void)disableOtherTouchViewFromView:(UIView *)touchView {
	NSArray* subviews = self.contentView.subviews;
	
	for (UIView* view in subviews) {
		if (touchView != view) {
			if (view.tag >= MISImagePickerCropViewTagOffset
				&& view.tag <= MISImagePickerCropViewTagOffset + 8) {
				view.userInteractionEnabled = NO;
			}
		}
	}
}

/**
 *  开启所有touch View
 */
- (void)enableAllTouchViews {
	NSArray* subviews = self.contentView.subviews;
	
	for (UIView* view in subviews) {
		if (view.tag >= MISImagePickerCropViewTagOffset
			&& view.tag <= MISImagePickerCropViewTagOffset + 8) {
			view.userInteractionEnabled = YES;
		}
	}
}


/**
 *  设定其它点 跟随一个点的变化
 */
- (void)movePointsFollowPointView:(UIView *)view {
	CGFloat xPoint = view.center.x;
	CGFloat yPoint = view.center.y;
	
	CGPoint center;
	if (view == self.point1) {
		center = self.point2.center;
		center.x = xPoint;
		self.point2.center = center;
		
		center = self.point3.center;
		center.y = yPoint;
		self.point3.center = center;
	}else if (view == self.point2) {
		center = self.point1.center;
		center.x = xPoint;
		self.point1.center = center;
		
		center = self.point4.center;
		center.y = yPoint;
		self.point4.center = center;
	}else if (view == self.point3) {
		center = self.point4.center;
		center.x = xPoint;
		self.point4.center = center;
		
		center = self.point1.center;
		center.y = yPoint;
		self.point1.center = center;
	}else if (view == self.point4) {
		center = self.point3.center;
		center.x = xPoint;
		self.point3.center = center;
		
		center = self.point2.center;
		center.y = yPoint;
		self.point2.center = center;
	}
}

/**
 *  设置触摸区域
 */
- (void)resetTouchArea {
    CGFloat minX   = CGRectGetMinX(self.cropView.frame);
    CGFloat minY   = CGRectGetMinY(self.cropView.frame);
    CGFloat maxX   = CGRectGetMaxX(self.cropView.frame);
    CGFloat maxY   = CGRectGetMaxY(self.cropView.frame);
    CGFloat height = CGRectGetHeight(self.cropView.frame);
    CGFloat width  = CGRectGetWidth(self.cropView.frame);

	//四边
	self.left.frame = CGRectMake(minX - MISImagePickerCropViewTouchSize / 2.0f, minY + MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, height - MISImagePickerCropViewTouchSize);
	self.right.frame = CGRectMake(maxX - MISImagePickerCropViewTouchSize / 2.0f, minY + MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, height - MISImagePickerCropViewTouchSize);
	self.top.frame = CGRectMake(minX + MISImagePickerCropViewTouchSize / 2.0f, minY - MISImagePickerCropViewTouchSize / 2.0f, width - MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
	self.bottom.frame = CGRectMake(minX + MISImagePickerCropViewTouchSize / 2.0f, maxY - MISImagePickerCropViewTouchSize / 2.0f, width - MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
	
	//四点
	self.topLeft.frame = CGRectMake(minX - MISImagePickerCropViewTouchSize / 2.0f, minY - MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
	self.topRight.frame = CGRectMake(maxX - MISImagePickerCropViewTouchSize / 2.0f, minY - MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
	self.bottomLeft.frame = CGRectMake(minX - MISImagePickerCropViewTouchSize / 2.0f, maxY - MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
	self.bottomRight.frame = CGRectMake(maxX - MISImagePickerCropViewTouchSize / 2.0f, maxY - MISImagePickerCropViewTouchSize / 2.0f, MISImagePickerCropViewTouchSize, MISImagePickerCropViewTouchSize);
}


/**
 *  设定裁剪区域跟随touchView
 */
- (void)resizeCropViewFollowPoints {
	CGRect frame      = self.cropView.frame;
	frame.origin.x    = CGRectGetMidX(self.point1.frame);
	frame.origin.y    = CGRectGetMidY(self.point1.frame);
	frame.size.width  = CGRectGetMidX(self.point3.frame) - CGRectGetMidX(self.point1.frame);
	frame.size.height = CGRectGetMidY(self.point2.frame) - CGRectGetMidY(self.point1.frame);
	self.cropView.frame = frame;
}

/**
 *  设定点的位置跟随CropRect
 */
- (void)resetPointViews {
	/*
	 *  1-3
	 *  | |
	 *  2-4
	 */
	
	self.point1.center = CGPointMake(CGRectGetMinX(self.cropView.frame), CGRectGetMinY(self.cropView.frame));
	self.point2.center = CGPointMake(CGRectGetMinX(self.cropView.frame), CGRectGetMaxY(self.cropView.frame));
	self.point3.center = CGPointMake(CGRectGetMaxX(self.cropView.frame), CGRectGetMinY(self.cropView.frame));
	self.point4.center = CGPointMake(CGRectGetMaxX(self.cropView.frame), CGRectGetMaxY(self.cropView.frame));
}

/**
 *  计算裁剪 rect
 *
 *  @return CGRect
 */
- (CGRect)cropAreaInImage {
	CGRect cropAreaInImageView  = [self.contentView convertRect:self.cropView.frame toView:self.imageView];
	CGRect cropAreaInImage;
	cropAreaInImage.origin.x    = cropAreaInImageView.origin.x * self.imageScale;
	cropAreaInImage.origin.y    = cropAreaInImageView.origin.y * self.imageScale;
	cropAreaInImage.size.width  = cropAreaInImageView.size.width * self.imageScale;
	cropAreaInImage.size.height = cropAreaInImageView.size.height * self.imageScale;
	
	
	//默认的不用处理 0
	if (self.image.imageOrientation == UIImageOrientationUp) {
		return cropAreaInImage;
	}
	
	
	//进行旋转rect
	CGRect outRect = cropAreaInImage;
	CGFloat imageWidth = CGRectGetWidth(self.imageView.frame) * self.imageScale;
	CGFloat imageHeight = CGRectGetHeight(self.imageView.frame) * self.imageScale;
    CGFloat minX   = CGRectGetMinX(cropAreaInImage);
    CGFloat minY   = CGRectGetMinY(cropAreaInImage);
    CGFloat maxX   = CGRectGetMaxX(cropAreaInImage);
    CGFloat maxY   = CGRectGetMaxY(cropAreaInImage);
    CGFloat width  = CGRectGetWidth(cropAreaInImage);
    CGFloat height = CGRectGetHeight(cropAreaInImage);

	//这里只考虑正常的状态 1、2、3
	if (self.image.imageOrientation == UIImageOrientationRight) {//左转过来
        outRect = CGRectMake(minY, imageWidth - maxX, height, width);
	}else if (self.image.imageOrientation == UIImageOrientationLeft) {//右转过来
        outRect = CGRectMake(imageHeight - maxY, minX, height, width);
	}else if (self.image.imageOrientation == UIImageOrientationDown) {//垂直过来
        outRect = CGRectMake(imageWidth - maxX, imageHeight - maxY, width, height);
	}

	return outRect;
}

/**
 *  裁剪图片
 *
 *  @param image 原始图片
 *  @param rect  裁剪区域
 *
 *  @return 新图片
 */
- (UIImage *)imageCropedWithImage:(UIImage *)image inRect:(CGRect )rect {
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    if (imageRef) {
        UIImage* subImage = [UIImage imageWithCGImage: imageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(imageRef);
        return subImage;
    }else {
        return [UIImage new];
    }
}

/**
 *  逆时针旋转90
 *
 *  @param image 传入图片
 *
 *  @return 转后的图片
 */
- (UIImage *)imageAfterRotateImage:(UIImage *)image {
	UIImageOrientation imageOrientation = image.imageOrientation;
	switch (self.image.imageOrientation) {
		case UIImageOrientationUp:
			imageOrientation = UIImageOrientationLeft;
			break;
		case UIImageOrientationLeft:
			imageOrientation = UIImageOrientationDown;
			break;
		case UIImageOrientationRight:
			imageOrientation = UIImageOrientationUp;
			break;
		case UIImageOrientationDown:
			imageOrientation = UIImageOrientationRight;
			break;
		default:
			break;
	}
	
	return  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:imageOrientation];
}

/**
 *  缩放-重绘-最大高宽 是屏幕大小
 *
 *  @param image 输入的原图
 *
 *  @return UIImage
 */
- (UIImage *)imageScaledWithImage:(UIImage *)image {
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	CGFloat screenScale = [UIScreen mainScreen].scale;
	CGSize size = CGSizeMake(screenSize.width * screenScale, screenSize.height * screenScale);
	CGFloat scalex = size.width / image.size.width;
	CGFloat scaley = size.height / image.size.height;
	CGFloat scale = MIN(scalex, scaley);
	
	if (scale >= 1.0) {
		scale = 1.0;
	}
	
	CGSize drawSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
	UIGraphicsBeginImageContext(drawSize);
	[image drawInRect:CGRectMake(0, 0, drawSize.width, drawSize.height)];
	UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return output;
}



#pragma mark - Events

/**
 *  完成剪切
 */
- (void)finishCrop {
	[self dismissViewControllerAnimated:YES completion:^{
		
		if (self.cropFinishBlock) {
			UIImage* cropedImage = [self imageCropedWithImage:self.image inRect:[self cropAreaInImage]]; //切出图片
			UIImage* rotateImage = [self imageAfterRotateImage:cropedImage];//逆时针转90度
			UIImage* finishImage = [self imageScaledWithImage:rotateImage]; //缩放
		
			/**
			 *  返回
			 */
			self.cropFinishBlock(finishImage);
		}
	}];
}


/**
 *  瞬时针旋转图片 90
 */
- (void)rotateImage {
	UIImageOrientation imageOrientation = self.image.imageOrientation;
	switch (self.image.imageOrientation) {
        case UIImageOrientationUp:
			imageOrientation = UIImageOrientationRight;
			break;
		case UIImageOrientationLeft:
			imageOrientation = UIImageOrientationUp;
			break;
		case UIImageOrientationRight:
			imageOrientation = UIImageOrientationDown;
			break;
		case UIImageOrientationDown:
			imageOrientation = UIImageOrientationLeft;
			break;
          default:
			break;
	}
	
	self.image = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:imageOrientation];
	
	/**
	 *  重新加载图片
	 */
	[self loadImage];
}


/**
 *  重拍
 */
- (void)retake {
	[self.navigationController popViewControllerAnimated:NO];
}

/**
 *  创建touchView
 *
 *  @return UIView
 */
- (UIView *)touchView {
	UIView* view = [[UIView alloc] init];
	[view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveWithRecognizer:)]];
	return view;
}

#pragma mark - Getter

- (UIView *)cropView {
	if (!_cropView) {
		_cropView = [[UIView alloc] init];
		_cropView.layer.borderColor = [UIColor whiteColor].CGColor;
		_cropView.layer.borderWidth = 0.5f;
		[_cropView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveWithRecognizer:)]];
	}
	return _cropView;
}

- (UIView *)cropMaskView {
	if (!_cropMaskView) {
		_cropMaskView = [[UIView alloc] init];
		_cropMaskView.userInteractionEnabled = NO;
		_cropMaskView.backgroundColor = [UIColor blackColor];
		_cropMaskView.alpha = 0.65f;
	}
	return _cropMaskView;
}


- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
	}
	return _imageView;
}


- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.frame = CGRectMake(MISImagePickerCropViewPadding, MISImagePickerCropViewPadding, CGRectGetWidth(self.view.frame) - MISImagePickerCropViewPadding * 2 ,  CGRectGetHeight(self.view.frame) - MISImagePickerCropFooterViewHeight - MISImagePickerCropViewPadding * 2.0f);
		
		//imageView
		self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
		[_contentView addSubview:self.imageView];
		
		//CropView
		[_contentView addSubview:self.cropView];
		self.cropView.tag = MISImagePickerCropViewTagOffset;
		
		//CropMaskView
		self.cropMaskView.frame = CGRectMake(0, 0, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame));
		[_contentView addSubview:self.cropMaskView];
		
		//PointsView
		self.point1 = [self pointView];
		self.point2 = [self pointView];
		self.point3 = [self pointView];
		self.point4 = [self pointView];
		
		[_contentView addSubview:self.point1];
		[_contentView addSubview:self.point2];
		[_contentView addSubview:self.point3];
		[_contentView addSubview:self.point4];
		
        self.left            = [self touchView];
        self.left.tag        = MISImagePickerCropViewTagOffset + 1;
        self.right           = [self touchView];
        self.right.tag       = MISImagePickerCropViewTagOffset + 2;

        self.top             = [self touchView];
        self.top.tag         = MISImagePickerCropViewTagOffset + 3;

        self.bottom          = [self touchView];
        self.bottom.tag      = MISImagePickerCropViewTagOffset + 4;

        self.topLeft         = [self touchView];
        self.topLeft.tag     = MISImagePickerCropViewTagOffset + 5;

        self.topRight        = [self touchView];
        self.topRight.tag    = MISImagePickerCropViewTagOffset + 6;

        self.bottomLeft      = [self touchView];
        self.bottomLeft.tag  = MISImagePickerCropViewTagOffset + 7;

        self.bottomRight     = [self touchView];
        self.bottomRight.tag = MISImagePickerCropViewTagOffset + 8;


		[_contentView addSubview:self.left];
		[_contentView addSubview:self.right];
		[_contentView addSubview:self.bottom];
		[_contentView addSubview:self.top];
		[_contentView addSubview:self.topLeft];
		[_contentView addSubview:self.topRight];
		[_contentView addSubview:self.bottomLeft];
		[_contentView addSubview:self.bottomRight];
	}
	return _contentView;
}

- (UIView *)footerView {
	if (!_footerView) {
		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, CGRectGetWidth(self.view.frame))];
		_footerView.backgroundColor = [UIColor blackColor];
		
		UIButton* rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		rotateBtn.frame = CGRectMake(20, 40, 40, 40);
		[rotateBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_rotate"] forState:UIControlStateNormal];
		[rotateBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_rotate_hl"] forState:UIControlStateHighlighted];
		[rotateBtn addTarget:self action:@selector(rotateImage) forControlEvents:UIControlEventTouchUpInside];
		
		[_footerView addSubview:rotateBtn];
		
		UILabel* rotateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rotateBtn.frame), 80, 20)];
		rotateLabel.textAlignment = NSTextAlignmentCenter;
		rotateLabel.font = [UIFont systemFontOfSize:14.0f];
		rotateLabel.text = @"旋转";
		rotateLabel.textColor = [UIColor whiteColor];
		[_footerView addSubview:rotateLabel];
		
		UIButton* retakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		retakeBtn.frame = CGRectMake(20, CGRectGetHeight(_footerView.frame) - 100, 40, 40);
		[retakeBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_retack"] forState:UIControlStateNormal];
		[retakeBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_retack_hl"] forState:UIControlStateHighlighted];
		[retakeBtn addTarget:self action:@selector(retake) forControlEvents:UIControlEventTouchUpInside];
		
		[_footerView addSubview:retakeBtn];
		
		UILabel* retakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(retakeBtn.frame), 80, 20)];
		retakeLabel.textAlignment = NSTextAlignmentCenter;
		retakeLabel.font = [UIFont systemFontOfSize:14.0f];
		retakeLabel.text = @"重拍";
		retakeLabel.textColor = [UIColor whiteColor];
		[_footerView addSubview:retakeLabel];
		
		UIButton* finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		finishBtn.frame = CGRectMake(0, (CGRectGetHeight(_footerView.frame) - 80) / 2.0, 80, 80);
		[finishBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_crop_finish"] forState:UIControlStateNormal];
		[finishBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_crop_finish_hl"] forState:UIControlStateHighlighted];
		[finishBtn addTarget:self action:@selector(finishCrop) forControlEvents:UIControlEventTouchUpInside];
		[_footerView addSubview:finishBtn];
		
		
		CGPoint center = _footerView.center;
		center.x = CGRectGetMidX(self.view.frame);
		center.y = CGRectGetHeight(self.view.frame) - 40.0f;
		_footerView.center = center;
		
		_footerView.transform = CGAffineTransformMakeRotation(M_PI_2);
	}
	return _footerView;
}



@end
