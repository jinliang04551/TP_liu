/***********************************************************
 //  MISImagePickerPreviewController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerPreviewController.h"
#import "MISImagePickerPhotoView.h"
#import "MISImagePickerStyle.h"
#import <Masonry/Masonry.h>

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#endif


@interface MISImagePickerBottomBar()
@property (nonatomic, strong) UIButton* previewButton;
@property (nonatomic, strong) UIButton* confirmButton;
@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) MISBadgeView* countLabel;
@property (nonatomic) BOOL hidenPreview;
@end

@implementation MISImagePickerBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = UIColorFromRGB(0x008AE0);
		[self addSubview:self.previewButton];
		[self addSubview:self.confirmButton];
		[self addSubview:self.countLabel];
		[self addSubview:self.line];
		
		[self setupLayout];
        [self listenNotifys];
	}
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self listenNotifys];
    }
    return self;
}

- (void)listenNotifys {
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

- (void)setupLayout {
	[self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(15.0);
		make.top.equalTo(self);
		make.bottom.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.3);
	}];
	
	[self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self).offset(-15.0);
		make.top.equalTo(self);
		make.bottom.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.15);
	}];
	
	[self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.confirmButton.mas_left).offset(10);
		make.centerY.equalTo(self);
	}];
	
	[self.line mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.width.equalTo(self);
		make.height.equalTo(@(1.0f / [UIScreen mainScreen].scale));
	}];
}

- (UIButton *)previewButton {
	if (!_previewButton) {
		_previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_previewButton.translatesAutoresizingMaskIntoConstraints = NO;
		_previewButton.enabled = NO;
		[_previewButton setTitle:@"预览" forState:UIControlStateNormal];
		_previewButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
		[_previewButton setTitleColor:[MISImagePickerStyle previewBtnColor] forState:UIControlStateNormal];
		[_previewButton setTitleColor:[[MISImagePickerStyle previewBtnColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
		[_previewButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[_previewButton addTarget:self action:@selector(tapPreview) forControlEvents:UIControlEventTouchUpInside];
	}
	return _previewButton;
}

- (UIButton *)confirmButton {
	if (!_confirmButton) {
		_confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
		_confirmButton.enabled = NO;
		[_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
		_confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
		[_confirmButton setTitleColor:[MISImagePickerStyle finishBtnColor] forState:UIControlStateNormal];
		[_confirmButton setTitleColor:[[MISImagePickerStyle finishBtnColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
		[_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
		[_confirmButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
		[_confirmButton addTarget:self action:@selector(tapConfirm) forControlEvents:UIControlEventTouchUpInside];
	}
	return _confirmButton;
}

- (MISBadgeView *)countLabel {
	if (!_countLabel) {
		_countLabel = [MISBadgeView autoLayoutBadgeView];
		_countLabel.backgroundColor = [MISImagePickerStyle badgeLabelColor];
	}
	return _countLabel;
}

- (UIView *)line {
	if (!_line) {
		_line = [[UIView alloc] init];
		_line.translatesAutoresizingMaskIntoConstraints = NO;
		_line.backgroundColor = UIColorFromRGB(0xD3D3D3);
	}
	return _line;
}

- (void)tapPreview {
	if (self.previewBlock) {
		self.previewBlock ();
	}
}

- (void)tapConfirm {
	if (self.confirmBlock) {
		self.confirmBlock ();
	}
}

- (void)setCount:(NSInteger)count {
	if (count > 0) {
		self.confirmButton.enabled = YES;
		self.previewButton.enabled = YES;
		[self.countLabel setBadgeValue:count animated:YES];
	}else {
		self.confirmButton.enabled = NO;
		self.previewButton.enabled = NO;
		self.countLabel.badgeValue = 0;
	}
}

- (void)setHidenPreview:(BOOL)hidenPreview {
	self.previewButton.hidden = hidenPreview;
	self.line.hidden = hidenPreview;
}

@end

@interface MISImagePickerHeaderBar : UIView

@property (nonatomic) BOOL checked;
@property (nonatomic, copy) void (^backBlock)(void);
@property (nonatomic, copy) void (^checkBlock)(BOOL checked);
@property (nonatomic, copy) NSArray *imageAssets;
@property (nonatomic) NSInteger currentImageIndex;

@end

@interface MISImagePickerHeaderBar()
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* checkButton;
@end

@implementation MISImagePickerHeaderBar

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		UIColor* bgColor = UIColorFromRGB(0x008AE0);
		self.backgroundColor = [bgColor colorWithAlphaComponent:0.8f];
		[self addSubview:self.backButton];
		[self addSubview:self.checkButton];
		
		[self setupLayout];
	}
	return self;
}

- (void)setupLayout {
	[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(15);
		make.top.equalTo(self).offset (20);
		make.bottom.equalTo(self);
		make.width.equalTo(self).multipliedBy(0.3);
	}];
	
	[self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self);
		make.top.equalTo(self).offset (20);;
		make.bottom.equalTo(self);
		make.width.equalTo(self.mas_height);
	}];
}

- (UIButton *)backButton {
	if (!_backButton) {
		_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_backButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_backButton setImage:[MISImagePickerStyle previewNavigationBackBtnImage] forState:UIControlStateNormal];
		[_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
		[_backButton addTarget:self action:@selector(tapBackButton) forControlEvents:UIControlEventTouchUpInside];
	}
	return _backButton;
}

- (UIButton *)checkButton {
	if (!_checkButton) {
		_checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_checkButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_checkButton setImage:[MISImagePickerStyle checkBtnImage] forState:UIControlStateNormal];
		[_checkButton setImage:[MISImagePickerStyle checkBtnHLImage] forState:UIControlStateSelected];
		[_checkButton addTarget:self action:@selector(tapCheckButton) forControlEvents:UIControlEventTouchUpInside];
	}
	return _checkButton;
}

- (void)tapBackButton {
	if (self.backBlock) {
		self.backBlock ();
	}
}

- (void)tapCheckButton {
	self.checkButton.selected = !self.checkButton.selected;
	
	//动画
	CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	k.values = @[@(0.1),@(1.0),@(1.2)];
	k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
	k.calculationMode = kCAAnimationLinear;
	[self.checkButton.layer addAnimation:k forKey:@"SHOW"];
	
	if (self.checkBlock) {
		self.checkBlock (self.checkButton.selected);
	}
}

- (void)setChecked:(BOOL)checked {
	self.checkButton.selected = checked;
}

- (void)setCurrentImageIndex:(NSInteger)currentImageIndex
{
	_currentImageIndex = currentImageIndex;
}

@end

@interface MISImagePickerPreviewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableSet* visiblePhotoViewSet;
@property (nonatomic, strong) NSMutableSet* reusablePhotoViewSet;
@property (nonatomic, strong) MISImagePickerHeaderBar* headerView;
@property (nonatomic, strong) MISImagePickerBottomBar* footerView;

@end

@implementation MISImagePickerPreviewController

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];
	if (self) {
		self.visiblePhotoViewSet  = [NSMutableSet set];
		self.reusablePhotoViewSet = [NSMutableSet set];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor blackColor];
	
	//子view
	[self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//fix bug-begin
	self.scrollView.delegate = nil;
	
	//隐藏导航栏
	[self hiddenNavigationBar:YES];
	
	
	//更新footer
	[self updateFooterView];
	
	
	//更新header
	[self updateHeaderView];
	
	//fix bug-end
	self.scrollView.delegate = self;
	
	//offset
	[self updateScrollViewOffset];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self hiddenNavigationBar:NO];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark OverWrite

- (BOOL)prefersStatusBarHidden {
	return YES;
}

/**
 *  设置offset
 */
- (void)updateScrollViewOffset {
	self.scrollView.contentOffset = CGPointMake(self.currentIndex * self.scrollView.frame.size.width, 0);
	self.scrollView.contentSize = CGSizeMake(self.assets.count * ([UIScreen mainScreen].bounds.size.width + 2 * MISImagePickerPhotoViewPadding), 0);
	
	//Fix bug for show first image some times
	[self showPhotoViewAtIndex:self.currentIndex];
}

/**
 *  更新标题栏
 */
- (void)updateHeaderView {
	id obj = self.assets[self.currentIndex];
	if ([self.selectedAssets containsObject:obj]) {
		self.headerView.checked = YES;
	}else {
		self.headerView.checked = NO;
	}
}

/**
 *  更新底栏
 */
- (void)updateFooterView {
	self.footerView.count = self.selectedAssets.count;
}


/**
 *  设置导航栏
 *
 *  @param flag 是否
 */
- (void)hiddenNavigationBar:(BOOL)flag {
	[self.navigationController setNavigationBarHidden:flag animated:YES];
}

/**
 *  设置子view
 */
- (void)setupSubViews {
	[self.view addSubview:self.scrollView];
	[self.view addSubview:self.headerView];
	[self.view addSubview:self.footerView];
}

#pragma mark - Getter & Setter

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((-1) * MISImagePickerPhotoViewPadding, 0, [UIScreen mainScreen].bounds.size.width + MISImagePickerPhotoViewPadding * 2, [UIScreen mainScreen].bounds.size.height)];
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.showsVerticalScrollIndicator = NO;
	}
	return _scrollView;
}

- (UIView *)headerView {
	if (!_headerView) {
		_headerView = [[MISImagePickerHeaderBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64.0f)];
		_headerView.imageAssets = self.assets;
		_headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
		
		__weak __typeof(&*self) weakSelf = self;
		_headerView.backBlock = ^{
			[weakSelf.navigationController popViewControllerAnimated:YES];
		};
		
		_headerView.checkBlock = ^(BOOL checked){
			[weakSelf checkPhotoView:checked];
		};
	}
	return _headerView;
}

- (UIView *)footerView {
	if (!_footerView) {
		_footerView = [[MISImagePickerBottomBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 44.0 - IPHONEX_MARGIN_BOTTOM, [UIScreen mainScreen].bounds.size.width, 44.0)];
		_footerView.hidenPreview = YES;
		_footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
		__weak __typeof(&*self) weakSelf = self;
		_footerView.confirmBlock = ^{
			if (weakSelf.selectedFinishBlock) {
				weakSelf.selectedFinishBlock();
			}
		};
	}
	return _footerView;
}

#pragma mark - Private Methods

/**
 *  显示照片
 */
- (void)showPhotos {
	if (self.assets.count == 1) {
		[self showPhotoViewAtIndex:0];
		return;
	}
	
	CGRect visibleBounds = self.scrollView.bounds;
	NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds) + MISImagePickerPhotoViewPadding * 2) / CGRectGetWidth(visibleBounds));
	NSInteger lastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds) - MISImagePickerPhotoViewPadding * 2 - 1) / CGRectGetWidth(visibleBounds));
	
	if (firstIndex < 0) {
		firstIndex = 0;
	}
	
	if (firstIndex >= self.assets.count) {
		firstIndex = self.assets.count - 1;
	}
	
	if (lastIndex < 0) {
		lastIndex = 0;
	}
	
	if (lastIndex >= self.assets.count) {
		lastIndex = self.assets.count - 1;
	}
	
	// 回收不再显示的ImageView
	for (MISImagePickerPhotoView *photoView in self.visiblePhotoViewSet) {
		NSInteger photoViewIndex = photoView.tag - MISImagePickerPhotoViewTagOffset;
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[self.reusablePhotoViewSet addObject:photoView];
			[photoView removeFromSuperview];
			[photoView prepareForReuse];
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
	[photoView prepareForReuse];

	CGRect photoViewFrame = self.scrollView.bounds;
	photoViewFrame.size.width = [UIScreen mainScreen].bounds.size.width;
	CGFloat width = CGRectGetWidth(self.view.bounds) + MISImagePickerPhotoViewPadding * 2;
	photoViewFrame.origin.x = width * index + MISImagePickerPhotoViewPadding;
	photoView.tag = MISImagePickerPhotoViewTagOffset + index;
	photoView.frame = photoViewFrame;
	photoView.asset = self.assets[index];
	
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

- (void)checkPhotoView:(BOOL)flag {
	id obj = self.assets[self.currentIndex];
	
	if (flag) {
		if (self.selectedAssets.count == self.maxImageCount) {
			//回调出去
			BOOL isAlert = YES;
			if (self.seletedLimitBlock) {
				self.seletedLimitBlock (self.maxImageCount, &isAlert);
			}
			if (isAlert) {
				[self showMaxAlertView];
			}
		}else {
			//选择
			[self.selectedAssets addObject:obj];
		}
	}else {
		//反选
		[self.selectedAssets removeObject:obj];
	}
	
	//更新footer
	[self updateFooterView];
	[self updateHeaderView];
}

/**
 *  最大选择提示
 */
- (void)showMaxAlertView {
	[MISImagePickerStyle showMaxSeleteAlertWithCount:self.maxImageCount];
}

/**
 *  动画隐藏出现
 */
- (void)toggleChrome {
	if (self.footerView.hidden) {
		self.footerView.hidden = NO;
		self.headerView.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			self.footerView.alpha = 1.0f;
			self.headerView.alpha = 1.0f;
		}];
	}else {
		[UIView animateWithDuration:0.25 animations:^{
			self.footerView.alpha = 0.0f;
			self.headerView.alpha = 0.0f;
		} completion:^(BOOL finished) {
			self.footerView.hidden = YES;
			self.headerView.hidden = YES;
		}];
	}
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (index < 0 || index >= self.assets.count) {
		return;
	}
	
	self.currentIndex = index;
	self.headerView.currentImageIndex = index;

	[self updateHeaderView];
}

@end

