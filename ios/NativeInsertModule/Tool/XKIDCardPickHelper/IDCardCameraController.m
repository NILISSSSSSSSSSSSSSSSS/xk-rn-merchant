//
//  IDCardViewController.m
//  Erp4iOS
//
//  Created by leocll on 9/11/16.
//  Copyright © 2016年  All rights reserved.
//
@import MobileCoreServices;
@import ImageIO;
#import "IDCardCameraController.h"
//#import "UIImage+Repair.h"
#import "UIImage+Reduce.h"
//#import <HFTCategroy/UIImageView+Tool.h>
#import "UIImage+Edit.h"
//#import "MineHeader.h"

@interface IDCardCameraController ()
{
    Capture *_capture;
    UIView *_cameraView;
    unsigned char* _buffer;
    
    //聚焦View
    UIView *_focusView;
    
    UIImageView *coverImageView; //蒙层
    UILabel *userPrompt; //拍用户时的提示
    UILabel *cardPrompt1; //拍身份证时的第一行提示
    UILabel *cardPrompt2; //拍身份证时的第二行提示
}
/** 导航栏*/
@property (nonatomic, strong) UIView *naviView;
/** 底部视图*/
@property (nonatomic, strong) UIView *bottomView;
/** 取消*/
@property (nonatomic, strong) UIButton *cancelBtn;
/** 重拍*/
@property (nonatomic, strong) UIButton *startBtn;
/** 拍摄*/
@property (nonatomic, strong) UIButton *caprureBtn;
/** 使用*/
@property (nonatomic, strong) UIButton *useBtn;
/** 拍摄的照片*/
@property (nonatomic, strong) UIImage *image;

@end

@implementation IDCardCameraController

#pragma mark - getter 底部视图
- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat bottomH = 85;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-bottomH, self.view.width, bottomH)];
        _bottomView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_bottomView];
        //取消
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20, (bottomH-20)*0.5, 40, 40);
        [_bottomView addSubview:btn];
        self.cancelBtn = btn;
        //重拍
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitle:@"重拍" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20, (bottomH-20)*0.5, 40, 40);
        [_bottomView addSubview:btn];
        self.startBtn = btn;
        //拍摄
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[IMG_NAME(@"mine_idcard_takephoto") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(caprureAction) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake((_bottomView.width-bottomH+10)*0.5, 5, bottomH-10, bottomH-10);
        [_bottomView addSubview:btn];
        self.caprureBtn = btn;
        //使用
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 111;
        btn.hidden = YES;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitle:@"使用" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(_bottomView.width-60, (bottomH-20)*0.5, 40, 40);
        [_bottomView addSubview:btn];
        self.useBtn = btn;
    }
    return _bottomView;
}

#pragma mark - 导航视图
- (UIView *)naviView {
    if (_naviView == nil) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
        _naviView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_naviView];
    }
    return _naviView;
}

static Boolean init_flag = false;
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!init_flag) {
				
        init_flag = true;
    }
    //初始化相机
    [self initCapture];
    //顶部视图
    [self.view addSubview:self.naviView];
    //底部视图
    [self.view addSubview:self.bottomView];
    
}

- (void)dealloc {
	NSLog(@"========%@被销毁了=========", [self class]);
}

#pragma mark - 使用&取消事件
- (void)closeAction:(UIButton *)btn {
    
    if (btn.tag == 111) {
        if (self.image != nil && [self.delegate respondsToSelector:@selector(captureWithImage:)]) {
            UIImage *originalImage = self.image;
            UIImage *screenImage = [originalImage imageScaledToSize:self.view.bounds.size];
            UIImage *coverImage  = [screenImage imageCutToRect:coverImageView.frame];
            UIImage *idcardIamge = [coverImage imageCutToRect:[self idcardRect]];
            UIImage *rotationImage = [[self class] image:idcardIamge rotation:UIImageOrientationLeft];
            [self.delegate captureWithImage:rotationImage];
        }
    }
	[self removeCapture];
    [self dismissViewControllerAnimated:NO completion:nil];
    if(init_flag){
		
		
        init_flag = false;
    }
}

#pragma mark - 拍摄事件
- (void)caprureAction {
    [_capture captureImage];
    self.cancelBtn.hidden = YES;
    self.useBtn.hidden = NO;
    self.caprureBtn.hidden = YES;
    self.startBtn.hidden = NO;
    coverImageView.hidden = YES;
}

#pragma mark - 重拍事件
- (void)startAction {
    [_capture reStartRunning];
    self.cancelBtn.hidden = NO;
    self.useBtn.hidden = YES;
    self.caprureBtn.hidden = NO;
    self.startBtn.hidden = YES;
    coverImageView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self initCapture];
    //蒙层
    if (coverImageView == nil) {
        coverImageView = [[UIImageView alloc] init];
        coverImageView.frame = _cameraView.frame;
        coverImageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:coverImageView];
        //拍用户时的提示
        userPrompt = [[UILabel alloc] init];
        userPrompt.hidden = YES;
        userPrompt.text = [self getUserPromptString];
        userPrompt.textAlignment = NSTextAlignmentCenter;
        userPrompt.textColor = [UIColor whiteColor];
        userPrompt.font = [UIFont systemFontOfSize:13];
        userPrompt.frame = CGRectMake(0, 20, coverImageView.width, 14);
        [coverImageView addSubview:userPrompt];
        //拍身份证时的第一行提示
        cardPrompt1 = [[UILabel alloc] init];
        cardPrompt1.hidden = YES;
		cardPrompt1.text = [self getCardPromptTopString];
        cardPrompt1.textAlignment = NSTextAlignmentCenter;
        cardPrompt1.textColor = RGB(255, 120, 0);
        cardPrompt1.font = [UIFont systemFontOfSize:15];
        cardPrompt1.frame = CGRectMake(0, 15, coverImageView.width, 15);
        [coverImageView addSubview:cardPrompt1];
        //拍身份证时的第二行提示
        cardPrompt2 = [[UILabel alloc] init];
        cardPrompt2.hidden = YES;
        cardPrompt2.text = @"将身份证置于虚线框内，确保文字清晰";
        cardPrompt2.textAlignment = NSTextAlignmentCenter;
        cardPrompt2.textColor = RGB(208, 208, 208);
        cardPrompt2.font = [UIFont systemFontOfSize:13];
        cardPrompt2.frame = CGRectMake(0, cardPrompt1.bottom+10, coverImageView.width, 14);
        [coverImageView addSubview:cardPrompt2];
    }
    if (self.captureType == CaptureTypeUser) {
        coverImageView.image = [UIImage imageNamed:@"IDCard_mengchen2_"];
        userPrompt.hidden = NO;
    } else if (self.captureType == CaptureTypeCard) {
        coverImageView.image = IMG_NAME(@"mine_idcard_mengchen");
        cardPrompt1.hidden = NO;
        cardPrompt2.hidden = NO;
	} else {
        [coverImageView removeFromSuperview];
    }
    [self startAction];
}

- (NSString *)getUserPromptString {
     if (_captureType == CaptureTypeUser) {
		return @"拍照时请尽量选择纯色背景";
	}
	return @"";
}

- (NSString *)getCardPromptTopString {
	if (_captureType == CaptureTypeCard) {
		return @"拍摄身份证人像面";
	}
	return @"拍摄身份证人像面";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Capture

- (void)initCapture
{
    // init capture manager
    _capture = [[Capture alloc] init];
    
    _capture.delegate = self;
    _capture.verify = NO;
	_capture.isParsing = _captureType == CaptureTypeCard ? YES : NO;
    // set video streaming quality
    // AVCaptureSessionPresetHigh   1280x720
    // AVCaptureSessionPresetPhoto  852x640
    // AVCaptureSessionPresetMedium 480x360
    _capture.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    //kCVPixelFormatType_32BGRA
    [_capture setOutPutSetting:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]];
    
    // AVCaptureDevicePositionBack
    // AVCaptureDevicePositionFront
    if (self.captureType == CaptureTypeUser) {//前摄像头
        [_capture addVideoInput:AVCaptureDevicePositionFront];
    } else if (self.captureType == CaptureTypeCard ) {//后摄像头
        [_capture addVideoInput:AVCaptureDevicePositionBack];
    } else {
        [_capture addVideoInput:AVCaptureDevicePositionBack];
    }

    [_capture addVideoOutput];
    [_capture addStillImageOutput];
    [_capture addVideoPreviewLayer];
    
    CGRect layerRect = CGRectMake(0, self.naviView.bottom, self.view.width, self.view.height-self.naviView.height-self.bottomView.height);//self.view.bounds;
    [[_capture previewLayer] setOpaque: 0];
    [[_capture previewLayer] setBounds:layerRect];
    [[_capture previewLayer] setPosition:CGPointMake(self.view.width*0.5, layerRect.size.height*0.5)];
    
    [_capture setvideoScale];
    
    // create a view, on which we attach the AV Preview layer
    CGRect frame = layerRect;//self.view.bounds;
    _cameraView = [[UIView alloc] initWithFrame:frame];
    _cameraView.backgroundColor = [UIColor blackColor];
    [[_cameraView layer] addSublayer:[_capture previewLayer]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [_cameraView addGestureRecognizer:singleTap];
    
    [self initFocusView];
    
    // add the view we just created as a subview to the View Controller's view
    [self.view addSubview: _cameraView];
    [self.view sendSubviewToBack:_cameraView];
    
    // start !
//    [self performSelectorInBackground:@selector(startCapture) withObject:nil];
}

-(void)initFocusView
{
    _focusView = [[UIView alloc] init];
    _focusView.frame = CGRectMake(0, 0, 80, 80);
    _focusView.backgroundColor = [UIColor clearColor];
    _focusView.layer.borderColor = [UIColor whiteColor].CGColor;
    _focusView.layer.borderWidth = 1;
    _focusView.layer.masksToBounds = YES;
    _focusView.layer.cornerRadius = _focusView.frame.size.width/2;
    
    UIView *smallView = [[UIView alloc] init];
    smallView.frame = CGRectMake(_focusView.frame.size.width/2 - 64/2, _focusView.frame.size.height/2 - 64/2, 64, 64);
    smallView.backgroundColor = [UIColor clearColor];
    smallView.layer.borderColor = [UIColor whiteColor].CGColor;
    smallView.layer.borderWidth = 2;
    smallView.layer.masksToBounds = YES;
    smallView.layer.cornerRadius = smallView.frame.size.width/2;
    smallView.alpha = 0.7f;
    [_focusView addSubview:smallView];
}


- (void)removeCapture
{
    [_capture.captureSession stopRunning];
    [_cameraView removeFromSuperview];
    _capture     = nil;
    _cameraView  = nil;
}

- (void)startCapture
{
    //@autoreleasepool
    {
        [[_capture captureSession] startRunning];
    }
}

//单机
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    
    CGPoint point = [gestureRecognizer locationInView:_cameraView.superview];
    
    NSLog(@"point = %f,%f",point.x,point.y);
    
    CGPoint focuspoint = CGPointMake(point.x/_cameraView.frame.size.width, point.y/_cameraView.frame.size.height);
    [_capture focusInPoint:focuspoint];
    
    [self showFocusView:point];
}

-(void)showFocusView:(CGPoint )point
{
    [_focusView.layer removeAllAnimations];
    [_focusView removeFromSuperview];
    _focusView.center = point;
    _focusView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _focusView.alpha = 1;
    [_cameraView addSubview:_focusView];
    
    [UIView animateWithDuration:0.52f
                          delay:0.0
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState |
     UIViewAnimationOptionCurveEaseInOut |
     UIViewAnimationOptionOverrideInheritedDuration
                     animations:^{
                         
                         self->_focusView.transform = CGAffineTransformMakeScale(1, 1);
                         
                     } completion:^(BOOL finished) {
                         
                         if(finished) {
                             [UIView animateWithDuration:0.52f
                                                   delay:0.0
                                  usingSpringWithDamping:0.4f
                                   initialSpringVelocity:0.f
                                                 options:UIViewAnimationOptionBeginFromCurrentState |
                              UIViewAnimationOptionCurveEaseInOut |
                              UIViewAnimationOptionOverrideInheritedDuration
                                              animations:^{
                                                  self->_focusView.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  
                                                  if(finished) {
                                                      [self->_focusView removeFromSuperview];
                                                  }
                                              }];
                         }
                     }];
}


#pragma mark - Capture Delegates

- (void)captureImage:(UIImage *)image {
    self.image = image;
}

#pragma mark - callback   virus add 2018-03-03 14:40:34

- (CGRect)idcardRect {
    CGFloat height = coverImageView.width * 0.7;
    CGFloat width = height * 85.6 / 54;
    CGFloat left = (coverImageView.width - height) / 2;
    CGFloat top = (coverImageView.height) * 114 / 784;
    CGRect cardRect = CGRectMake(left, top, height, width);// 此处宽高调换一下
    return cardRect;
}

#pragma mark - private

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end
