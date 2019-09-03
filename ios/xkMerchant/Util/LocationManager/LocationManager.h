/*******************************************************************************
 # File        : LocationManager.h
 # Project     : xkMerchant
 # Author      : Jamesholy
 # Created     : 2018/9/4
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

@interface LocationManager : NSObject

+ (instancetype)shareInstance;

- (void)updateLoactionComplete:(void(^)(NSString *err,NSDictionary *loactionInfo))complete;

@end
