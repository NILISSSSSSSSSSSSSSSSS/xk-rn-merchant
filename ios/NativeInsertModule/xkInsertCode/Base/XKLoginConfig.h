/*******************************************************************************
 # File        : XKLoginConfig.h
 # Project     : XKSquare
 # Author      : Lin Li
 # Created     : 2018/9/18
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

@interface XKLoginConfig : NSObject

/**
 退出登录的配置
 */
+ (void)loginDropOutConfig;


/**
 登录之后的配置
 */
+ (void)loginConfig;

/**
 自动登录之后的配置
 */
+ (void)autoLoginConfig:(BOOL)autoLogin;

@end
