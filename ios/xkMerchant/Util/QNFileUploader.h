/*******************************************************************************
 # File        : QNFileUploader.h
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

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@interface QNFileUploader : NSObject

+ (instancetype)sharedInstance;

- (void)uploadPicture:(NSArray<UIImage *> *)images token:(NSString *)token complete:(void(^)(NSString *error, NSArray <NSDictionary *> *path))complete;

- (void)uploadVideo:(PHAsset *)asset token:(NSString *)token complete:(void(^)(NSString *error, NSString *path))complete;

- (void)uploadVideoWithFirstImage:(PHAsset *)asset token:(NSString *)token complete:(void(^)(NSString *error, NSDictionary *path))complete;

- (void)uploadVideoWithFirstImage:(PHAsset *)asset limitSize:(long long)size token:(NSString *)token complete:(void(^)(NSString *error, NSDictionary *path,long long kbSize))complete;

// 获取视频资源
- (void)getVideoFromPHAsset:(PHAsset *)phAsset complete:(void(^)(NSString *error, id data, NSString *videoPath,UIImage *firstImg,NSString *firstImgPath,long long videoSize))result;

- (void)compressVideo:(AVURLAsset *)asset complete:(void(^)(NSString *error, NSString *path, id data, long long videoSize))result;

#pragma mark - 存图片到本地
- (void)saveImageToTmp:(NSArray <UIImage *>*)imgs complete:(void(^)(NSString *error, NSArray<NSDictionary *> *paths))complete;

@end
