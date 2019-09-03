//
//  Capture.h
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CaptureDelegate<NSObject>

@optional

- (void)captureImage:(UIImage *)image;

@end


@interface Capture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureConnection *_focusConnection;
}
@property (nonatomic, strong) AVCaptureDeviceInput  *videoInput;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer     *previewLayer;
@property (strong,nonatomic) AVCaptureSession               *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput      *stillImageOutput;
@property (strong,nonatomic) AVCaptureVideoDataOutput       *videooutput;
@property (strong,nonatomic) UIImage                        *stillImage;
@property (strong,nonatomic) NSNumber                       *outPutSetting;
@property (weak, nonatomic) id<CaptureDelegate>             delegate;
@property (nonatomic) BOOL verify;
@property (nonatomic) BOOL isParsing;

/**
 *  @brief Add video input: front or back camera:
 *  AVCaptureDevicePositionBack
 *  AVCaptureDevicePositionFront
 */
- (void)addVideoInput:(AVCaptureDevicePosition)_campos;

/**
 *  @brief Add video output
 */
- (void)addVideoOutput;

/**
 *  @brief Add image output
 */
- (void)addStillImageOutput;

/**
 *  @brief Add preview layer
 */
- (void)addVideoPreviewLayer;

//聚焦
- (void)focusInPoint:(CGPoint)devicePoint;
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange;

- (void)setvideoScale;

//开始
- (void)reStartRunning;

//捕捉
- (void)captureImage;

@end
