/*******************************************************************************
 # File        : APPNetworkConfig.h
 # Project     : XKSquare
 # Author      : Jamesholy
 # Created     : 2018/8/22
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

@interface XKAPPNetworkConfig : NSObject

+ (NSInteger)getDEBUG_MODE;

/**
 获取base域名
 
 @return base域名
 */
+ (NSString *)getDynamicMainBaseUrl;

/**
 WEB的域名
 
 @return web域名
 */
+ (NSString *)getDynamicWebBaseUrl;

/**
 直播的域名
 
 @return web域名
 */
+ (NSString *)getDynamicLiveBaseUrl;



@end



@interface APPDebug:NSObject

/**
 保存运行环境
 */
+ (void)saveDebugModeStatus:(NSInteger)status;

/**
 获取 运行模式
 */
+ (NSInteger)getDebugModeStatus;

/**保存HTTPs 或者http*/
+ (void)setNetHeader:(NSString *)header;
+ (NSString *)getNetHeader;

// 运行模式描述
+ (NSString *)getDebugDescription;
// 设备型号
+ (NSString *)currentModel;
//设备环境信息
+ (NSString *)envirDetailInfo;

/**使用动态地址*/
+ (void)addDynamicPath:(NSString *)path;
+ (void)remvoeDynamicPath;
/**得到动态地址*/
+ (NSString *)getDynamicPath;

@end

