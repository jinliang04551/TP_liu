/***********************************************************
 //  MISImagePickerThumbController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/


#import "MISImagePickerThumbController.h"
#import "MISImagePickerPreviewController.h"
#import "MISImagePickerStyle.h"
#import "MISImagePickerAlbum.h"
#import "MISImagePickerManager.h"
#import <Masonry/Masonry.h>
#import "UIViewController+MISHUD.h"

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#endif

static NSString* MISImagePickerThumbCellReuseIdentifier = @"MISImagePickerThumbCell";
static CGFloat MISImagePickerThumbLineSpacing           = 5.0f;
static NSInteger MISImagePickerThumbViewTagOffset       = 1000;

@interface MISImagePickerThumbCell : UICollectionViewCell

/**
 *  显示图片
 */
@property (nonatomic, strong) UIImageView* imageView;

/**
 *  选择button
 */
@property (nonatomic, strong) UIButton* checkedButton;

/**
 *  选择回调
 */
@property (nonatomic, copy) void(^checkedBlock)(NSInteger index, BOOL isChecked);

/**
 *  设定选中
 */
@property (nonatomic, getter=isChecked) BOOL checked;

/**
 *  复用标识
 *
 *  @return String
 */
+ (NSString *)reuseIdentifier;

/**
 *  更新cell
 *
 *  @param obj 指定asset
 */
- (void)updateCellWithObj:(id)obj;

@end

@implementation MISImagePickerThumbCell

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
		//添加子view
		[self.contentView addSubview:self.imageView];
		[self.contentView addSubview:self.checkedButton];
		
		//指定布局
		[self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.contentView);
		}];
		
		[self.checkedButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.size.equalTo(@30);
			make.top.equalTo(self.contentView);
			make.right.equalTo(self.contentView);
		}];
        
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

- (void)listenNotifys{
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

#pragma mark - Getter
- (UIImageView *)imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] init];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		_imageView.contentMode = UIViewContentModeScaleAspectFill;
		_imageView.clipsToBounds = YES;
	}
	
	return _imageView;
}

- (UIButton *)checkedButton {
	if (!_checkedButton) {
		_checkedButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_checkedButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_checkedButton setImage:[MISImagePickerStyle checkBtnImage] forState:UIControlStateNormal];
		[_checkedButton setImage:[MISImagePickerStyle checkBtnHLImage] forState:UIControlStateSelected];
		[_checkedButton addTarget:self action:@selector(tapCheckButton:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _checkedButton;
}

#pragma mark - Event

- (void)tapCheckButton:(UIButton *)button {
	button.selected = !button.selected;
	
	//动画
	CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	k.values = @[@(0.1),@(1.0),@(1.2)];
	k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
	k.calculationMode = kCAAnimationLinear;
	[self.checkedButton.layer addAnimation:k forKey:@"SHOW"];
	
	if (self.checkedBlock) {
		self.checkedBlock(self.tag, button.selected);
	}
}

#pragma mark - Public Methods

+ (NSString *)reuseIdentifier {
	return MISImagePickerThumbCellReuseIdentifier;
}


+ (CGSize )sizeForCell {
	CGFloat width = ([UIScreen mainScreen].bounds.size.width - MISImagePickerThumbLineSpacing * 5.0) / 4.0f;
	return CGSizeMake(width, width);
}

- (void)updateCellWithObj:(id)obj {
	//fix retina screen image
	CGFloat scale = [UIScreen mainScreen].scale;
	CGSize size = [[self class] sizeForCell];
	CGSize targetSize = CGSizeMake(size.width * scale, size.height * scale);
	[[MISImagePickerManager defaultManager] fetchThumbnailForAsset:obj
														targetSize:targetSize
														completion:^(UIImage *result) {
															self.imageView.image = result;
														}];
}

- (void)setChecked:(BOOL)checked {
	self.checkedButton.selected = checked;
}

@end


@interface MISImagePickerThumbController() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) MISImagePickerBottomBar* footerView;
@property (nonatomic, strong) NSMutableArray* selectedAssets;
@property (nonatomic, copy) NSArray* assets;

@end

@implementation MISImagePickerThumbController

#pragma mark - Lifecycle

- (instancetype)initWithAlbum:(MISImagePickerAlbum *)album {
	self = [super init];
	if (self) {
		self.title = album.title;
		
		self.assets = album.assets;
		
		self.selectedAssets = [NSMutableArray array];
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	
	[self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self updateFooterView];
	[self updateContentView];
}

#pragma mark - Private Methods

/**
 *  更新底栏
 */
- (void)updateFooterView {
	self.footerView.count = self.selectedAssets.count;
}

//更新内容
- (void)updateContentView {
	self.view.hidden = YES;
	
	[self.collectionView reloadData];
	
	//Fix for scrollTo bottom
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		//滑到最下面
		if (self.assets.count > 0) {
			NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:self.assets.count - 1 inSection:0];
			[self.collectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
		}
		
		self.view.hidden = NO;
	});
}


/**
 *  设置子views
 */
- (void)setupSubViews {
	[self.view addSubview:self.collectionView];
	[self.view addSubview:self.footerView];
	
	[self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(MISImagePickerThumbLineSpacing, MISImagePickerThumbLineSpacing, 49.0, MISImagePickerThumbLineSpacing));
	}];
	
	
	[self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(self.view).offset(-IPHONEX_MARGIN_BOTTOM);
		make.height.equalTo(@44.0f);
	}];
}


/**
 *  预览已选择的
 */
- (void)previewSelectedPhotos {
	MISImagePickerPreviewController* controller = [[MISImagePickerPreviewController alloc] init];
	controller.assets = self.selectedAssets;
	controller.selectedAssets = self.selectedAssets;
	controller.maxImageCount = self.maxImageCount;
	__weak __typeof(&*self) weakSelf = self;
	controller.selectedFinishBlock = ^{
		[weakSelf finishSelect];
	};
	[self.navigationController pushViewController:controller animated:YES];
}

/**
 *  点击预览
 */
- (void)previewPhotosWithIndex:(NSInteger)index {
    MISImagePickerPreviewController* controller = [[MISImagePickerPreviewController alloc] init];
    controller.assets                           = self.assets;
    controller.selectedAssets                   = self.selectedAssets;
    controller.maxImageCount                    = self.maxImageCount;
    controller.currentIndex                     = index;
	controller.seletedLimitBlock                = self.seletedLimitBlock;

	__weak __typeof(&*self) weakSelf = self;
	controller.selectedFinishBlock = ^{
		[weakSelf finishSelect];
	};
	[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Event

- (void)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  选择反选
 *
 *  @param index   指定index
 *  @param checked 选择
 */
- (void)checkWithIndex:(NSInteger )index checked:(BOOL)checked {
	id obj = self.assets[index];
	if (checked) {
		if (self.selectedAssets.count == self.maxImageCount) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
			[self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
			
			//回调出去
			BOOL isAlert = YES;
			if (self.seletedLimitBlock) {
				self.seletedLimitBlock (self.maxImageCount, &isAlert);
			}
			if (isAlert) {
				[self showMaxAlertView];
			}
		}else {
			[self.selectedAssets addObject:obj];
		}
	} else {
		[self.selectedAssets removeObject:obj];
	}
	
	self.footerView.count = self.selectedAssets.count;
}

/**
 *  最大选择提示
 */
- (void)showMaxAlertView {
	[MISImagePickerStyle showMaxSeleteAlertWithCount:self.maxImageCount];
}

/**
 *  选择完成
 */
- (void)finishSelect {
	if (!self.selectedFinishBlock) {
		[self dismissViewControllerAnimated:YES completion:nil];
		return;
	}
	
	[self showWait];
	[[MISImagePickerManager defaultManager] scaleImagesForAssets:self.selectedAssets
													   maxSize:self.scaleAspectFitSize
														   scale:self.scale completion:^(NSArray *images) {
															   [self hideWait];
															   
															   [self dismissViewControllerAnimated:YES completion:^{
																   self.selectedFinishBlock (images);
															   }];
														   }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
 	MISImagePickerThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MISImagePickerThumbCell reuseIdentifier] forIndexPath:indexPath];
	cell.tag = indexPath.row + MISImagePickerThumbViewTagOffset;
	id obj = self.assets[indexPath.row];
	[cell updateCellWithObj:obj];
	cell.checked = [self.selectedAssets containsObject:obj];
	
	__weak __typeof(&*self) weakSelf = self;
	cell.checkedBlock = ^(NSInteger index, BOOL isChecked) {
		[weakSelf checkWithIndex:index - MISImagePickerThumbViewTagOffset checked:isChecked];
	};
	
	return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	[self previewPhotosWithIndex:indexPath.row];
}


#pragma mark - Getter & Setter

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
		flowLayout.itemSize = [MISImagePickerThumbCell sizeForCell];
		flowLayout.minimumLineSpacing = MISImagePickerThumbLineSpacing;
		flowLayout.minimumInteritemSpacing = MISImagePickerThumbLineSpacing;
		
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.alwaysBounceVertical = YES;
		_collectionView.backgroundColor = [UIColor whiteColor];
		[_collectionView registerClass:[MISImagePickerThumbCell class] forCellWithReuseIdentifier:[MISImagePickerThumbCell reuseIdentifier]];
	}
	return _collectionView;
}

- (UIView *)footerView {
	if (!_footerView) {
        _footerView = [[MISImagePickerBottomBar alloc] init];
		_footerView.backgroundColor = UIColorFromRGB(0xF9F9F9);
		__weak __typeof(&*self) weakSelf = self;
		_footerView.confirmBlock = ^{
			[weakSelf finishSelect];
		};
		_footerView.previewBlock = ^{
			[weakSelf previewSelectedPhotos];
		};
	}
	return _footerView;
}

@end


