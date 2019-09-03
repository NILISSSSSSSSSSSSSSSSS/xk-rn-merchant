//
//  XKPhotoPickHelperView.m
//  XKSquare
//
//  Created by 刘晓霖 on 2018/9/3.
//  Copyright © 2018年 xk. All rights reserved.
//

#import "XKPhotoPickHelper.h"
#import "XKAlertView.h"
#import <TZImagePickerController.h>
#import "XKBottomAlertSheetView.h"
#import <AVFoundation/AVFoundation.h>
@interface XKPhotoPickHelper () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong)NSMutableArray *imgArr;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;
@property (nonatomic, strong)XKBottomAlertSheetView *bottomView;
@property (nonatomic, assign)BOOL allowVideo;
@end

@implementation XKPhotoPickHelper

- (instancetype)init {
    self = [super init];
    if(self) {
        self.imgArr = [NSMutableArray array];
        self.allowVideo = YES;
        self.dataSourceArr = [NSMutableArray arrayWithArray:@[@"拍视频",@"拍照片",@"从相册中选择",@"取消"]];
        self.bottomView = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:self.dataSourceArr firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
            if([choseTitle isEqualToString:@"拍视频"]) {
                [self videoFromCamera];
            } else if([choseTitle isEqualToString:@"拍照片"]) {
                [self imageFromCamera];
            } else if([choseTitle isEqualToString:@"从相册中选择"]) {
                [self imageFromLibiary];
            }
        }];

    }
    return self;
}

- (void)handleVideoChoseWithNeeded:(BOOL)need {
    if(need) {
        self.allowVideo = YES;
        if([self.dataSourceArr containsObject:@"拍视频"])
            return;
        [self.dataSourceArr addObject:@"拍视频"];
    } else {
        self.allowVideo = NO;
        [self.dataSourceArr removeObject:@"拍视频"];
    }
    self.bottomView.dataSource = self.dataSourceArr;
    [self.bottomView updataData];
}

- (void)showView {
    [self.imgArr removeAllObjects];
    [self.bottomView show];
}

#pragma mark - 判断是否有相机功能
+ (BOOL)isCameraAvailable {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [XKAlertView showCommonAlertViewWithTitle:@"您当前的设备没有摄像头，不能使用相机拍摄。"];
        return NO;
    }
    return YES;
}

#pragma mark 取消拍摄
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.bottomView dismissSelf];
}

#pragma mark 拍照上传
- (void)imageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"相机不可用", @"")];
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
    [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 录制上传
- (void)videoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"相机不可用", @"")];
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.navigationBarHidden = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.allowsEditing = YES;
    imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
    
    [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark ---上传照片
- (void)imageFromLibiary
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount delegate:self];
    imagePicker.allowPickingVideo = self.allowVideo;
    imagePicker.allowCrop = self.allowCrop;
    imagePicker.cropRect = CGRectMake(40, (SCREEN_HEIGHT/2 - SCREEN_WIDTH/2) + 40, SCREEN_WIDTH - 80, SCREEN_WIDTH - 80);
    imagePicker.isSelectOriginalPhoto = YES;
    XKWeakSelf(ws);
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
//         [SVProgressHUD showWithStatus:@"正在导出图片..."];
         [ws.imgArr addObjectsFromArray:photos];
         [SVProgressHUD dismiss];
         if(self.choseImageBlcok) {
             self.choseImageBlcok(self.imgArr);
         }
     }];
    [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}

/**
 只含有视频的相册
 */
- (void)videoFromLibiary
{
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount delegate:self];
    imagePicker.allowPickingImage = NO;
    [imagePicker setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        if(self.choseVideoBlcok) {
            self.choseVideoBlcok(coverImage,asset);
        }
    }];
    [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    XKWeakSelf(ws);
    [SVProgressHUD show];
    NSString *strType = [info valueForKey:UIImagePickerControllerMediaType];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        if ([strType hasSuffix:@"image"]) {
            UIImageWriteToSavedPhotosAlbum([info objectForKey:UIImagePickerControllerOriginalImage], nil, nil, nil);
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([strType hasSuffix:@"image"]){
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImage *newImage = [ws fixOrientation:image];
            [ws.imgArr addObject:newImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                [picker dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD dismiss];
                if(ws.choseImageBlcok) {
                    ws.choseImageBlcok(self.imgArr);
                }
            });

        } else {
            NSURL *mediaUrl = [info valueForKey:UIImagePickerControllerMediaURL];
            UISaveVideoAtPathToSavedPhotosAlbum([mediaUrl path], self, nil, NULL);//这个是保存到手机相册
            dispatch_async(dispatch_get_main_queue(), ^{
                [picker dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD dismiss];
                if(ws.choseVideoPathBlcok) {
                    ws.choseVideoPathBlcok(mediaUrl.absoluteString,[ws getThumbnailImage:mediaUrl]);
                };
                
            });
        }
    });
    
}

#pragma mark - ------拿到视频首诊图---
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
#pragma mark - ------修复图片方向---
- (UIImage *)fixOrientation:(UIImage *)Img{
    
    // No-op if the orientation is already correct
    if (Img.imageOrientation == UIImageOrientationUp) return Img;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (Img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, Img.size.width, Img.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, Img.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, Img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (Img.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, Img.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, Img.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, Img.size.width, Img.size.height,
                                             CGImageGetBitsPerComponent(Img.CGImage), 0,
                                             CGImageGetColorSpace(Img.CGImage),
                                             CGImageGetBitmapInfo(Img.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (Img.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,Img.size.height,Img.size.width), Img.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,Img.size.width,Img.size.height), Img.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *newimg = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return newimg;
}
- (void)imageFromCameraWithBlock:(void (^)(NSArray<UIImage *> * _Nullable))choseImageBlcok {
    [self imageFromCamera];
    self.choseImageBlcok = choseImageBlcok;
}

- (void)imageFromLibiaryWithBlock:(void (^)(NSArray<UIImage *> * _Nullable))choseImageBlcok {
    [self imageFromLibiary];
    self.choseImageBlcok = choseImageBlcok;
}

- (void)videoFromCameraWithBlock:(void (^)(NSString *, UIImage *))choseVideoPathBlcok {
    [self videoFromCamera];
    self.choseVideoPathBlcok = choseVideoPathBlcok;
}

- (void)videoFromLibiaryWithBlock:(void (^)(UIImage *, id))choseVideoBlcok {
    [self videoFromLibiary];
    self.choseVideoBlcok = choseVideoBlcok;
}
@end
