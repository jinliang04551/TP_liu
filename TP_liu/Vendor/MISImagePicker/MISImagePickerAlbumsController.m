
/***********************************************************
 //  MISImagePickerAlbumsController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerAlbumsController.h"
#import "MISImagePickerThumbController.h"
#import <Photos/Photos.h>
#import "MISImagePickerAlbum.h"
#import "MISImagePickerManager.h"
#import <Masonry/Masonry.h>
#import "UIViewController+MISHUD.h"



static NSString* MISImageGroupCellReuseIndetifier = @"MISImageGroupCell";
static CGFloat MISImageGroupCellHeight = 55.0f;



@interface MISImageGroupCell : UITableViewCell

@property (nonatomic, strong) UIImageView* posterImageView;
@property (nonatomic, strong) UILabel* titleLabel;

/**
 *  高度
 *
 *  @return 高度
 */
+ (CGFloat )heightForCell;

/**
 *  复用标识
 *
 *  @return string
 */
+ (NSString *)reuseIdentifier;

/**
 *  更新cell
 *
 *  @param album
 */
- (void)updateCellWithAlbum:(MISImagePickerAlbum *)album;

@end


@implementation MISImageGroupCell

+ (CGFloat )heightForCell {
	return MISImageGroupCellHeight;
}

+ (NSString *)reuseIdentifier {
	return MISImageGroupCellReuseIndetifier;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		[self.contentView addSubview:self.posterImageView];
		
		[self.contentView addSubview:self.titleLabel];
		
		[self setupLayout];
	}
	return self;
}

- (void)setupLayout {
	[self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(@([[self class] heightForCell]));
		make.left.equalTo(self.contentView);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
	}];
	
	[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.posterImageView.mas_right).offset(10);
		make.top.equalTo(self.contentView);
		make.bottom.equalTo(self.contentView);
		make.right.equalTo(self.contentView);
	}];
}

- (void)updateCellWithAlbum:(MISImagePickerAlbum *)album {
	//封面
	self.posterImageView.image =  album.posterImage;
	
	//名称+个数
	NSString* groupName = album.title;
	self.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", groupName, @(album.assets.count)];
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] init];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.textColor = [UIColor blackColor];
		_titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	return _titleLabel;
}

- (UIImageView *)posterImageView {
	if (!_posterImageView) {
		_posterImageView = [[UIImageView alloc] init];
		_posterImageView.translatesAutoresizingMaskIntoConstraints = NO;
		_posterImageView.contentMode  = UIViewContentModeScaleAspectFill;
		_posterImageView.clipsToBounds = YES;
	}
	return _posterImageView;
}

@end



@interface MISImagePickerAlbumsController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* table;
@property (nonatomic, copy) NSArray* albums;
@end



@implementation MISImagePickerAlbumsController

#pragma mark - Lifecycle
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
	
	[self setupView];
	
	[self prepareData];
}


#pragma mark - Private Methods

- (void)setupView {
	self.title = @"照片";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];

	[self.view addSubview:self.table];
	
	[self.table mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

/**
 *  获到组列表信息
 */
- (void)prepareData {
	MISImagePickerManager* manager = [MISImagePickerManager defaultManager];
	if (manager.albums.count > 0) {
		self.albums = manager.albums;//拿到数据
		//更新界面
		[self updateUI];
	}else {
		[self showWait];
		[manager fetchAlbumsWithCompletion:^{
			[self hideWait];
			
			self.albums = manager.albums;//拿到数据
			//更新界面
			[self updateUI];
		}];
	}
}

- (void)updateUI {
	[self.table reloadData];
	
	//进入最多照片一个相册
	if (self.albums.count > 0) {
		MISImagePickerAlbum* maxAlbum = self.albums[0];
		for (MISImagePickerAlbum* album in self.albums) {
			if (maxAlbum.assets.count < album.assets.count) {
				maxAlbum = album;
			}
		}
		
		[self pushThumbPageWithAlbum:maxAlbum animated:NO];
	}
}

/**
 *  打开缩略图界面
 *
 *  @param album    相册
 *  @param animated 动画
 */
- (void)pushThumbPageWithAlbum:(MISImagePickerAlbum *)album animated:(BOOL)animated{
	MISImagePickerThumbController* controller = [[MISImagePickerThumbController alloc] initWithAlbum:album];
	controller.selectedFinishBlock            = self.selectedFinishBlock;
	controller.seletedLimitBlock              = self.seletedLimitBlock;
	controller.maxImageCount                  = self.maxImageCount;
	controller.scaleAspectFitSize             = self.scaleAspectFitSize;
	controller.scale                          = self.scale;
	
	[self.navigationController pushViewController:controller animated:animated];
}

#pragma mark - Event

- (void)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Getter & Setter

- (UITableView *)table {
	if (!_table) {
		_table = [[UITableView alloc] init];
		_table.delegate = self;
		_table.dataSource = self;
		_table.rowHeight = [MISImageGroupCell heightForCell];
		[_table registerClass:[MISImageGroupCell class] forCellReuseIdentifier:[MISImageGroupCell reuseIdentifier]];
	}
	return _table;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MISImageGroupCell* cell = [tableView dequeueReusableCellWithIdentifier:[MISImageGroupCell reuseIdentifier]];

	[cell updateCellWithAlbum:self.albums[indexPath.row]];
	
	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self pushThumbPageWithAlbum:self.albums[indexPath.row] animated:YES];
}

@end
