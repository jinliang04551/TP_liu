/***********************************************************
 //  MISSelectedImagePreviewController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISSelectedImagePreviewController.h"
#import "MISImagePickerPhotoView.h"
#import "MISImagePickerStyle.h"
#import "UIActionSheet+MISBlock.h"




@interface MISSelectedImagePreviewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableSet* visiblePhotoViewSet;
@property (nonatomic, strong) NSMutableSet* reusablePhotoViewSet;
@property (nonatomic) BOOL isHidenNavigationBar;
@property (nonatomic, copy) NSArray* images;

@end

@implementation MISSelectedImagePreviewController

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];
	if (self) {
		self.visiblePhotoViewSet  = [NSMutableSet set];
		self.reusablePhotoViewSet = [NSMutableSet set];
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
	
	//右键
	[self setupNavigationBarRightBtn];
	
	//子view
	[self setupSubViews];
}

- (void)setupNavigationBarRightBtn {
	UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteBtn.frame = CGRectMake(0, 0, 44, 44);
	[deleteBtn addTarget:self action:@selector(queryDelete) forControlEvents:UIControlEventTouchUpInside];
	[deleteBtn setImage:[MISImagePickerStyle deleteBtnImage] forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//显示
	[self showPhotos];
	
	//offset
	[self updateScrollViewOffset];
	
	//更新header
	[self updateHeaderView];
}

/**
 *  设置offset
 */
- (void)updateScrollViewOffset {
	self.scrollView.contentOffset = CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0);
	self.scrollView.contentSize = CGSizeMake(self.images.count * ([UIScreen mainScreen].bounds.size.width + 2 * MISImagePickerPhotoViewPadding), 0);
}

/**
 *  更新标题栏
 */
- (void)updateHeaderView {
	if (self.currentIndex >= self.images.count) {
		return;
	}
	
	self.title = [NSString stringWithFormat:@"%@/%@", @(self.currentIndex + 1), @(self.images.count)];
}

/**
 *  设置导航栏
 *
 *  @param flag 是否
 */
- (void)setNavigationBarAndStatusBarHidden:(BOOL)flag {
	[self.navigationController setNavigationBarHidden:flag animated:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:flag withAnimation:UIStatusBarAnimationFade];
}

/**
 *  设置子view
 */
- (void)setupSubViews {
	[self.view addSubview:self.scrollView];
}

- (void)queryDelete {
	if (self.currentIndex >= self.images.count) {
		return;
	}
	
	//询问
	UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
	[sheet showInView:[UIApplication sharedApplication].keyWindow completion:^(NSInteger buttonIndex) {
		if (buttonIndex == 0) {
			[self toggleDelete];
		}
	}];
}

/**
 *  删除
 */
- (void)toggleDelete {
	//移除
	[self.selectedImages removeObjectAtIndex:self.currentIndex];
	
	//重新赋值
	self.images = self.selectedImages;
	
	//通知回调
	if (self.imageDidChangeBlock) {
		self.imageDidChangeBlock();
	}
	
	//如果没有返回上个页面
	if (self.images.count == 0) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	//重载一下
	[self reloadPhotoViews];
	
	//更新标题
	[self updateHeaderView];
}

- (void)reloadPhotoViews {
	[self updateScrollViewOffset];
	
	[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.visiblePhotoViewSet removeAllObjects];
	
	//显示内容
	[self showPhotos];
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((-1) * MISImagePickerPhotoViewPadding, - 64.0f, [UIScreen mainScreen].bounds.size.width + MISImagePickerPhotoViewPadding * 2, [UIScreen mainScreen].bounds.size.height - 64.0f + 64.0f)];
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.backgroundColor = [UIColor blackColor];
	}
	return _scrollView;
}

- (void)setSelectedImages:(NSMutableArray *)selectedImages {
	if (_selectedImages != selectedImages) {
		_selectedImages = selectedImages;
		
		//copy
		self.images = selectedImages;
	}
}

#pragma mark - Private Methods

/**
 *  显示照片
 */
- (void)showPhotos {
	if (self.images.count == 1) {
		[self showPhotoViewAtIndex:0];
		return;
	}
	
	CGRect visibleBounds = self.scrollView.bounds;
	NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds) + MISImagePickerPhotoViewPadding * 2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds) - MISImagePickerPhotoViewPadding * 2 - 1) / CGRectGetWidth(visibleBounds));
	
	if (firstIndex < 0) {
		firstIndex = 0;
	}
	
	if (firstIndex >= self.images.count) {
		firstIndex = self.images.count - 1;
	}
	
	if (lastIndex < 0) {
		lastIndex = 0;
	}
	
	if (lastIndex >= self.images.count) {
		lastIndex = self.images.count - 1;
	}
	
	// 回收不再显示的ImageView
	for (MISImagePickerPhotoView *photoView in self.visiblePhotoViewSet) {
		NSInteger photoViewIndex = photoView.tag - MISImagePickerPhotoViewTagOffset;
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[self.reusablePhotoViewSet addObject:photoView];
			[photoView prepareForReuse];
			[photoView removeFromSuperview];
		}
	}
	
	//缩小可见的容器
	[self.visiblePhotoViewSet minusSet:self.reusablePhotoViewSet];
	
	//移除多佘的复用
	while(self.reusablePhotoViewSet.count > 2) {
		[self.reusablePhotoViewSet removeObject:self.reusablePhotoViewSet.anyObject];
	}
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

/**
 *  显示照片
 *
 *  @param index 索引
 */
- (void)showPhotoViewAtIndex:(NSUInteger)index {
	MISImagePickerPhotoView *photoView = [self dequeueReusablePhotoView];
	
	CGRect photoViewFrame = self.scrollView.bounds;
	photoViewFrame.size.width = [UIScreen mainScreen].bounds.size.width;
	CGFloat width = CGRectGetWidth(self.view.bounds) + MISImagePickerPhotoViewPadding * 2;
	photoViewFrame.origin.x = width * index + MISImagePickerPhotoViewPadding;
	photoView.tag = MISImagePickerPhotoViewTagOffset + index;
	photoView.frame = photoViewFrame;
	photoView.image = self.images[index];
	
	[self.visiblePhotoViewSet addObject:photoView];
	[self.scrollView addSubview:photoView];
}

/**
 *  是否已加载
 *
 *  @param index 索引
 *
 *  @return YES or NO
 */
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (MISImagePickerPhotoView *photoView in self.visiblePhotoViewSet) {
		if (photoView.tag - MISImagePickerPhotoViewTagOffset == index) {
			return YES;
		}
	}
	return  NO;
}

/**
 *  复用队列
 *
 *  @return 可用的PhotoView
 */
- (MISImagePickerPhotoView *)dequeueReusablePhotoView {
	MISImagePickerPhotoView *photoView = [self.reusablePhotoViewSet anyObject];
	if (photoView) {
		[self.reusablePhotoViewSet removeObject:photoView];
	}else {
		photoView = [[MISImagePickerPhotoView alloc] init];
		__weak __typeof(&*self) weakSelf = self;
		photoView.tapBlock = ^{
			[weakSelf toggleChrome];
		};
	}
	
	return photoView;
}

#pragma mark - Event

/**
 *  动画隐藏出现
 */
- (void)toggleChrome {
	self.isHidenNavigationBar = !self.isHidenNavigationBar;
	
	[UIView animateWithDuration:0.25f animations:^{
		self.navigationController.navigationBar.alpha = _isHidenNavigationBar ? 0.0f : 1.0f;
	}];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (index < 0 || index >= self.images.count) {
		return;
	}
	
	self.currentIndex = index;
	
	[self updateHeaderView];
}

@end
