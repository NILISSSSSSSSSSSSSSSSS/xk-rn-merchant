/*******************************************************************************
 # File        : XKMediaPickHelper.m
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/10/8
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/


#import "XKMediaPickHelper.h"
#import "XKAlertView.h"
#import <TZImagePickerController.h>
#import "XKBottomAlertSheetView.h"
#import <AVFoundation/AVFoundation.h>
#import "HVideoViewController.h"
#import "XKAuthorityTool.h"
@interface XKMediaPickHelper () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong)NSMutableArray *imgArr;
@property (nonatomic, strong)XKBottomAlertSheetView *bottomView;
@end

@implementation XKMediaPickHelper

- (instancetype)init {
  self = [super init];
  if(self) {
    self.videoMaxSecond = 15;
    self.imgArr = [NSMutableArray array];
    self.bottomView = [[XKBottomAlertSheetView alloc] initWithBottomSheetViewWithDataSource:@[@"拍摄",@"从相册中选择",@"取消"] firstTitleColor:nil choseBlock:^(NSInteger index, NSString *choseTitle) {
      if([choseTitle containsString:@"拍摄"] || [choseTitle containsString:@"拍照"]) {
        [self takeFromCamera];
      }  else if([choseTitle isEqualToString:@"从相册中选择"]) {
        [self imageFromLibiary];
      }
    }];
  }
  return self;
}

- (void)showView {
  [self.imgArr removeAllObjects];
  if (self.canSelectVideo) {
    self.bottomView.dataSource = @[@"拍摄(照片or视频)",@"从相册中选择",@"取消"];
  } else {
    self.bottomView.dataSource = @[@"拍照",@"从相册中选择",@"取消"];
  }
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

#pragma mark - 拍摄
- (void)takeFromCamera {
  [XKAuthorityTool judegeCanRecord:^{
    [self takeFromCameraAction];
  }];
}

- (void)takeFromCameraAction {
  HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
  ctrl.HSeconds = self.videoMaxSecond;//设置可录制最长时间
  ctrl.onlyTakePhoto = self.canSelectVideo ? NO : YES;
  ctrl.takeBlock = ^(id item, UIImage *firstImg) {
    if ([item isKindOfClass:[NSURL class]]) {
      NSURL *videoURL = item;
      float time = [XKGlobleCommonTool calculateVideoTime:videoURL];
      if (time > self.videoMaxSecond) {
        [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"视频时长过长,请限制%lds之内",self.videoMaxSecond]];
      } else {
        //视频url
        EXECUTE_BLOCK(self.choseVideoPathBlcok,videoURL,firstImg);
      }
    } else {
      //图片
      
      if (item) {
        if (self.choseImageBlcok) {
          self.choseImageBlcok(@[item]);
        }
      } else {
#if DEBUG
        [XKHudView showErrorMessage:@"图片处理失败，请重新拍摄"];
#else
        [XKHudView showErrorMessage:@"图片处理失败，请重新拍摄"];
#endif
        
      }
    }
  };
  [self.getCurrentUIVC presentViewController:ctrl animated:YES completion:nil];
}

#pragma mark ---相册选择
- (void)imageFromLibiary
{
  TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxCount delegate:self];
  imagePicker.allowPickingVideo = self.canSelectVideo;
  imagePicker.isSelectOriginalPhoto = YES;
  imagePicker.autoDismiss = NO;
  WEAK_TYPES(imagePicker)
  XKWeakSelf(ws);
  [imagePicker setImagePickerControllerDidCancelHandle:^{
    [weakimagePicker dismissViewControllerAnimated:YES completion:nil];
  }];
  [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
   {
     //         [SVProgressHUD showWithStatus:@"正在导出图片..."];
     [ws.imgArr addObjectsFromArray:photos];
     //         [SVProgressHUD dismiss];
     if(self.choseImageBlcok) {
       self.choseImageBlcok(self.imgArr);
     }
     [weakimagePicker dismissViewControllerAnimated:YES completion:nil];
   }];
  [imagePicker setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.duration > self.videoMaxSecond) {
      [XKAlertView showCommonAlertViewWithTitle:[NSString stringWithFormat:@"视频时长过长,请限制%lds之内",self.videoMaxSecond]];
      return ;
    }
    [weakimagePicker dismissViewControllerAnimated:YES completion:nil];
    [self getVideoFromPHAsset:asset complete:^(NSString *error, NSURL *url) {
      if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [XKHudView showErrorMessage:error];
        });
      } else {
        EXECUTE_BLOCK(self.choseVideoPathBlcok,url,coverImage);
      }
    }];
  }];
  [[self getCurrentUIVC] presentViewController:imagePicker animated:YES completion:nil];
}

// 获取视频资源
- (void)getVideoFromPHAsset:(PHAsset *)phAsset complete:(void(^)(NSString *error, NSURL *url))result {
  
  if (phAsset.mediaType == PHAssetMediaTypeVideo || phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
      AVURLAsset *urlAsset = (AVURLAsset *)asset;
      NSData *data = [NSData dataWithContentsOfURL:urlAsset.URL];
      if (data.length == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [XKHudView showTipMessage:@"iCloud同步中..."];
        });
        return ;
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        [XKHudView showLoadingTo:nil animated:YES];
      });
      [self compressVideo:asset complete:^(NSString *error, NSURL *url) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [XKHudView hideHUDForView:nil];
        });
        if (error) {
          result(error, nil);
        } else {
          result(nil,url);
        }
      }];
    }];
  } else {
    result(@"未知错误", nil);
  }
}

// 压缩视频并转成MP4
- (void)compressVideo:(AVAsset *)asset complete:(void(^)(NSString *error, NSURL *url))result {
  
  //保存至沙盒路径
  NSString *videoPath = [[XKMediaPickHelper getRandomPath] stringByAppendingString:@".mp4"];
  //转码配置
  AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
  NSURL *fileUrl = [NSURL fileURLWithPath:videoPath];
  exportSession.shouldOptimizeForNetworkUse = YES;
  exportSession.outputURL = fileUrl;
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
        if (self.videoMaxSize > 0) {
          float videoSize = [self fileSizeAtPath:videoPath]/1024.0/1024;
          if (videoSize > self.videoMaxSize) {
            result([NSString stringWithFormat:@"视频大小超过%@M限制",[NSString stringWithFormat:@"%@",@(self.videoMaxSize)]],nil);
          } else {
            result(nil,fileUrl);
          }
        } else {
          result(nil,fileUrl);
        }
        break;
      }
      default:{
        result(@"未知错误，请重试",nil);
      }
    }
  }];
}

- (long long) fileSizeAtPath:(NSString*) filePath{
  NSFileManager* manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:filePath]){
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
  }
  return 0;
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

+ (NSString *)getTmpCachePath {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"xkMediaPickerCache"]; // 路径
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
  return [[XKMediaPickHelper getTmpCachePath] stringByAppendingPathComponent:[XKMediaPickHelper getRandomAfter]];
}

@end

