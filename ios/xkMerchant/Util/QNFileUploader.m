/*******************************************************************************
 # File        : QNFileUploader.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/8/21
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "QNFileUploader.h"
#import <QiniuSDK.h>
#import "UIImage+Reduce.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "XKMerchantModuleHelper.h"

@interface QNFileUploader()
@property(nonatomic, strong) QNUploadManager *qnUploader;
@end

@implementation QNFileUploader

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static QNFileUploader *instance;
  dispatch_once(&onceToken, ^{
    instance = [[QNFileUploader alloc] init];
  });
  return instance;
}

- (void)qiniuUpload:(NSString *)token data:(NSData *)data complete:(void(^)(NSString *error, NSString * path))result  {
  [self.qnUploader putData:data key:nil token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    NSLog(@"%@", info);
                    NSLog(@"%@", resp);
                    if (info.error) {
                      result(info.error.localizedDescription?:@"图片上传失败",nil);
                    } else {
                      result(nil,resp[@"key"]);
                    }
                  } option:nil];
}

#pragma mark - 上传图片
- (void)uploadPicture:(NSArray<UIImage *> *)images token:(NSString *)token complete:(void(^)(NSString *error, NSArray <NSDictionary *> *paths))complete {
  dispatch_group_t group = dispatch_group_create();
  static NSMutableArray *pathArray;
  pathArray = [NSMutableArray array];
  for (UIImage *image in images) {
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      dispatch_semaphore_t sema = dispatch_semaphore_create(0);
      NSData *data = [image imageCompressForSpecifyKB:300];
      [self qiniuUpload:token data:data complete:^(NSString *error, NSString *path) {
        if (error) {
          [pathArray addObject:@{@"url":@""}];
        } else {
          [pathArray addObject:@{@"url":path ? : @""}];
        }
        dispatch_semaphore_signal(sema);
      }];
      dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
  }
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // 界面刷新
    complete(nil,pathArray);
  });
}

#pragma mark - 上传视频
- (void)uploadVideo:(PHAsset *)asset token:(NSString *)token complete:(void(^)(NSString *error, NSString *path))complete {
  [self getVideoFromPHAsset:asset complete:^(NSString *error, id data,NSString *videoPath,UIImage *firstImg,NSString *imagePath,long long size) {
    if (error) {
      complete(error,nil);
    } else {
      [self qiniuUpload:token data:data complete:^(NSString *error, NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
          if (error) {
            complete(error,nil);
          } else {
            complete(nil,path);
          }
        });
      }];
    }
  }];
}

- (void)uploadVideoWithFirstImage:(PHAsset *)asset token:(NSString *)token complete:(void(^)(NSString *error, NSDictionary *path))complete  {
  [self getVideoFromPHAsset:asset complete:^(NSString *error, id data,NSString *videoPath, UIImage *firstImg,NSString *imagePath,long long size) {
    if (error) {
      complete(error,nil);
    } else {
      [self qiniuUpload:token data:data complete:^(NSString *error, NSString *videoPath) {
        if (error) {
          dispatch_async(dispatch_get_main_queue(), ^{
            complete(error,nil);
          });
        } else {
          NSData *data = [firstImg imageCompressForSpecifyKB:300];
          [self qiniuUpload:token data:data complete:^(NSString *error, NSString *imgPath) {
            if (error) {
              complete(error,nil);
            } else {
              NSMutableDictionary *dic = @{}.mutableCopy;
              dic[@"videoUrl"] = videoPath;
              dic[@"imgUrl"] = imgPath;
              dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil,dic);
              });
            }
          }];
        }
      }];
    }
  }];
}

- (void)uploadVideoWithFirstImage:(PHAsset *)asset limitSize:(long long)limitSize token:(NSString *)token complete:(void(^)(NSString *error, NSDictionary *path,long long videoSize))complete {
  [self getVideoFromPHAsset:asset complete:^(NSString *error, id data,NSString *videoPath, UIImage *firstImg,NSString *imagePath, long long videoTotalSize) {
    if (error) {
      complete(error,nil,0);
    } else {
      // 判断视频大小
      if (limitSize < videoTotalSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(@"limit",nil,videoTotalSize);
        });
        return;
      }
      
      [self qiniuUpload:token data:data complete:^(NSString *error, NSString *videoPath) {
        if (error) {
          dispatch_async(dispatch_get_main_queue(), ^{
            complete(error,nil,0);
          });
        } else {
          NSData *data = [firstImg imageCompressForSpecifyKB:300];
          [self qiniuUpload:token data:data complete:^(NSString *error, NSString *imgPath) {
            if (error) {
              complete(error,nil,0);
            } else {
              NSMutableDictionary *dic = @{}.mutableCopy;
              dic[@"videoUrl"] = videoPath;
              dic[@"imgUrl"] = imgPath;
              dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil,dic,videoTotalSize);
              });
            }
          }];
        }
      }];
    }
  }];
}

// 获取视频资源
- (void)getVideoFromPHAsset:(PHAsset *)phAsset complete:(void(^)(NSString *error, id data, NSString *videoPath,UIImage *firstImg,NSString *firstImgPath,long long videoSize))result {
  if (phAsset.mediaType == PHAssetMediaTypeVideo || phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
      AVURLAsset *urlAsset = (AVURLAsset *)asset;
      [self compressVideo:urlAsset complete:^(NSString *error,NSString *path, id data,long long videoSize) {
        if (data == nil) {
          result(error,nil,nil,nil,nil,0);
        } else {
          UIImage *image = [self getFirstImage:urlAsset];
          if (image) {
            [self saveImageToTmp:@[image] complete:^(NSString *error, NSArray<NSDictionary *> *paths) {
              if (error) {
                result(error,nil,nil,nil,nil,0);
              } else {
                result(nil,data,path,image,paths.firstObject[@"imagePath"], videoSize);
              }
            }];
          } else {
            result(@"处理视频出现异常",nil,nil,nil,nil,0);
          }
        }
      }];
    }];
  } else {
    result(@"未知错误", nil,nil,nil,nil,0);
  }
}

// 压缩视频
- (void)compressVideo:(AVURLAsset *)asset complete:(void(^)(NSString *error, NSString *path, id data, long long videoSize))result {
  
  //保存至沙盒路径
  NSString *videoPath = [[QNFileUploader getRandomPath] stringByAppendingString:@".mp4"];
  
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
        result(exportError.localizedDescription,nil,nil,0);
        break;
      }
      case AVAssetExportSessionStatusCompleted:
      {
        NSData *data = [NSData dataWithContentsOfFile:videoPath];
        long long videoSize = [self fileSizeAtPath:videoPath];
        result(nil,videoPath,data,videoSize/1024); // kb
        break;
      }
      default:{
        result(@"未知错误，请重试",nil,nil,0);
      }
    }
  }];
}

#pragma mark - 获取首帧图
- (UIImage *)getFirstImage:(AVURLAsset *)asset {
  AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
  assetImageGenerator.appliesPreferredTrackTransform = YES;
  assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
  CGImageRef thumbnailImageRef = NULL;
  CFTimeInterval thumbnailImageTime = 0;
  NSError *thumbnailImageGenerationError = nil;
  
  thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 15) actualTime:NULL error:&thumbnailImageGenerationError];
  
  UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
  
  //NSData *imageData = UIImagePNGRepresentation(thumbnailImage);
  
  CGImageRelease(thumbnailImageRef);
  
  return thumbnailImage;
}

- (long long) fileSizeAtPath:(NSString*) filePath{
  NSFileManager* manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:filePath]){
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
  }
  return 0;
}


#pragma mark - 懒加载
- (QNUploadManager *)qnUploader {
  if (!_qnUploader) {
    _qnUploader = [[QNUploadManager alloc] init];
  }
  return _qnUploader;
}


#pragma mark - 存图片到本地
- (void)saveImageToTmp:(NSArray <UIImage *>*)imgs complete:(void(^)(NSString *error, NSArray<NSDictionary *> *paths))complete {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    NSMutableArray *arr = @[].mutableCopy;
    for (UIImage *image in imgs) {
      NSString *path = [[QNFileUploader getRandomPath] stringByAppendingString:@".png"];
      NSError *err;
      [UIImagePNGRepresentation(image) writeToFile:path options:0 error:&err];
      if (err) {
        NSLog(@"保存失败");
        dispatch_sync(dispatch_get_main_queue(), ^{
          complete(err.localizedDescription?:@"内存不够",nil);});
        return;
      }
      [arr addObject:@{@"imagePath":path}];
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
    complete(nil,arr);
    });
  });
}

+ (NSString *)getTmpCachePath {
  NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"mediaCache"]; // 路径
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
  return [[QNFileUploader getTmpCachePath] stringByAppendingPathComponent:[QNFileUploader getRandomAfter]];
}

@end
