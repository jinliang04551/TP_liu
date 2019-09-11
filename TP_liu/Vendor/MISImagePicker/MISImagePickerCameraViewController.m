
/***********************************************************
 //  MISImagePickerAlbumsController.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerCameraViewController.h"
#import "MISImagePickerCropPreviewViewController.h"
#import "MISImagePickerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MISImagePickerCameraMaskView : UIView

/**
 *  点拍照按钮的回调
 */
@property (nonatomic, copy) void(^tapCaptureBlock)(void);

/**
 *  点取消按钮的回调
 */
@property (nonatomic, copy) void(^tapCancelBlock)(void);

/**
 *  点闪发灯按钮的回调
 */
@property (nonatomic, copy) void(^tapLightBlock)(void);

/**
 *  点相册按钮的回调
 */
@property (nonatomic, copy) void(^tapAlbumBlock)(void);

/**
 *  开关闪发灯
 */
@property (nonatomic) BOOL flashlightOn;

@end

@interface MISImagePickerCameraMaskView()

@property (nonatomic, strong) UIButton* cameraBtn;
@property (nonatomic, strong) UIButton* cancelBtn;
@property (nonatomic, strong) UIButton* girdBtn;
@property (nonatomic, strong) UIButton* lightBtn;
@property (nonatomic, strong) UIButton* albumBtn;
@property (nonatomic, strong) UIView* girdView;
@property (nonatomic, strong) UILabel* noteLabel;

@end

@implementation MISImagePickerCameraMaskView

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self addSubview:self.girdView];
		[self addSubview:self.cameraBtn];
		[self addSubview:self.cancelBtn];
		[self addSubview:self.girdBtn];
		[self addSubview:self.lightBtn];
		[self addSubview:self.albumBtn];
		[self addSubview:self.noteLabel];
        [self listenNotify];
	}
	return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self listenNotify];
    }
    return self;
}

- (void)listenNotify {
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

- (void)addLines {

}

#pragma mark - Getter & Setter

- (UIView *)girdView {
	if (!_girdView) {
		_girdView = [[UIView alloc] initWithFrame:self.frame];
		CGFloat width = CGRectGetWidth(_girdView.frame);
		CGFloat height = CGRectGetHeight(_girdView.frame);
		
		CGFloat lineWidth = 1.0f / [UIScreen mainScreen].scale;
		
		UIView* l1 = [[UIView alloc] initWithFrame:CGRectMake(0, height / 3.0, width, lineWidth)];
		l1.backgroundColor = [UIColor whiteColor];
		l1.alpha = 0.5;
		
		UIView* l2 = [[UIView alloc] initWithFrame:CGRectMake(0, height * 2.0 / 3.0, width, lineWidth)];
		l2.backgroundColor = [UIColor whiteColor];
		l2.alpha = 0.5;
		
		UIView* l3 = [[UIView alloc] initWithFrame:CGRectMake(width / 3.0f, 0, lineWidth, height)];
		l3.backgroundColor = [UIColor whiteColor];
		l3.alpha = 0.5;

		UIView* l4 = [[UIView alloc] initWithFrame:CGRectMake(width * 2.0f / 3.0f, 0, lineWidth, height)];
		l4.backgroundColor = [UIColor whiteColor];
		l4.alpha = 0.5;

		[_girdView addSubview:l1];
		[_girdView addSubview:l2];
		[_girdView addSubview:l3];
		[_girdView addSubview:l4];
	}
	return _girdView;
}

- (UIButton *)cameraBtn {
	if (!_cameraBtn) {
		CGFloat width = CGRectGetWidth(self.frame);
		CGFloat height = CGRectGetHeight(self.frame);
		_cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cameraBtn.frame = CGRectMake(width - 120.0f, (height - 150.0f) / 2.0f, 150.0f, 150.0f);
		[_cameraBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_camera"] forState:UIControlStateNormal];
		[_cameraBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_camera_hl"] forState:UIControlStateHighlighted];
		[_cameraBtn addTarget:self action:@selector(tapCapture) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cameraBtn;
}

- (UIButton *)cancelBtn {
	if (!_cancelBtn) {
		_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cancelBtn.frame = CGRectMake(10.0f, CGRectGetHeight(self.frame) - 55.0f - 10.0f, 55.0f, 55.0f);
		[_cancelBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_close"] forState:UIControlStateNormal];
		[_cancelBtn addTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cancelBtn;
}


- (UIButton *)girdBtn {
	if (!_girdBtn) {
		_girdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_girdBtn.frame = CGRectMake(10.0f, 10.0f, 55.0f, 55.0f);
		[_girdBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_grid_on"] forState:UIControlStateNormal];
		[_girdBtn addTarget:self action:@selector(tapGrid) forControlEvents:UIControlEventTouchUpInside];
	}
	return _girdBtn;
}

- (UIButton *)lightBtn {
	if (!_lightBtn) {
		_lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_lightBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 55.0f - 10.0f, CGRectGetHeight(self.frame) - 55.0f - 10.0f, 55.0f, 55.0f);
		[_lightBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_flashlight_off"] forState:UIControlStateNormal];
		[_lightBtn addTarget:self action:@selector(tapLight) forControlEvents:UIControlEventTouchUpInside];
	}
	return _lightBtn;
}

- (UIButton *)albumBtn {
	if (!_albumBtn) {
		_albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_albumBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - 55.0f - 10.0f, 10.0f, 55.0f, 55.0f);
		[_albumBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_album"] forState:UIControlStateNormal];
		[_albumBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/MISImagePickerAlbumHL"] forState:UIControlStateHighlighted];
		[_albumBtn addTarget:self action:@selector(tapAlbum) forControlEvents:UIControlEventTouchUpInside];
	}
	return _albumBtn;
}

- (UILabel *)noteLabel {
	if (!_noteLabel) {
		_noteLabel = [[UILabel alloc] init];
		_noteLabel.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 65.0f, CGRectGetWidth(self.frame), 20.0f);
		_noteLabel.font  = [UIFont systemFontOfSize:14.0f];
		_noteLabel.textAlignment = NSTextAlignmentCenter;
		_noteLabel.textColor = [UIColor whiteColor];
		_noteLabel.text  = @"请横屏拍照，文字与参考线平行";
	}
	return _noteLabel;
}

- (void)setFlashlightOn:(BOOL)flashlightOn {
	if (flashlightOn) {
		[_lightBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_flashlight_on"] forState:UIControlStateNormal];
		[_lightBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/MISImagePickerFlashlightOnHL"] forState:UIControlStateHighlighted];
	}else {
		[_lightBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_flashlight_off"] forState:UIControlStateNormal];
	}
}

#pragma mark - Event

- (void)tapCapture {
	if (self.tapCaptureBlock) {
		self.tapCaptureBlock();
	}
}

- (void)tapAlbum{
	if (self.tapAlbumBlock) {
		self.tapAlbumBlock();
	}
}

- (void)tapGrid {
	self.girdView.hidden = !self.girdView.hidden;
	
	if (self.girdView.hidden) {
		[self.girdBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_grid_off"] forState:UIControlStateNormal];
	}else {
		[self.girdBtn setImage:[UIImage imageNamed:@"MISImagePicker.bundle/mis_image_picker_grid_on"] forState:UIControlStateNormal];
	}
}

- (void)tapCancel {
	if (self.tapCancelBlock) {
		self.tapCancelBlock();
	}
}

- (void)tapLight {
	if (self.tapLightBlock) {
		self.tapLightBlock();
	}
}

@end

@interface MISImagePickerCameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession             *session;
@property (nonatomic, strong) AVCaptureDeviceInput         *deviceInput;
@property (nonatomic, strong) AVCaptureDevice              *device;
@property (nonatomic, strong) AVCaptureStillImageOutput    *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer   *previewLayer;
@property (nonatomic, strong) UIView                       *cameraShowView;
@property (nonatomic, strong) MISImagePickerCameraMaskView *cameraMaskView;
@end

@implementation MISImagePickerCameraViewController

-(instancetype)init {
	self = [super init];
	if (self) {
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.navigationController setNavigationBarHidden:YES];
	
	[self.view addSubview:self.cameraShowView];
	[self.view addSubview:self.cameraMaskView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self.session stopRunning];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

#pragma mark - Private Methods

/**
 *  拍照
 */
- (void)takePhoto {
    AVCaptureConnection *captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (captureConnection) {
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            //得到图片
            if (imageDataSampleBuffer) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image;
                if (imageData) {
                    image = [UIImage imageWithData:imageData];
                }else {
                    image = [UIImage new];
                }
                [self openCropViewWithImage:image];
            }
        }];
    }
	
}

/**
 *  开关闪光灯
 */
- (void)switchLight {
	if (![self.device hasTorch]) {
		return;
	}
	
	if (self.device.torchMode == AVCaptureTorchModeOn) {
		self.device.torchMode = AVCaptureTorchModeAuto;
	}else {
		self.device.torchMode = AVCaptureTorchModeOn;
	}
	
	//更新闪光灯
	self.cameraMaskView.flashlightOn = [self isLightOn];
}

/**
 *  打开系统相册
 */
- (void)openAlbumImagePicker {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		return;
	}
	
	/**
	 *  检测相册授权
	 */
	[[MISImagePickerManager defaultManager] albumAuthorizationWithAvailableCompletion:^{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:picker animated:YES completion:nil];
	}];
}

/**
 *  是否开着闪发灯
 *
 *  @return 是否
 */
- (BOOL)isLightOn {
	return !!(self.device.torchMode == AVCaptureTorchModeOn);
}

/**
 *  进入图片编辑页面
 *
 *  @param image 传入图片
 */
- (void)openCropViewWithImage:(UIImage *)image {
	MISImagePickerCropPreviewViewController* controller = [[MISImagePickerCropPreviewViewController alloc] init];
	controller.image = image;
	controller.cropFinishBlock = self.cropFinishBlock;
	[self.navigationController pushViewController:controller animated:NO];
}


/**
 *  取消
 */
- (void)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage* image = info[UIImagePickerControllerOriginalImage];
	[self openCropViewWithImage:image];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Getter

/**
 *  录像时显示view
 *
 *  @return view
 */
- (UIView *)cameraShowView {
	if (!_cameraShowView) {
		_cameraShowView = [[UIView alloc] initWithFrame:self.view.bounds];
		self.previewLayer.frame = _cameraShowView.bounds;
		[self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
		[_cameraShowView.layer setMasksToBounds:YES];
		[_cameraShowView.layer insertSublayer:self.previewLayer below:[[_cameraShowView.layer sublayers] objectAtIndex:0]];
	}
	return _cameraShowView;
}

/**
 *  录像会话
 *
 *  @return 录像会话
 */
- (AVCaptureSession *)session {
	if (!_session) {
		_session = [[AVCaptureSession alloc] init];
		//添加输入
		if ([_session canAddInput:self.deviceInput]) {
			[_session addInput:self.deviceInput];
		}
		//添加输出
		if ([_session canAddOutput:self.stillImageOutput]) {
			[_session addOutput:self.stillImageOutput];
		}
	}
	return _session;
}

/**
 *  设备输入
 *
 *  @return 设备输入
 */
- (AVCaptureDeviceInput *)deviceInput {
	if (!_deviceInput) {
		NSError* error = nil;
		_deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
		if (!_deviceInput) {
			NSLog(@"%s, %@", __func__, error);
		}
	}
	return _deviceInput;
}

/**
 *  设备-后摄像头
 *
 *  @return device
 */
- (AVCaptureDevice *)device {
	if (!_device) {
		//获取摄像头-默认是后摄像头
		NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
		for (AVCaptureDevice* device in devices) {
			if (device.position == AVCaptureDevicePositionBack) {
				_device = device;
				break;
			}
		}
		
		//如果没有后摄像头再用前摄像头
		if (!_device) {
			_device = [devices firstObject];
		}
		
		[_device lockForConfiguration:nil];
		
		//自动对焦
		if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			_device.focusMode  = AVCaptureFocusModeContinuousAutoFocus;
		}
	}
	return _device;
}


/**
 * 图片输出
 *
 *  @return 图片输出
 */
- (AVCaptureStillImageOutput *)stillImageOutput {
	if (!_stillImageOutput) {
		_stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
		NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
		//JPEG 输出
		[self.stillImageOutput setOutputSettings:outputSettings];
	}
	return _stillImageOutput;
}

/**
 *  capture video layer
 *
 *  @return
 */
- (AVCaptureVideoPreviewLayer *)previewLayer {
	if (!_previewLayer) {
		_previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	}
	return _previewLayer;
}

- (MISImagePickerCameraMaskView *)cameraMaskView {
	if (!_cameraMaskView) {
		CGFloat width = CGRectGetWidth(self.view.bounds);
		CGFloat height = CGRectGetHeight(self.view.bounds);
		CGRect rect = CGRectMake(0, 0, height, width);
		_cameraMaskView = [[MISImagePickerCameraMaskView alloc] initWithFrame:rect];
		_cameraMaskView.center = CGPointMake(width / 2.0, height/ 2.0f);
		_cameraMaskView.transform  = CGAffineTransformMakeRotation(M_PI_2);
		_cameraMaskView.backgroundColor = [UIColor clearColor];
		
		__weak __typeof(&*self) weakSelf = self;
		
		//取消
		_cameraMaskView.tapCancelBlock = ^{
			[weakSelf cancel];
		};
		
		//拍照
		_cameraMaskView.tapCaptureBlock = ^{
			[weakSelf takePhoto];
		};
		
		//相册
		_cameraMaskView.tapAlbumBlock = ^ {
			[weakSelf openAlbumImagePicker];
		};
		
		//开关闪光灯
		_cameraMaskView.tapLightBlock = ^{
			[weakSelf switchLight];
		};
		
		//设定当前闪光灯
		_cameraMaskView.flashlightOn = [self isLightOn];
	}
	return _cameraMaskView;
}


@end







