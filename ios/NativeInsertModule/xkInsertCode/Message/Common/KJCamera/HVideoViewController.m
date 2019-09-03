//
//  HVideoViewController.m
//  Join
//
//  Created by 黄克瑾 on 2017/1/11.
//  Copyright © 2017年 huangkejin. All rights reserved.
//

#import "HVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HAVPlayer.h"
#import "HProgressView.h"
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Reduce.h"
#import <CoreMotion/CoreMotion.h>

typedef NS_ENUM(NSInteger, SDeviceOrientation) {
  SDeviceOrientationUp,
  SDeviceOrientationDown,
  SDeviceOrientationLeft,
  SDeviceOrientationRight,
};

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface HVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

//轻触拍照，按住摄像
@property (strong, nonatomic) IBOutlet UILabel *labelTipTitle;

//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
/**<##>*/
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
//图片输出流
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;
//重新录制
@property (strong, nonatomic) IBOutlet UIButton *btnAfresh;
//确定
@property (strong, nonatomic) IBOutlet UIButton *btnEnsure;
//摄像头切换
@property (strong, nonatomic) IBOutlet UIButton *btnCamera;

@property (strong, nonatomic) IBOutlet UIImageView *bgView;
//记录录制的时间 默认最大60秒
@property (assign, nonatomic) float seconds;

//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;

//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *afreshCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ensureCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *backCenterX;

//视频播放
@property (strong, nonatomic) HAVPlayer *player;

@property (strong, nonatomic) IBOutlet HProgressView *progressView;

//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (strong, nonatomic) UIImage *takeImage;
@property (strong, nonatomic) UIImageView *takeImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgRecord;

/**<##>*/
@property(nonatomic, strong) CMMotionManager *motionManager;
@property(nonatomic, assign) SDeviceOrientation deviceDirection;
@property(nonatomic, assign) SDeviceOrientation currentDeviceDirection;

@end

//时间大于这个就是视频，否则为拍照
#define TimeMax 0.5

@implementation HVideoViewController


-(void)dealloc{
  [self removeNotification];
  NSLog(@"hview delloc!!!!");
  
}

+ (instancetype) createController {
  return  [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  UIImage *image = [UIImage imageNamed:@"sc_btn_take.png"];
  self.backCenterX.constant = -(SCREEN_WIDTH/2/2)-image.size.width/2/2;
  
  self.progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
  [self startDeviceMotion];
  __weak typeof(self) weakSelf = self;
  dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 6*NSEC_PER_SEC);
  dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [weakSelf hiddenTipsLabel];
  });
  [self.btnBack bringSubviewToFront:self.btnBack.imageView];
  [self.btnAfresh bringSubviewToFront:self.btnAfresh.imageView];
  [self.btnEnsure bringSubviewToFront:self.btnEnsure.imageView];
  [self.btnCamera bringSubviewToFront:self.btnCamera.imageView];
}

- (void)setHSeconds:(float)HSeconds {
  _HSeconds = HSeconds;
  if (self.HSeconds == 0) {
    _HSeconds = 60.0;
  }
}

- (void)hiddenTipsLabel {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.labelTipTitle.hidden = YES;
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self customCamera];
  [self.session startRunning];
  if (self.onlyTakePhoto) {
    self.HSeconds = 0.1;
  }
  self.labelTipTitle.text = @"轻触拍照，长按摄像";
  if (self.onlyTakeVideo) {
    self.labelTipTitle.text = @"长按摄像";
  }
  
  if (self.onlyTakePhoto) {
    self.labelTipTitle.text = @"轻触拍照";
  }
  
}

- (void)setOnlyTakePhoto:(BOOL)onlyTakePhoto {
  _onlyTakePhoto = onlyTakePhoto;
  if (onlyTakePhoto) { // 仅拍照片
    _onlyTakeVideo = NO;
  }
}

- (void)setOnlyTakeVideo:(BOOL)onlyTakeVideo {
  _onlyTakeVideo = onlyTakeVideo;
  if (onlyTakeVideo) { // 仅拍视频
    _onlyTakePhoto = NO;
  }
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [self.session stopRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)startDeviceMotion{
  self.motionManager = [[CMMotionManager alloc] init];
  if (![self.motionManager isDeviceMotionAvailable]) {return;}
  
  [self.motionManager setDeviceMotionUpdateInterval:1.f];
  __weak typeof(self) weakSelf = self;
  [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
    
    double gravityX = motion.gravity.x;
    double gravityY = motion.gravity.y;
    
    if (fabs(gravityY)>=fabs(gravityX)) {
      
      if (gravityY >= 0) {
        
        // UIDeviceOrientationPortraitUpsideDown
        [weakSelf setDeviceDirection:SDeviceOrientationDown];
        NSLog(@"头向下");
        
      } else {
        
        // UIDeviceOrientationPortrait
        [weakSelf setDeviceDirection:SDeviceOrientationUp];
        NSLog(@"竖屏");
      }
      
    } else {
      
      if (gravityX >= 0) {
        // UIDeviceOrientationLandscapeRight
        [weakSelf setDeviceDirection:SDeviceOrientationRight];
        NSLog(@"头向右");
      } else {
        
        // UIDeviceOrientationLandscapeLef
        [weakSelf setDeviceDirection:SDeviceOrientationLeft];
        NSLog(@"头向左");
      }
    }
  }];
}

- (void)customCamera {
  
  //初始化会话，用来结合输入输出
  self.session = [[AVCaptureSession alloc] init];
  //设置分辨率 (设备支持的最高分辨率)
  if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
  }
  //取得后置摄像头
  AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
  //添加一个音频输入设备
  AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
  
  //初始化输入设备
  NSError *error = nil;
  self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
  if (error) {
    //        //Plog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
    return;
  }
  
  //添加音频
  error = nil;
  AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
  if (error) {
    //        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
    return;
  }
  
  //输出对象
  self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
  
  //将输入设备添加到会话
  if ([self.session canAddInput:self.captureDeviceInput]) {
    [self.session addInput:self.captureDeviceInput];
    [self.session addInput:audioCaptureDeviceInput];
    //设置视频防抖
    AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([connection isVideoStabilizationSupported]) {
      connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
    }
  }
  
  //将输出设备添加到会话 (刚开始 是照片为输出对象)
  if ([self.session canAddOutput:self.captureMovieFileOutput]) {
    [self.session addOutput:self.captureMovieFileOutput];
  }
  
  self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  // 这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
  [self.stillImageOutput setOutputSettings:outputSettings];
  
  if ([self.session canAddOutput:self.stillImageOutput]) {
    [self.session addOutput:self.stillImageOutput];
  }
  
  //创建视频预览层，用于实时展示摄像头状态
  self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
  self.previewLayer.frame = self.view.bounds;//CGRectMake(0, 0, self.view.width, self.view.height);
  self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;//填充模式
  [self.bgView.layer addSublayer:self.previewLayer];
  
  
  [self addNotificationToCaptureDevice:captureDevice];
  [self addGenstureRecognizer];
  
  //根据设备输出获得连接
  AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
  //预览图层和视频方向保持一致
  connection.videoOrientation = [self.previewLayer connection].videoOrientation;
}



- (IBAction)onCancelAction:(UIButton *)sender {
  [self.session stopRunning];
  [self.player stopPlayer];
  [self.motionManager stopDeviceMotionUpdates];
  [self dismissViewControllerAnimated:YES completion:^{
    //        [Utility hideProgressDialog];
  }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([[touches anyObject] view] == self.imgRecord) {
    NSLog(@"开始摸");
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
      //如果支持多任务则开始多任务
      if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
      }
      if (self.saveVideoUrl) {
        [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
      }
      
      NSURL *fileUrl=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]];
      AVCaptureConnection *captureConnection = [_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
      if ([captureConnection isVideoOrientationSupported]) {
        captureConnection.videoOrientation = [self getCaptureVideoOrientation];
      }
      
      [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    } else {
      [self.captureMovieFileOutput stopRecording];
    }
  }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([[touches anyObject] view] == self.imgRecord) {
    //        //Plog(@"结束触摸");
    if (self.isVideo) {
      [self endRecord];
    } else {
      if (self.onlyTakeVideo) {
        [self.captureMovieFileOutput stopRecording];
        return;
      }
      [self shutterCamera];
    }
  }
}

#pragma mark - 拍照
- (void)shutterCamera {
  AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
  if (!videoConnection) {
    return;
  }
  self.currentDeviceDirection = self.deviceDirection;
  __weak typeof(self) weakSelf = self;
  [self.stillImageOutput   captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
    if (imageDataSampleBuffer == NULL) {
      return;
    }
    [weakSelf endRecord];
    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
    UIImage *image = [UIImage imageWithData:imageData];
    NSLog(@"image size = %@", NSStringFromCGSize(image.size));
    if (!weakSelf.takeImageView) {
      weakSelf.takeImageView = [[UIImageView alloc] initWithFrame:weakSelf.view.frame];
      weakSelf.takeImageView.contentMode = UIViewContentModeScaleAspectFit;
      [weakSelf.bgView addSubview:weakSelf.takeImageView];
    }
    weakSelf.takeImageView.hidden = NO;
    [weakSelf.previewLayer removeFromSuperlayer];
    UIImage *tempImage = [image fixOrientation];
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (weakSelf.currentDeviceDirection) {
      case SDeviceOrientationLeft:
        orientation = UIImageOrientationLeft;
        break;
      case SDeviceOrientationRight:
        orientation = UIImageOrientationRight;
        break;
      case SDeviceOrientationUp:
        orientation = UIImageOrientationUp;
        break;
      case SDeviceOrientationDown:
        orientation = UIImageOrientationDown;
        break;
        
      default:
        break;
    }
    weakSelf.takeImage = [UIImage imageWithCGImage:tempImage.CGImage scale:[UIScreen mainScreen].scale orientation:orientation];
    weakSelf.takeImageView.image =  weakSelf.takeImage;
  }];
}

- (AVCaptureVideoOrientation)getCaptureVideoOrientation {
  AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
  switch (self.deviceDirection) {
    case SDeviceOrientationLeft:
      orientation = AVCaptureVideoOrientationLandscapeRight;
      break;
    case SDeviceOrientationRight:
      orientation = AVCaptureVideoOrientationLandscapeLeft;
      break;
    case SDeviceOrientationUp:
      orientation = AVCaptureVideoOrientationPortrait;
      break;
    case SDeviceOrientationDown:
      orientation = AVCaptureVideoOrientationPortraitUpsideDown;
      break;
      
    default:
      break;
  }
  return orientation;
}

- (void)endRecord {
  [self.captureMovieFileOutput stopRecording];//停止录制
}

- (IBAction)onAfreshAction:(UIButton *)sender {
  //    //Plog(@"重新录制");
  [self recoverLayout];
}

- (IBAction)onEnsureAction:(UIButton *)sender {
  
  if (self.saveVideoUrl) {
    //        WS(weakSelf)
    sender.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    
    [self compressVideoToMp4:self.saveVideoUrl complete:^(NSString *error, NSURL *url) {
      [[NSFileManager defaultManager] removeItemAtURL:weakSelf.saveVideoUrl error:nil];
      if (error) {
        
      } else {
        if (weakSelf.takeBlock) {
          UIImage *image = [weakSelf getThumbnailImage:url];
          weakSelf.takeBlock(url,image);
        }
        [weakSelf onCancelAction:nil];
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
      });
    }];
  } else {
    //照片
    //        UIImageWriteToSavedPhotosAlbum(self.takeImage, self, nil, nil);
    if (self.takeImage == nil) {
      //
    }
    if (self.takeBlock) {
      self.takeBlock(self.takeImage,nil);
    }
    
    [self onCancelAction:nil];
  }
}

// 压缩视频并转成MP4
- (void)compressVideoToMp4:(NSURL *)url complete:(void(^)(NSString *error, NSURL* url))result {
  AVURLAsset *asset = [AVURLAsset assetWithURL:url];
  
  //保存至沙盒路径
  NSString *videoPath = [[HVideoViewController getRandomPath] stringByAppendingString:@".mp4"];
  
  //转码配置
  AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
  exportSession.shouldOptimizeForNetworkUse = YES;
  exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
  exportSession.outputFileType = AVFileTypeMPEG4;
  [exportSession exportAsynchronouslyWithCompletionHandler:^{
    int exportStatus = exportSession.status;
    switch (exportStatus)
    {
      case AVAssetExportSessionStatusFailed:
      {
        NSError *exportError = exportSession.error;
        result(exportError.localizedDescription,nil);
        break;
      }
      case AVAssetExportSessionStatusCompleted:
      {
        result(nil,[NSURL fileURLWithPath:videoPath]);
        break;
      }
      default:{
        result(@"未知错误，请重试",nil);
      }
    }
  }];
}

//前后摄像头的切换
- (IBAction)onCameraAction:(UIButton *)sender {
  //    //Plog(@"切换摄像头");
  AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
  AVCaptureDevicePosition currentPosition=[currentDevice position];
  [self removeNotificationFromCaptureDevice:currentDevice];
  AVCaptureDevice *toChangeDevice;
  AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
  if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
    toChangePosition = AVCaptureDevicePositionBack;//后
  }
  toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
  [self addNotificationToCaptureDevice:toChangeDevice];
  //获得要调整的设备输入对象
  AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
  
  //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
  [self.session beginConfiguration];
  //移除原有输入对象
  [self.session removeInput:self.captureDeviceInput];
  //添加新的输入对象
  if ([self.session canAddInput:toChangeDeviceInput]) {
    [self.session addInput:toChangeDeviceInput];
    self.captureDeviceInput = toChangeDeviceInput;
  }
  //提交会话配置
  [self.session commitConfiguration];
}

- (void)onStartTranscribe:(NSNumber *)obj {
  if ([self.captureMovieFileOutput isRecording]) {
    self.seconds = self.seconds - obj.floatValue;
    if (self.seconds > 0) {
      if (self.HSeconds - self.seconds >= TimeMax && !self.isVideo) {
        self.isVideo = YES;//长按时间超过TimeMax 表示是视频录制
        NSLog(@"进度开始...");
        self.progressView.timeMax = self.seconds;
      }
      [self performSelector:@selector(onStartTranscribe:) withObject:@(1.0) afterDelay:1.0];
    } else {
      if ([self.captureMovieFileOutput isRecording]) {
        [self shutterCamera];
        [self.captureMovieFileOutput stopRecording];
      }
    }
  }
}


#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
  NSLog(@"开始录制...");
  self.seconds = self.HSeconds - 0.5; // fix
  [self performSelector:@selector(onStartTranscribe:) withObject:@(TimeMax) afterDelay:TimeMax];
}


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
  NSLog(@"视频录制完成.");
  if (self.isVideo) {
    [self changeLayout];
    self.saveVideoUrl = outputFileURL;
    if (!self.player) {
      self.player = [[HAVPlayer alloc] initWithFrame:self.bgView.bounds withShowInView:self.bgView url:outputFileURL];
    } else {
      if (outputFileURL) {
        self.player.videoUrl = outputFileURL;
        self.player.hidden = NO;
      }
    }
    if (outputFileURL) {
      [self.previewLayer removeFromSuperlayer];
    }
  } else {
    [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
    [self changeLayoutForPhoto];
    self.saveVideoUrl = nil;
  }
}

- (void)changeLayoutForPhoto {
  if (!self.onlyTakeVideo) {
    [self changeLayout];
  }
}

- (UIImage *)getThumbnailImage:(NSURL *)videoURL
{
  AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
  AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  gen.appliesPreferredTrackTransform = YES;
  CMTime time = CMTimeMakeWithSeconds(0.0, 600);
  NSError *error = nil;
  CMTime actualTime;
  CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
  UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
  CGImageRelease(image);
  
  return thumb;
}

#pragma mark - 通知

//注册通知
- (void)setupObservers
{
  NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
  [notification addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

//进入后台就退出视频录制
- (void)applicationDidEnterBackground:(NSNotification *)notification {
  [self onCancelAction:nil];
}

/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
  //注意添加区域改变捕获通知必须首先设置设备允许捕获
  [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
    captureDevice.subjectAreaChangeMonitoringEnabled=YES;
  }];
  NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
  //捕获区域发生改变
  [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
  NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
  [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
  NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
  [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
  NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
  //会话出错
  [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
  NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
  NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
  //    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
  NSLog(@"会话发生错误.");
}



/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
  NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  for (AVCaptureDevice *camera in cameras) {
    if ([camera position] == position) {
      return camera;
    }
  }
  return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
  AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
  NSError *error;
  //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
  if ([captureDevice lockForConfiguration:&error]) {
    //自动白平衡
    if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
      [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
    }
    //自动根据环境条件开启闪光灯
    if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
      [captureDevice setFlashMode:AVCaptureFlashModeAuto];
    }
    
    propertyChange(captureDevice);
    [captureDevice unlockForConfiguration];
  }else{
    NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
  }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
  [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
    if ([captureDevice isFlashModeSupported:flashMode]) {
      [captureDevice setFlashMode:flashMode];
    }
  }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
  [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
    if ([captureDevice isFocusModeSupported:focusMode]) {
      [captureDevice setFocusMode:focusMode];
    }
  }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
  [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
    if ([captureDevice isExposureModeSupported:exposureMode]) {
      [captureDevice setExposureMode:exposureMode];
    }
  }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
  [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
    //        if ([captureDevice isFocusPointOfInterestSupported]) {
    //            [captureDevice setFocusPointOfInterest:point];
    //        }
    //        if ([captureDevice isExposurePointOfInterestSupported]) {
    //            [captureDevice setExposurePointOfInterest:point];
    //        }
    if ([captureDevice isExposureModeSupported:exposureMode]) {
      [captureDevice setExposureMode:exposureMode];
    }
    if ([captureDevice isFocusModeSupported:focusMode]) {
      [captureDevice setFocusMode:focusMode];
    }
  }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
  UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
  [self.bgView addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
  if ([self.session isRunning]) {
    CGPoint point= [tapGesture locationInView:self.bgView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
  }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
  if (!self.isFocus) {
    self.isFocus = YES;
    self.focusCursor.center=point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.focusCursor.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
      self.focusCursor.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
      [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
    }];
  }
}

- (void)onHiddenFocusCurSorAction {
  self.focusCursor.alpha=0;
  self.isFocus = NO;
}

//拍摄完成时调用
- (void)changeLayout {
  self.imgRecord.hidden = YES;
  self.btnCamera.hidden = YES;
  self.btnAfresh.hidden = NO;
  self.btnEnsure.hidden = NO;
  self.btnBack.hidden = YES;
  if (self.isVideo) {
    [self.progressView clearProgress];
  }
  self.afreshCenterX.constant = -(SCREEN_WIDTH/2/2);
  self.ensureCenterX.constant = SCREEN_WIDTH/2/2;
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
  
  self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
  self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
  [self.session stopRunning];
}


//重新拍摄时调用
- (void)recoverLayout {
  if (self.isVideo) {
    self.isVideo = NO;
    [self.player stopPlayer];
    self.player.hidden = YES;
    [self.bgView.layer addSublayer:self.previewLayer];
  }
  [self.session startRunning];
  
  if (!self.takeImageView.hidden) {
    self.takeImageView.hidden = YES;
    [self.bgView.layer addSublayer:self.previewLayer];
  }
  //    self.saveVideoUrl = nil;
  self.afreshCenterX.constant = 0;
  self.ensureCenterX.constant = 0;
  self.imgRecord.hidden = NO;
  self.btnCamera.hidden = NO;
  self.btnAfresh.hidden = YES;
  self.btnEnsure.hidden = YES;
  self.btnBack.hidden = NO;
  [UIView animateWithDuration:0.25 animations:^{
    [self.view layoutIfNeeded];
  }];
}

+ (NSString *)getTmpCachePath {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"takeVideoCache"]; // 路径
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { // 文件夹不存在
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (!bo) {
      NSLog(@"%@文件夹创建失败",path);
    }
  }
  return path;
}

+ (NSString *)getRandomAfter {
  return [NSString stringWithFormat:@"%@_%d",[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]] ,arc4random()%100000];
}

+ (NSString *)getRandomPath {
  return [[HVideoViewController getTmpCachePath] stringByAppendingPathComponent:[HVideoViewController getRandomAfter]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
