//
//  Capture.m
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import "Capture.h"
@interface Capture ()
@property (nonatomic, assign) BOOL  isCapture;
@end
@implementation Capture
{
    unsigned char * _buffer;
    BOOL isRecognit;// 是否识别成功
}

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;
@synthesize outPutSetting;
@synthesize delegate;
@synthesize verify;
@synthesize isParsing;

#pragma mark - Init

- (id)init
{
    if ((self = [super init]))
    {
        [self setCaptureSession:[[AVCaptureSession alloc] init]];
        // Init default values
        //self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        //AVCaptureSessionPresetHigh
        //AVCaptureSessionPresetPhoto
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
        //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        //kCVPixelFormatType_32BGRA
        self.outPutSetting = [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
        self.verify = true;
        _isCapture = NO;
        isRecognit = NO;
        isParsing = NO;
    }
    
    return self;
}

#pragma mark - Public Functions

- (void)addVideoPreviewLayer
{
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

- (void)addVideoInput:(AVCaptureDevicePosition)_campos
{
    AVCaptureDevice *videoDevice=nil;
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if (_campos == AVCaptureDevicePositionBack)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
                {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error])
                    {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    else if (_campos == AVCaptureDevicePositionFront)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionFront)
            {
                if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
                {
                    NSError *error = nil;
                    if ([device lockForConfiguration:&error])
                    {
                        device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                        [device unlockForConfiguration];
                    }
                }
                videoDevice = device;
            }
        }
    }
    else
    {
        NSLog(@"Error setting camera device position.");
    }
    
    if (videoDevice)
    {
        NSError *error;
        
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (!error)
        {
            if ([[self captureSession] canAddInput:videoIn])
            {
                [[self captureSession] addInput:videoIn];
                _videoInput = videoIn;
            }
            else
                NSLog(@"Couldn't add video input");
        }
        else
            NSLog(@"Couldn't create video input");
    }
    else
        NSLog(@"Couldn't create video capture device");
}


- (void)addVideoOutput
{
    // Create a VideoDataOutput and add it to the session
    self.videooutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [[self captureSession] addOutput:self.videooutput];
    
    // Specify the pixel format
    self.videooutput.videoSettings = [NSDictionary dictionaryWithObject:outPutSetting forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    //[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]
    self.videooutput.alwaysDiscardsLateVideoFrames = YES;
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    
    [self.videooutput setSampleBufferDelegate:self queue:queue];
    
}

-(void)setvideoScale
{
    _focusConnection = [self.videooutput connectionWithMediaType:AVMediaTypeVideo];
    _focusConnection.videoScaleAndCropFactor = 1;
    [[self previewLayer] setAffineTransform:CGAffineTransformMakeScale(1, 1)];
}

#pragma mark - 添加截图输出
- (void)addStillImageOutput {
    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
    
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,nil];
    
    [[self stillImageOutput] setOutputSettings:outputSettings];
    
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            
            [videoConnection setVideoMinFrameDuration:CMTimeMake(1, 15)];
            break;
        }
    }
    
    [[self captureSession] addOutput:[self stillImageOutput]];
}

#pragma mark - 获取截图输出连接
- (AVCaptureConnection *)captureStillImage
{
    AVCaptureConnection *videoConnection = nil;
    
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    return videoConnection;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    XKWeakSelf(ws);
    // isCapture（是否捕捉）和 isRecognit（是否分析信息成功） 的逻辑：默认都为NO，首先满足彩图获取成功；点击拍摄，isCapture=YES
    if (_isCapture) {
        if([delegate respondsToSelector:@selector(captureImage:)]) {
            //截取彩图
            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self captureStillImage] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if (error == nil && ws.isCapture) {
                    ws.isCapture = NO;
                    //停止运行相机
                    [[self captureSession] stopRunning];
                    //截取彩图成功
                    NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                    UIImage *image = [UIImage imageWithData:data];
                    [self.delegate captureImage:image];
                    NSLog(@"截取彩图成功代理回调");
                }
            }];
        }
    }
//    if (isParsing && !isRecognit && [delegate respondsToSelector:@selector(idCardRecognited:)]) {
//        if ([outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] ||
//            [outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]  ) {
//            //解析信息
//            IdInfo *idInfo = [self idCardRecognit:sampleBuffer];
//            if (idInfo && [idInfo isOK]) {
//                isRecognit = YES;
//                [self.delegate idCardRecognited:idInfo];
//                NSLog(@"解析成功代理回调：\n%@\n%@",idInfo.name,idInfo.code);
//            } else {
//                NSLog(@"解析失败代理回调");
//            }
//        }
//    }
}

#pragma mark - 重新开始
- (void)reStartRunning {
    _isCapture = NO;
    isRecognit = NO;
    [[self captureSession] startRunning];
}

#pragma mark - 捕捉图片
- (void)captureImage {
    _isCapture = YES;
}

#pragma mark - 根据帧动画获取信息
//- (IdInfo *)idCardRecognit:(CMSampleBufferRef)sampleBuffer
//{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    IdInfo *idInfo = nil;
//    // Lock the image buffer
//    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
//    {
//        size_t width= CVPixelBufferGetWidth(imageBuffer);
//        size_t height = CVPixelBufferGetHeight(imageBuffer);
//
//        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
//        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
//        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
//        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
//        unsigned char* pixelAddress = baseAddress + offset;
//
//        /*
//         size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//         size_t buffeSize = CVPixelBufferGetDataSize(imageBuffer);
//         NSLog(@"bytesPerRow[%zu] width[%zu] height[%zu] buffeSize[%zu] offset[%zu]",
//         bytesPerRow, width, height, buffeSize, offset);
//         NSLog(@"componentInfoY.rowBytes[%zu]", rowBytes);
//         NSLog(@"componentInfoCbCr.rowBytes[%zu]", uvrowBytes);
//         */
//        if (_buffer == NULL)
//            _buffer = (unsigned char*)malloc(sizeof(unsigned char) * width * height);
//
//        memcpy(_buffer, pixelAddress, sizeof(unsigned char) * width * height);
//
//        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//
//        unsigned char pResult[1024];
//
//        int ret = 0;
//
//#if TARGET_IPHONE_SIMULATOR
//
//#elif TARGET_OS_IPHONE
//        ret = EXCARDS_RecoIDCardData(_buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
//#endif
//
//        NSLog(@"\nocr识别错误码：%d\n",ret);
//
//        if (ret <= 0)
//        {
//            // NSLog(@"IDCardRecApi，ret[%d]", ret);
//        }
//        else
//        {
//            // NSLog(@"ret=[%d]", ret);
//            char ctype;
//            char content[256];
//            int xlen;
//            int i = 0;
//
//            idInfo = [[IdInfo alloc] init];
//            ctype = pResult[i++];
//            idInfo.type = ctype;
//            while(i < ret){
//                ctype = pResult[i++];
//                for(xlen = 0; i < ret; ++i){
//                    if(pResult[i] == ' ') { ++i; break; }
//                    content[xlen++] = pResult[i];
//                }
//                content[xlen] = 0;
//                if(xlen){
//                    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                    if(ctype == 0x21)
//                        idInfo.code = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x22)
//                        idInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x23)
//                        idInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x24)
//                        idInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x25)
//                        idInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x26)
//                        idInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    else if(ctype == 0x27)
//                        idInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                }
//            }
//            if (self.verify)
//            {
//                if (_lastIdInfo == nil)
//                {
//                    _lastIdInfo = idInfo;
//                    idInfo = nil;
//                }
//                else
//                {
//                    if (![_lastIdInfo isEqual:idInfo])
//                    {
//                        _lastIdInfo = idInfo;
//                        idInfo = nil;
//                    }
//                }
//            }
//            if ([idInfo isOK])
//            {
//                //NSLog(@"[%@]", [idInfo toString]);
//            }
//        }
//    }
//
//    return idInfo;
//    //NSLog(@"end of idCardRecognit");
//}

#pragma mark - 根据帧动画生成图片
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the plane pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
    
    // Get the number of bytes per row for the plane pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent gray color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGImageAlphaNone);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

/**
 *  点击后对焦
 *
 *  @param devicePoint 点击的point
 */
- (void)focusInPoint:(CGPoint)devicePoint
{
    NSLog(@"%f,%f",devicePoint.x,devicePoint.y);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    XKWeakSelf(ws);
    dispatch_queue_t queue = dispatch_queue_create("myQueue11", NULL);
    
    dispatch_async(queue, ^{
        AVCaptureDevice *device = [ws.videoInput device];
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode])
            {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode])
            {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    });
}

- (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - Dealloc

- (void)dealloc
{
    [[self captureSession] stopRunning];
    
    previewLayer        = nil;
    captureSession      = nil;
    stillImageOutput    = nil;
    stillImage          = nil;
    outPutSetting       = nil;
    delegate            = nil;
}

@end

