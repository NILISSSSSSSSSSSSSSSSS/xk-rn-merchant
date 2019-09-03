/*******************************************************************************
 # File        : APPNetworkConfig.m
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

#import "XKAPPNetworkConfig.h"
#import "XKDeviceDataLibrery.h"

//#ifdef DEBUG
//#define TEST_ENV_QA          1
//#define TEST_ENV_PRODUCTION  0
//#else
//#define TEST_ENV_QA          0
//#define TEST_ENV_PRODUCTION  1
//#endif


/* ------------------------- NSUserDefaults的相关 ------------------------*/
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
// 获得存储的对象
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
// 取值
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]
// 删除对象
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}



/******************************* 美丽的分割线 *********************************/


/*===============================*/
/*        DEBUG(开发环境)         */
/*===============================*/
//1 本地开发环境
#define kMAIN_LOCAL_DEV_BASE_STR                @"://dev.api.xksquare.com/api/"
#define kWEB_LOCAL_TEST_STR                     @"://devw.xksquare.com/"//@"http://192.168.2.144:8081/#/"//
#define kLIVE_LOCAL_TEST_STR                    @"://zb.dev.xksquare.com/"

//2 公司测试服务器
#define kMAIN_COMPANY_TEST_BASE_STR             @"://testw.api.xksquare.com/api/"
#define kWEB_COMPANY_TEST_STR                   @"://testw.xksquare.com/"
#define kLIVE_COMPANY_TEST_STR                  @"://zb.test.xksquare.com/"

//3 灰度测试环境
#define kMAIN_GRAY_BASE_STR                     @"://final.api.xksquare.com/api/"
#define kWEB_GRAY_TEST_STR                      @"://final.xksquare.com/"
#define kLIVE_GRAY_TEST_STR                     @"://zb.final.xksquare.com/"



/*===============================*/
/*     RELEASE(生产环境 勿动)      */
/*===============================*/

#define kMAIN_RELEASE_BASE_STR                 @"://pe.api.xksquare.com/api/"
#define kWEB_RELEASE_STR                       @"://xkadmin.xksquare.com/"
#define kLIVE_RELESE_STR                       @"://zhibo.xksquare.com/"



#define kMAIN_BASE_STR               [XKAPPNetworkConfig getDebugBaseUrl]
#define kWEB_BASE_STR                [XKAPPNetworkConfig getDebugWebBaseUrl]
#define kLIVE_BASE_STR               [XKAPPNetworkConfig getDebugLiveBaseUrl]


NSInteger DEBUGMODE = 0;
static NSString *HTTP_NET_HEADER = nil;

@implementation XKAPPNetworkConfig

#pragma mark - 获取域名
+ (NSString *)getDynamicMainBaseUrl {
  return kMAIN_BASE_STR;
}

+ (NSString *)getDynamicWebBaseUrl {
  return kWEB_BASE_STR;
}

+ (NSString *)getDynamicLiveBaseUrl {
  return kLIVE_BASE_STR;
}

+ (NSInteger)getDEBUG_MODE {
  return DEBUGMODE;
}

+ (NSString *)getDebugWebBaseUrl {
//#if TEST_ENV_QA
  // 开发环境
  NSInteger status = [APPDebug getDebugModeStatus];
  NSString *url = nil;
  switch (status) {
    case 0:  // 生产环境
      url = kWEB_RELEASE_STR;
      break;
    case 1:   // 本地开发环境
      url = kWEB_LOCAL_TEST_STR;
      break;
    case 2:    // 公司测试服务器
      url = kWEB_COMPANY_TEST_STR;
      break;
    case 3:     // 灰度测试环境
      url = kWEB_GRAY_TEST_STR;
      break;
    default:
      url = kWEB_RELEASE_STR;
      break;
  }
  
  return [HTTP_NET_HEADER stringByAppendingString:url];

}

+ (NSString *)getDebugBaseUrl {
//#if TEST_ENV_QA
  // 开发环境
  NSInteger status = [APPDebug getDebugModeStatus];
  NSString *url = nil;
  switch (status) {
    case 0:  // 生产环境
      url = kMAIN_RELEASE_BASE_STR;
      break;
    case 1:   // 本地开发环境
      url = kMAIN_LOCAL_DEV_BASE_STR;
      break;
    case 2:    // 公司测试服务器
      url = kMAIN_COMPANY_TEST_BASE_STR;
      break;
    case 3:     // 灰度测试环境
      url = kMAIN_GRAY_BASE_STR;
      break;
    default:
      url = kMAIN_RELEASE_BASE_STR;
      break;
  }
  
  return [HTTP_NET_HEADER stringByAppendingString:url];

}

+ (NSString *)getDebugLiveBaseUrl {
//#if TEST_ENV_QA
  // 开发环境
  NSInteger status = [APPDebug getDebugModeStatus];
  NSString *url = nil;
  switch (status) {
    case 0:  // 生产环境
      url = kLIVE_RELESE_STR;
      break;
    case 1:   // 本地开发环境
      url = kLIVE_LOCAL_TEST_STR;
      break;
    case 2:    // 公司测试服务器
      url = kLIVE_COMPANY_TEST_STR;
      break;
    case 3:     // 灰度测试环境
      url = kLIVE_GRAY_TEST_STR;
      break;
    default:
      url = kLIVE_RELESE_STR;
      break;
  }
  return [HTTP_NET_HEADER stringByAppendingString:url];
}

@end



static NSString *ErpNetworkKitDeveloperDebugModeKey = @"ErpNetworkKitDeveloperDebugModeKey";


@implementation APPDebug

+ (void)saveDebugModeStatus:(NSInteger)status {
//#if TEST_ENV_QA
  //  0-正式生产环境 1-本地测试环境 2-公司测试服务器 3-灰度测试环境
//  UserDefaultSetObjectForKey(@(status), ErpNetworkKitDeveloperDebugModeKey);
  DEBUGMODE = status;
//#endif
}

+ (NSInteger)getDebugModeStatus {
//#if TEST_ENV_QA
  //  0-正式生产环境 1-本地测试环境 2-公司测试服务器 3-灰度测试环境
//  NSNumber *num = UserDefaultObjectForKey(ErpNetworkKitDeveloperDebugModeKey);
//  if (num) {
//    return [num integerValue];
//  } else {
    return DEBUGMODE;
//  }
//#endif
  
//#if TEST_ENV_PRODUCTION
//  return 0;
//#endif
}


+ (void)setNetHeader:(NSString *)header {
  HTTP_NET_HEADER = header;
}

+ (NSString *)getNetHeader {
  return HTTP_NET_HEADER;
}

+ (NSString *)getDebugDescription {
  NSInteger status = [self getDebugModeStatus];
  
  NSString *envir;
  switch (status) {
    case 0:  // 生产环境
      envir = @"生产环境";
      break;
    case 1:   // 本地开发环境
      envir = @"dev";
      break;
    case 2:    // 公司测试服务器
      envir = @"test";
      break;
    case 3:     // 灰度测试环境
      envir = @"灰度";
      break;
    default:
      envir = @"生产环境";
      break;
  }
//  // FIXME: 这里加入动态配置接口的逻辑
//  NSString *dynPath = [APPDebug getDynamicPath];
//  if (dynPath) {
//    return @"自定义";
//  }
  
  return [NSString stringWithFormat:@"%@",envir];
}

+ (NSString *)envirDetailInfo {
  NSMutableArray *arr = @[].mutableCopy;
  [arr addObject:[NSString stringWithFormat:@"所处环境:%@ (%@)",[APPDebug getDebugDescription],[XKAPPNetworkConfig getDynamicMainBaseUrl]]];
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  [arr addObject:[NSString stringWithFormat:@"verion:%@",app_Version]];
  // app build版本
  NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
  [arr addObject:[NSString stringWithFormat:@"buildVerion:%@",app_build]];
  //手机系统版本
  NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
  [arr addObject:[NSString stringWithFormat:@"手机系统版本:%@",phoneVersion]];
  //手机型号
  [arr addObject:[NSString stringWithFormat:@"手机型号:%@",[APPDebug currentModel]]];
  return [arr componentsJoinedByString:@"\n"];
}


+ (NSString *)currentModel {
  return (NSString *)[[XKDeviceDataLibrery sharedLibrery] getDiviceName];
}



/**使用动态地址*/
+ (void)addDynamicPath:(NSString *)path {
  [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"getDynamicPath"];
}

+ (void)remvoeDynamicPath {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"getDynamicPath"];
}
/**得到动态地址*/
+ (NSString *)getDynamicPath {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"getDynamicPath"];
}
@end
