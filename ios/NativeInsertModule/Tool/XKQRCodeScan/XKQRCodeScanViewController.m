//
//  XKQRCodeScanViewController.m
//  QRCodeScan
//
//  Created by hupan on 2018/7/24.
//  Copyright © 2018年 hupan. All rights reserved.
//

#import "XKQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XKQRCodeScanBackView.h"
#import "XKQRCodeCardController.h"
#import "XKAuthorityTool.h"
@interface XKQRCodeScanViewController () <AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) AVCaptureSession        *session;
@property (nonatomic, strong) UIImageView             *scanImgView;
@property (nonatomic, assign) CGRect                  avplayerlayerframe;
@property (nonatomic, strong) NSTimer                 *timer;
@property (nonatomic, strong) XKQRCodeScanBackView    *backView;
@property (nonatomic, strong) UIButton                *lightButton;
@property (nonatomic, strong) UIButton                *photoBtn;
@property (nonatomic, assign) BOOL                    closeLight;





@end

@implementation XKQRCodeScanViewController


#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.autoRemove = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBar];
    [self createCapture];
    [self configButtomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.session) {
        [self.session startRunning];
    }
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.navigationController) { // 有代表不是自己pop了
        if (self.presentedViewController) { //present出来了控制器
            //
        } else { // push了新界面 移除自己
            if ([self.navigationController.viewControllers.lastObject isKindOfClass:[XKQRCodeCardController class]]) { // 内部自己push的个人码
                [NSObject removeVCFromCurrentStack:self];
            } else {
                if (self.autoRemove) {
                    [NSObject removeVCFromCurrentStack:self];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Metheods

- (void)configNavigationBar {
    
    if (self.vcType == QRCodeScanVCType_QRScan) {
        [self setNavTitle:@"二维码" WithColor:[UIColor whiteColor]];
        [self setNaviCustomView:self.photoBtn withframe:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 30)];
        
    } else if (self.vcType == QRCodeScanVCType_Recharge) {
        [self setNavTitle:@"晓可币充值" WithColor:[UIColor whiteColor]];
        [self setNaviCustomView:self.photoBtn withframe:CGRectMake(SCREEN_WIDTH - 50, 0, 40, 30)];
        
    } else if (self.vcType == QRCodeScanVCType_buyGoods) {
        [self setNavTitle:@"扫描商家二维码" WithColor:[UIColor whiteColor]];
    }
}

- (void)createCapture {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) {
        [self showSureAlertControllerWithTitle:@"温馨提示" message:@"该设备不支持相机功能" popViewController:YES sessionRun:NO];
        
    } else {
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (!input) {
//            [self showSureAlertControllerWithTitle:@"温馨提示" message:@"请向晓可广场开放相机权限：手机设置->隐私->相机->晓可广场(打开)" popViewController:YES sessionRun:NO];
            [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeCamera needGuide:YES has:nil hasnt:nil];
        } else {
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            
            AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
            [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
            [self.session addInput:input];
            [self.session addOutput:output];
            [self.session addOutput:videoDataOutput];
            
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            CGRect frame = CGRectMake(screenSize.width / 6, screenSize.height / 2 - screenSize.width / 2, screenSize.width / 3 * 2, screenSize.width / 3 * 2);
            self.avplayerlayerframe = CGRectMake(frame.origin.x, frame.origin.y+NavigationAndStatue_Height, frame.size.width, frame.size.height);
            
            AVCaptureVideoPreviewLayer *videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            videoPreviewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view.layer insertSublayer:videoPreviewLayer atIndex:0];
        
            
            [self.view addSubview:self.backView];
            
            NSArray *imageArray = @[@[@"xk_iocn_QR_leftTop", @"xk_iocn_QR_leftBottom"], @[@"xk_iocn_QR_rightTop", @"xk_iocn_QR_rightBottom"]];
            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < 2; j++) {
                    UIImageView *angleImageView = [[UIImageView alloc] init];
                    angleImageView.frame = CGRectMake(screenSize.width / 2 - frame.size.width / 2 + (screenSize.width / 3 * 2 - 15) * i, screenSize.height / 2 - frame.size.height / 2 + (screenSize.width / 3 * 2 - 15) * j , 15, 15);
                    angleImageView.image = [UIImage imageNamed:imageArray[i][j]];
                    [self.view addSubview:angleImageView];
                }
            }
            [self.view addSubview:self.scanImgView];
        }
    }
}

- (void)configButtomView {
    
    /*
    CGFloat bottomViewHeight = 90;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - bottomViewHeight, SCREEN_WIDTH, bottomViewHeight)];
    bottomView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bottomView];
    
    CGFloat buttonWidth = SCREEN_WIDTH/2;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.frame.size.width/2 - buttonWidth/2, 0, buttonWidth, bottomViewHeight)];
    button = [self configButton:button];
    [bottomView addSubview:button];*/
    
    
    
    [self.view addSubview:[self configButton:self.lightButton]];
    
    UIButton *myQRBtn;
    
    if (self.vcType == QRCodeScanVCType_QRScan) {
        myQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, CGRectGetMaxY(self.avplayerlayerframe)-NavigationAndStatue_Height + 20, 100, 40)];
        [myQRBtn addTarget:self action:@selector(myQRBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myQRBtn setTitle:@"我的二维码" forState:(UIControlStateNormal)];
        myQRBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:14];
        myQRBtn.layer.cornerRadius = 20;

    } else if (self.vcType == QRCodeScanVCType_Recharge) {
        myQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, CGRectGetMaxY(self.avplayerlayerframe)-NavigationAndStatue_Height + 20, 160, 30)];
        [myQRBtn setTitle:@"请对准二维码/条形码，耐心等待" forState:(UIControlStateNormal)];
        myQRBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Regular andSize:10];
        myQRBtn.layer.cornerRadius = 15;
        
        UIButton *scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 40, SCREEN_WIDTH, 30)];
        [scanBtn setTitle:@"  扫一扫充值" forState:UIControlStateNormal];
        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        scanBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:14];
        [scanBtn setImage:[UIImage imageNamed:@"xk_btn_home_scan"] forState:UIControlStateNormal];
        [self.view addSubview:scanBtn];

    }
    myQRBtn.layer.masksToBounds = YES;
    myQRBtn.backgroundColor = HEX_RGBA(0x000000, 0.8);
    [myQRBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.backView addSubview:myQRBtn];
}

- (void)startTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(transformScanImgView) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)transformScanImgView {
    
    CGFloat y = self.scanImgView.y + 1;
    if (y >= self.avplayerlayerframe.origin.y + self.avplayerlayerframe.size.height) {
        y = self.avplayerlayerframe.origin.y;
    }
    self.scanImgView.frame = CGRectMake(self.scanImgView.x, y, self.scanImgView.width, self.scanImgView.height);
}

- (UIButton *)configButton:(UIButton *)btn {
    
    if (self.vcType == QRCodeScanVCType_QRScan || self.vcType == QRCodeScanVCType_Recharge || self.vcType == QRCodeScanVCType_buyGoods) {
        [btn setImage:[UIImage imageNamed:@"xk_btn_QR_light"] forState:UIControlStateNormal];
        [btn setTitle:@"打开手电筒" forState:UIControlStateNormal];
        [btn setTitle:@"关闭手电筒" forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(turnOnOrOffLight:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setImageAtTopAndTitleAtBottomWithSpace:5.0];
    
    return btn;
}


- (void)showSureAlertControllerWithTitle:(NSString *)title message:(NSString *)message popViewController:(BOOL)pop sessionRun:(BOOL)sessionRun {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (pop) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if (sessionRun) {
            [self.session startRunning];
        }
    }];
    [alertVC addAction:sure];
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - Events
- (void)selectPhotoAlbumPhotos {
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)turnOnOrOffLight:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
    } else {//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
            self.closeLight = YES;
        }
    }
}

- (void)myQRBtnClicked:(UIButton *)sender {
    
    XKQRCodeCardController *vc = [[XKQRCodeCardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Delegate

#pragma mark -- AVCaptureVideoDataOutputSampleBufferDelegate
/** 此方法会实时监听亮度值 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    
    // 亮度值
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (brightnessValue < 0 && !self.closeLight) {
        //
        if (!self.lightButton.selected) {
            [self turnOnOrOffLight:self.lightButton];
        }
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];

        if (metadataObject.stringValue) {
            
            if (self.scanResult) {
                self.scanResult(metadataObject.stringValue);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.session startRunning];
                });
            }
        } else {
            [self showSureAlertControllerWithTitle:nil message:@"未识别出数据" popViewController:NO sessionRun:YES];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    // 2.从选中的图片中读取二维码数据
    // 2.1创建一个探测器 ,使用 CIDetector 处理 图片
    
    //CIDetectorAccuracyHigh  识别精度高，但识别速度慢、性能低
    //CIDetectorAccuracyLow  识别精度低，但识别速度快、性能高
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options: @{CIDetectorAccuracy:CIDetectorAccuracyLow}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    __block typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        if (feature.count == 0) {
            [weakSelf showSureAlertControllerWithTitle:nil message:@"未识别出数据" popViewController:NO sessionRun:YES];
            return;
        }
        // 2.3取出探测到的数据
        for (CIQRCodeFeature *result in feature) {
            // NSLog(@"%@",result.messageString);
            NSString *str = result.messageString;
//            NSLog(@"\n str=: %@",str);
            if (str) {
                if (self.scanResult) {
                    self.scanResult(str);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.session startRunning];
                    });
                }
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Lazy load

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}


- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        
        // 获取支持的媒体格式
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        // 判断是否支持需要设置的sourceType
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            _imagePickerController = [[UIImagePickerController alloc] init];
            _imagePickerController.delegate = self;
            // _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//翻转效果
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePickerController.mediaTypes = @[mediaTypes[0]];
            _imagePickerController.allowsEditing = NO;
        }
    }
    
    return _imagePickerController;
}


- (UIImageView *)scanImgView {
    if (!_scanImgView) {
        _scanImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.avplayerlayerframe.origin.x, self.avplayerlayerframe.origin.y, self.avplayerlayerframe.size.width, 2)];
        _scanImgView.image = [UIImage imageNamed:@"xk_iocn_QR_sacn"];
    }
    return _scanImgView;
}

- (XKQRCodeScanBackView *)backView {
    
    if (!_backView) {
        _backView = [[XKQRCodeScanBackView alloc] initWithFrame:CGRectMake(0, NavigationAndStatue_Height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _backView;
}

- (UIButton *)lightButton {
    if (!_lightButton) {
        CGFloat buttonWidth = 180;
        CGFloat bottomHeight = 90;
        _lightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - buttonWidth/2, CGRectGetMaxY(self.backView.frame) - NavigationBar_HEIGHT - bottomHeight-30 -kBottomSafeHeight, buttonWidth, bottomHeight)];
    }
    return _lightButton;
}

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
        [_photoBtn setTitle:@"相册" forState:UIControlStateNormal];
        _photoBtn.titleLabel.font = [UIFont setFontWithFontName:XK_PingFangSC_Medium andSize:17];
        [_photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(selectPhotoAlbumPhotos) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

@end
