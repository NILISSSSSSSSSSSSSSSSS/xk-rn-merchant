/*******************************************************************************
 # File        : XKMerchantModuleHelper.m
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/6/3
 # Corporation :  水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import "XKMerchantModuleHelper.h"

#import "XKAuthorityTool.h"
#import "TZImagePickerController.h"
#import "MBProgressHUD.h"
#import "HVideoViewController.h"
#import "QNFileUploader.h"

typedef NS_ENUM(NSInteger,XKMerchantModulePickAbulmType) {
  XKMerchantModulePickAbulmPicType,
  XKMerchantModulePickAbulmVideoType,
  XKMerchantModulePickAbulmMixType
};

@interface XKMerchantModuleHelper ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
  
}

/***/
@property(nonatomic, copy) RCTPromiseResolveBlock resolve;
@property(nonatomic, copy) RCTPromiseRejectBlock reject;

@end

@implementation XKMerchantModuleHelper

+ (instancetype)shareHelper {
  static dispatch_once_t onceToken;
  static XKMerchantModuleHelper *_instance;
  dispatch_once(&onceToken, ^{
    _instance = [XKMerchantModuleHelper new];
  });
  return _instance;
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 相册选图片 带裁剪
- (void)uploadPictureWithMaxNum:(NSInteger)maxNum crop:(BOOL)crop resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject {
  
  [self uploadPickImageAndVideo:XKMerchantModulePickAbulmPicType crop:crop totalNum:maxNum limit:0 duration:0 resolver:resolve rejecter:reject];
}

#pragma mark - 相册传视频
- (void)uploadVideoWithLimit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  [self uploadPickImageAndVideo:XKMerchantModulePickAbulmVideoType crop:NO totalNum:1 limit:limit duration:duration resolver:resolve rejecter:reject];
}

#pragma mark - 相册传视频or图片
- (void)uploadPickImageAndVideoWithCrop:(NSInteger)crop totalNum:(NSInteger)totalNum limit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                               rejecter:(RCTPromiseRejectBlock)reject {
  [self uploadPickImageAndVideo:XKMerchantModulePickAbulmMixType crop:crop totalNum:totalNum limit:limit duration:duration resolver:resolve rejecter:reject];
}


- (void)uploadPickImageAndVideo:(XKMerchantModulePickAbulmType)type crop:(NSInteger)crop totalNum:(NSInteger)totalNum limit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.resolve = resolve;
    self.reject = reject;
    [KEY_WINDOW endEditing:YES];
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAlbum needGuide:YES has:^{
      TZImagePickerController *imagePickerVc;
      if (totalNum != 0) {
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:totalNum delegate:self];
      } else {
        imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:50 delegate:self];
      }
      if (type == XKMerchantModulePickAbulmPicType) {
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = NO;
      } else if (type == XKMerchantModulePickAbulmVideoType) {
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowPickingVideo = YES;
      } else if (type == XKMerchantModulePickAbulmMixType) {
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingVideo = YES;
      }
      imagePickerVc.autoDismiss = NO;
      imagePickerVc.allowPickingOriginalPhoto = NO;
      imagePickerVc.allowPickingGif = NO;
      if (crop == YES && totalNum == 1) {
        imagePickerVc.allowCrop = YES;
        imagePickerVc.cropRect = CGRectMake(10, (SCREEN_HEIGHT/2 - SCREEN_WIDTH/2) + 10, SCREEN_WIDTH - 20, SCREEN_WIDTH - 20);
      } else {
        imagePickerVc.allowCrop = NO;
      }
      
      __weak typeof(TZImagePickerController *) weakPickerVc = imagePickerVc;
      [imagePickerVc setImagePickerControllerDidCancelHandle:^{
        reject(@"fail",@"取消",nil);
      }];
      [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos.count > 0) {
          if (self.resolve == nil) { return; }
          self.resolve = nil;
          [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
          [[QNFileUploader sharedInstance] saveImageToTmp:photos complete:^(NSString *error, NSArray<NSDictionary *> *paths) {
            [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
            if (error) {
              reject(@"fail",error,nil);
              [weakPickerVc dismissViewControllerAnimated:YES completion:nil];
              return;
            }
            resolve(paths);
            [weakPickerVc dismissViewControllerAnimated:YES completion:nil];
          }];
        } else {
          reject(@"fail",@"失败",nil);
          [weakPickerVc dismissViewControllerAnimated:YES completion:nil];
        }
      }];
      [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        if (duration != 0 && asset.duration > duration) { // 传入duration不为0 ，限制视频长度
          [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
          reject(@"fail",[NSString stringWithFormat:@"视频长度超过%f秒",duration],nil);
          [weakPickerVc dismissViewControllerAnimated:YES completion:nil];
          return;
        }
        [[QNFileUploader sharedInstance] getVideoFromPHAsset:asset complete:^(NSString *error, id data, NSString *videoPath, UIImage *firstImg, NSString *firstImgPath, long long videoSize) {
          [MBProgressHUD hideHUDForView:KEY_WINDOW animated:NO];
          if (error) {
            reject(@"fail",error,nil);
          } else {
            if (limit != 0 && videoSize > limit) { // 视频过大
              reject(@"fail",[NSString stringWithFormat:@"视频大小超过%lldkb",videoSize],nil);
            } else {
              resolve(@[@{@"videoPath":videoPath,@"imagePath":firstImgPath}]);
            }
          }
          [weakPickerVc dismissViewControllerAnimated:YES completion:nil];
        }];
      }];
      [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:imagePickerVc animated:YES completion:nil];
    } hasnt:^{
      reject(@"fail",@"无权限",nil);
    }];
  });
}


- (void)captureWithMode:(NSInteger)mode duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  dispatch_async(dispatch_get_main_queue(), ^{
    [KEY_WINDOW endEditing:YES];
    self.resolve = nil;
    self.reject = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
      [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"相机不可用", @"")];
      reject(@"fail",@"无权限",nil);
      return;
    }
    
    [XKAuthorityTool judegeCanRecord:^{
      [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeAlbum needGuide:YES has:^{
        self.resolve = resolve;
        self.reject = reject;
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.HSeconds = duration;
        if (mode == 0) {
          ctrl.onlyTakePhoto = YES;
        } else if (mode == 1) {
          ctrl.onlyTakeVideo = YES;
        } else  {
        }
        ctrl.takeBlock = ^(id item, UIImage *firstImg) {
          if (self.resolve == nil) { return; }
          self.resolve = nil;
          if ([item isKindOfClass:[NSURL class]]) {
            [[QNFileUploader sharedInstance] compressVideo:[AVURLAsset assetWithURL:item] complete:^(NSString *error, NSString *path, id data, long long videoSize) {
              if (error) {
                reject(@"fail",error,nil);
              } else {
                [[QNFileUploader sharedInstance] saveImageToTmp:@[firstImg] complete:^(NSString *error, NSArray<NSDictionary *> *paths) {
                  if (error) {
                    reject(@"fail",error,nil);
                  } else {
                    resolve(@[@{@"videoPath":path,@"imagePath":paths.firstObject[@"imagePath"]}]);
                  }
                }];
              }
            }];
          } else {
            [[QNFileUploader sharedInstance] saveImageToTmp:@[item] complete:^(NSString *error, NSArray<NSDictionary *> *paths) {
              if (error) {
                reject(@"fail",error,nil);
              } else {
                resolve(paths);
              }
            }];
          }
        };
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:ctrl animated:YES completion:nil];
      } hasnt:^{
        reject(@"fail",@"无权限",nil);
      }];
    }];
  });
}

- (void)captureWithCropWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
  dispatch_async(dispatch_get_main_queue(), ^{
    [KEY_WINDOW endEditing:YES];
    self.resolve = nil;
    self.reject = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
      [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"相机不可用", @"")];
      reject(@"fail",@"无权限",nil);
      return;
    }
    [XKAuthorityTool judgeAuthorityType:PrivacyAuthorityTypeCamera needGuide:YES has:^{
      self.resolve = resolve;
      self.reject = reject;
      UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
      imagePicker.delegate = self;
      imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
      imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
      imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      imagePicker.allowsEditing = YES;
      
      [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePicker animated:YES completion:nil];
    } hasnt:^{
      reject(@"fail",@"无权限",nil);
    }];
  });
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (image == nil) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  if (image==nil) {
    self.reject(@"fail",@"失败",nil);
    return;
  }
  //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
  
  [[QNFileUploader sharedInstance] saveImageToTmp:@[image] complete:^(NSString *error, NSArray<NSDictionary *> *paths) {
    [MBProgressHUD hideHUDForView:KEY_WINDOW animated:YES];
    if (self.resolve == nil) { return; }
    if (error) {
      self.reject(@"fail",error,nil);
    } else {
       self.resolve(paths);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.resolve = nil;
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
  if (self.reject) {
    self.reject(@"fail",@"取消",nil);
  }
}
#pragma mark -- <保存到相册>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
  
}


@end
