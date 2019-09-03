/*******************************************************************************
 # File        : XKMerchantModuleHelper.h
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2019/6/3
 # Corporation : 水木科技
 # Description :
 <#Description Logs#>
 -------------------------------------------------------------------------------
 # Date        : <#Change Date#>
 # Author      : <#Change Author#>
 # Notes       :
 <#Change Logs#>
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>

@interface XKMerchantModuleHelper : NSObject

+ (instancetype)shareHelper;

/**相册图片*/
- (void)uploadPictureWithMaxNum:(NSInteger)maxNum crop:(BOOL)crop resolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject;
/**相册视频*/
- (void)uploadVideoWithLimit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                      rejecter:(RCTPromiseRejectBlock)reject;
/**相册混合*/
- (void)uploadPickImageAndVideoWithCrop:(NSInteger)crop totalNum:(NSInteger)totalNum limit:(float)limit duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve
                               rejecter:(RCTPromiseRejectBlock)reject;
/**拍摄 视频或者图片 mode 0图 1视 2图视混合*/
- (void)captureWithMode:(NSInteger)mode duration:(float)duration resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

/**拍摄 照片 带裁剪*/
- (void)captureWithCropWithResolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;
@end
